--[[
ReaScript Name: Move time selection and selected contents by grid (auto-select when none, optimized)
Description: Moves only selected items, automation items, and envelope points by one grid division. 
             If nothing is selected, auto-selects all contents in time selection first.
Author: ChatGPT (optimized variant)
Version: 1.2
--]]

local r = reaper

--------------------------------------
-- USER SETTINGS
--------------------------------------
-- Direction: 1 = right, -1 = left
-- (Hold Shift to move left if JS_ReaScriptAPI is installed)
local direction = 1
--------------------------------------

-- Detect Shift key (optional)
-- if r.JS_Mouse_GetState and (r.JS_Mouse_GetState(4) & 8 ~= 0) then
    -- direction = -1
-- end

-- Get time selection
local start_time, end_time = r.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
if not start_time or start_time == end_time then
    -- r.ShowMessageBox("No time selection found.", "Move selection & selected contents", 0)
    return
end

-- Require BR helper
if direction > 0 and type(r.BR_GetNextGridDivision) ~= "function" then
    r.ShowMessageBox("Missing BR functions. Please install SWS/BR.", "Error", 0)
    return
elseif direction < 0 and type(r.BR_GetPrevGridDivision) ~= "function" then
    r.ShowMessageBox("Missing BR functions. Please install SWS/BR.", "Error", 0)
    return
end

-- Determine next/previous grid
local grid_func = (direction > 0) and r.BR_GetNextGridDivision or r.BR_GetPrevGridDivision
local length = end_time - start_time
local new_start = grid_func(start_time + (direction > 0 and 1e-9 or -1e-9))
if new_start < 0 then new_start = 0 end
local new_end = new_start + length
local offset = new_start - start_time



r.Undo_BeginBlock()
r.PreventUIRefresh(1)

----------------------------------------------------
-- STEP 1: Check if there are selected items
----------------------------------------------------
local has_selection = (r.CountSelectedMediaItems(0) > 0)

-- Function: Select all items and automation in time selection
local function select_contents_in_time_selection()
    local num_tracks = r.CountTracks(0)
    for t = 0, num_tracks - 1 do
        local track = r.GetTrack(0, t)
        local item_count = r.CountTrackMediaItems(track)
        for i = 0, item_count - 1 do
            local item = r.GetTrackMediaItem(track, i)
            local pos = r.GetMediaItemInfo_Value(item, "D_POSITION")
            local len = r.GetMediaItemInfo_Value(item, "D_LENGTH")
            local item_end = pos + len
            if item_end > start_time and pos < end_time then
                r.SetMediaItemSelected(item, true)
            end
        end
    end

    -- Select automation items and envelope points overlapping
    for t = 0, num_tracks - 1 do
        local track = r.GetTrack(0, t)
        local env_count = r.CountTrackEnvelopes(track)
        for e = 0, env_count - 1 do
            local env = r.GetTrackEnvelope(track, e)
            local needs_sort = false

            -- Select automation items
            local ai_count = r.CountAutomationItems(env)
            for i = 0, ai_count - 1 do
                local ai_pos = r.GetSetAutomationItemInfo(env, i, "D_POSITION", 0, false)
                local ai_len = r.GetSetAutomationItemInfo(env, i, "D_LENGTH", 0, false)
                local ai_end = ai_pos + ai_len
                if ai_end > start_time and ai_pos < end_time then
                    r.GetSetAutomationItemInfo(env, i, "D_UISEL", 1, true)
                end
            end

            -- Select envelope points
            local point_count = r.CountEnvelopePoints(env)
            for i = 0, point_count - 1 do
                local ok, time, _, _, _, _ = r.GetEnvelopePoint(env, i)
                if ok and time >= start_time and time <= end_time then
                    r.SetEnvelopePoint(env, i, time, nil, nil, nil, true, true)
                    needs_sort = true
                end
            end
            if needs_sort then r.Envelope_SortPoints(env) end
        end
    end
end

-- If no selection, select items in time selection
if not has_selection then
    select_contents_in_time_selection()
end

----------------------------------------------------
-- STEP 2: Move only selected contents
----------------------------------------------------
-- Move selected media items
local count = r.CountSelectedMediaItems(0)
for i = 0, count - 1 do
    local item = r.GetSelectedMediaItem(0, i)
    local pos = r.GetMediaItemInfo_Value(item, "D_POSITION")
    r.SetMediaItemInfo_Value(item, "D_POSITION", pos + offset)
end

-- Move selected automation items & envelope points
local num_tracks = r.CountTracks(0)
for t = 0, num_tracks - 1 do
    local track = r.GetTrack(0, t)
    local env_count = r.CountTrackEnvelopes(track)
    for e = 0, env_count - 1 do
        local env = r.GetTrackEnvelope(track, e)
        local needs_sort = false

        -- Move selected automation items
        local ai_count = r.CountAutomationItems(env)
        for i = 0, ai_count - 1 do
            local sel = r.GetSetAutomationItemInfo(env, i, "D_UISEL", 0, false)
            if sel == 1 then
                local ai_pos = r.GetSetAutomationItemInfo(env, i, "D_POSITION", 0, false)
                r.GetSetAutomationItemInfo(env, i, "D_POSITION", ai_pos + offset, true)
            end
        end

        -- Move selected envelope points
        local point_count = r.CountEnvelopePoints(env)
        for i = point_count - 1, 0, -1 do
            local ok, time, value, shape, tension, sel = r.GetEnvelopePoint(env, i)
            if ok and sel then
                r.SetEnvelopePoint(env, i, time + offset, value, shape, tension, sel, true)
                needs_sort = true
            end
        end
        if needs_sort then r.Envelope_SortPoints(env) end
    end
end

----------------------------------------------------
-- STEP 3: Move time selection
----------------------------------------------------
r.GetSet_LoopTimeRange2(0, true, false, new_start, new_end, false)



r.PreventUIRefresh(-1)
r.UpdateArrange()
r.Undo_EndBlock("Move time selection and selected contents by grid (optimized)", -1)

--[[
ReaScript Name: Move selected items to time selection start
Description: Moves all selected items so that their earliest start aligns to the time selection start.
Author: ChatGPT (for REAPER)
Version: 1.0
--]]

local r = reaper

-- Get time selection
local start_time, end_time = r.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
if not start_time or start_time == end_time then
    r.ShowMessageBox("No time selection found.", "Move items to time selection start", 0)
    return
end

-- Count selected items
local count = r.CountSelectedMediaItems(0)
if count == 0 then
    r.ShowMessageBox("No items selected.", "Move items to time selection start", 0)
    return
end

-- Find earliest item position
local earliest = math.huge
for i = 0, count - 1 do
    local item = r.GetSelectedMediaItem(0, i)
    local pos = r.GetMediaItemInfo_Value(item, "D_POSITION")
    if pos < earliest then earliest = pos end
end

-- Calculate offset to move items
local offset = start_time - earliest

-- Apply offset
r.Undo_BeginBlock()
for i = 0, count - 1 do
    local item = r.GetSelectedMediaItem(0, i)
    local pos = r.GetMediaItemInfo_Value(item, "D_POSITION")
    r.SetMediaItemInfo_Value(item, "D_POSITION", pos + offset)
end

r.UpdateArrange()
r.Undo_EndBlock("Move items to time selection start", -1)

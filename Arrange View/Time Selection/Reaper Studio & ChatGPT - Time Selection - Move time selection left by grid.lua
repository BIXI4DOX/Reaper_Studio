--[[
ReaScript Name: Move time selection left by one grid division
Description: Shift current time selection to the left by the previous grid division, preserving length.
Author: ChatGPT (adapted for REAPER)
--]]

local r = reaper

-- get current time selection
local start_time, end_time = r.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
if not start_time or start_time == end_time then
    -- r.ShowMessageBox("No time selection found.", "Move time selection", 0)
    return
end

-- require BR helper
if type(r.BR_GetPrevGridDivision) ~= "function" then
    r.ShowMessageBox("This script requires the BR/SWS helper functions (BR_GetPrevGridDivision). Please install the SWS extension.", "Missing dependency", 0)
    return
end

local length = end_time - start_time

-- find previous grid division before current start
local prevGrid = r.BR_GetPrevGridDivision(start_time)
-- if prevGrid is >= start_time (unlikely) step slightly left
if prevGrid >= start_time then
    prevGrid = r.BR_GetPrevGridDivision(start_time - 1e-9)
end

-- set new selection preserving length
local new_start = prevGrid
local new_end = new_start + length

-- Prevent potential negative values and clamp it at 0 
-- when moving time selection to the start of project, only relevant here as the right is not needed.
if new_start < 0 then new_start = 0 end 

r.Undo_BeginBlock()
r.GetSet_LoopTimeRange2(0, true, false, new_start, new_end, false)
r.UpdateArrange()
r.Undo_EndBlock("Move time selection left by grid", -1)

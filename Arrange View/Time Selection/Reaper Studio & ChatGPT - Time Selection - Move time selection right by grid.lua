--[[
ReaScript Name: Move time selection right by one grid division
Description: Shift current time selection to the right by the next grid division, preserving length.
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
if type(r.BR_GetNextGridDivision) ~= "function" then
    r.ShowMessageBox("This script requires the BR/SWS helper functions (BR_GetNextGridDivision). Please install the SWS extension.", "Missing dependency", 0)
    return
end

local length = end_time - start_time

-- find the next grid division *after* the current start
local nextGrid = r.BR_GetNextGridDivision(start_time)
-- if nextGrid equals start_time (unlikely) move to next of that
if nextGrid <= start_time then
    nextGrid = r.BR_GetNextGridDivision(start_time + 1e-9)
end

-- set new selection preserving length
local new_start = nextGrid
local new_end = new_start + length




r.Undo_BeginBlock()
r.GetSet_LoopTimeRange2(0, true, false, new_start, new_end, false)
r.UpdateArrange()
r.Undo_EndBlock("Move time selection right by grid", -1)

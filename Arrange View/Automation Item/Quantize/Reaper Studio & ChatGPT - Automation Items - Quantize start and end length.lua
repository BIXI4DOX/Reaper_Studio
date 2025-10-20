--[[
ReaScript Name: Adjust Automation Item Start and End to Grid
Description: Snaps both the start and end of selected automation items to the nearest grid lines.
Author: BIXI DOX & ChatGPT (GPT-5)
Version: 1.0
--]]

local r = reaper

--[[==================================================================================================]]--
local function adjustAIStartAndEndToGrid()                                                              --
    local count_tracks = r.CountTracks(0)                                                               --
    if count_tracks == 0 then return end                                                                --
                                                                                                        --
    r.Undo_BeginBlock()                                                                                 --
                                                                                                        --
    for t = 0, count_tracks - 1 do                                                                      --
        local track = r.GetTrack(0, t)                                                                  --
        local env_count = r.CountTrackEnvelopes(track)                                                  --
                                                                                                        --
        for e = 0, env_count - 1 do                                                                     --
            local env = r.GetTrackEnvelope(track, e)                                                    --
            local ai_count = r.CountAutomationItems(env)                                                --
                                                                                                        --
            for i = 0, ai_count - 1 do                                                                  --
                if r.GetSetAutomationItemInfo(env, i, "D_UISEL", 0, false) == 1 then                    --
                    local pos = r.GetSetAutomationItemInfo(env, i, "D_POSITION", 0, false)              --
                    local len = r.GetSetAutomationItemInfo(env, i, "D_LENGTH", 0, false)                --
                                                                                                        --
                    local end_pos = pos + len                                                           --
                    local new_start = r.SnapToGrid(0, pos)                                              --
                    local new_end = r.SnapToGrid(0, end_pos)                                            --
                    local new_len = new_end - new_start                                                 --
                                                                                                        --
                    if new_len < 0 then new_len = 0 end                                                 --
                                                                                                        --
                    r.GetSetAutomationItemInfo(env, i, "D_POSITION", new_start, true)                   --
                    r.GetSetAutomationItemInfo(env, i, "D_LENGTH", new_len, true)                       --
                end                                                                                     --
            end                                                                                         --
        end                                                                                             --
    end                                                                                                 --
                                                                                                        --
    r.UpdateArrange()                                                                                   --
    r.Undo_EndBlock("Adjust automation item start and end to grid", -1)                                 --
end                                                                                                     --
--[[==================================================================================================]]--
adjustAIStartAndEndToGrid()


--[[
ReaScript Name: Adjust Automation Item Start to Grid
Description: Snaps the start of selected automation items to the nearest grid line while keeping the end fixed.
Author: BIXI DOX & ChatGPT (GPT-5)
Version: 1.0
--]]

local r = reaper

--[[==================================================================================================]]--
local function adjustAIStartToGrid()                                                                    --
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
                    local end_pos = pos + len                                                           --
                                                                                                        --
                    local new_pos = r.SnapToGrid(0, pos)                                                -- snap start to grid  
                    local new_len = end_pos - new_pos                                                   --
                                                                                                        --
                    if new_len < 0 then new_len = 0 end                                                 --
                                                                                                        --
                    r.GetSetAutomationItemInfo(env, i, "D_POSITION", new_pos, true)                     --
                    r.GetSetAutomationItemInfo(env, i, "D_LENGTH", new_len, true)                       --
                end                                                                                     --
            end                                                                                         --
        end                                                                                             --
    end                                                                                                 --
                                                                                                        --
    r.UpdateArrange()                                                                                   --
    r.Undo_EndBlock("Adjust automation item start to grid", -1)                                         --
end                                                                                                     --
--[[==================================================================================================]]--
adjustAIStartToGrid()


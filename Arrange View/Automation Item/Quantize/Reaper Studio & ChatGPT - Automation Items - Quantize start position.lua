--[[
ReaScript Name: Move Automation Items Start to Nearest Grid Position
Description: Moves selected automation items so their start positions align with the nearest grid line, preserving length.
Author: BIXI DOX & ChatGPT (GPT-5)
Version: 1.0
--]]

local r = reaper

--[[==================================================================================================]]--
local function moveAI_StartToNearestGrid()                                                              --
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
                    -- snap start position to grid (move whole item)                                    --
                    local new_pos = r.SnapToGrid(0, pos)                                                --
                                                                                                        --
                    if new_pos ~= pos then                                                              --
                        r.GetSetAutomationItemInfo(env, i, "D_POSITION", new_pos, true)                 --
                    end                                                                                 --
                end                                                                                     --
            end                                                                                         --
        end                                                                                             --
    end                                                                                                 --
                                                                                                        --
    r.UpdateArrange()                                                                                   --
    r.Undo_EndBlock("Move automation items to nearest grid position", -1)                               --
end                                                                                                     --
--[[==================================================================================================]]--
moveAI_StartToNearestGrid()


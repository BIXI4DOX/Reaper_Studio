-- @description: Move selected automation items by grid
-- @version: 1.0
-- @author: BIXIDOX
-- @assistant: GPT-5
-- @changelog: Initial release
-- @about:
--   Moves selected automation items left or right by one grid division.
--   Adjust `direction` to +1 or -1, or wrap this in custom actions for both.




--[[==================================================================================================================================================================]]--
                                                                                                                                                                        --
local r = reaper                                                                                                                                                        -- Just to make writing reaper's api easier.
                                                                                                                                                                        --
--==== USER CONFIG ====================================--                                                                                                               --
                                                       --                                                                                                               --
local direction = 1                                    --                                                                                                               -- 1 = move right, -1 = move left
                                                       --                                                                                                               --
--=====================================================--                                                                                                               --
                                                                                                                                                                        --
                                                                                                                                                                        --
                                                                                                                                                                        --
                                                                                                                                                                        --
-- Get grid size at current tempo/time signature --                                                                                                                     --
--[[==================================================]]--                                                                                                              --
                                                        --                                                                                                              --
local function getGrid()                                --                                                                                                              --
    local _, division = r.GetSetProjectGrid(0, false)   --                                                                                                              --
    return division                                     --                                                                                                              --
end                                                     --                                                                                                              --
                                                        --                                                                                                              --
--[[==================================================]]--                                                                                                              --
                                                                                                                                                                        --
                                                                                                                                                                        --
                                                                                                                                                                        --
                                                                                                                                                                        --
--  Snap to grid helper --                                                                                                                                              --
--[[============================]]--                                                                                                                                    --
                                  --                                                                                                                                    --
local function snapToGrid(time)   --                                                                                                                                    --
    return r.SnapToGrid(0, time)  --                                                                                                                                    --
end                               --                                                                                                                                    --
                                  --                                                                                                                                    --
--[[============================]]--                                                                                                                                    --
                                                                                                                                                                        --
                                                                                                                                                                        --
                                                                                                                                                                        --
                                                                                                                                                                        --
--[[========================================================================================================]]--                                                        --
                                                                                                              --                                                        --
r.Undo_BeginBlock()                                                                                           --                                                        --
                                                                                                              --                                                        --
--[[========================================================================================]]--              --                                                        --
                                                                                              --              --                                                        --
local grid = getGrid()                                                                        --              --                                                        --

for t = 0, r.CountTracks(0)-1 do                                                              --              --                                                        -- Loop through all tracks and envelopes
                                                                                              --              --                                                        --
    local tr = r.GetTrack(0, t)                                                               --              --                                                        --                                                                                              --              --                                                        --

    for e = 0, r.CountTrackEnvelopes(tr)-1 do                                                 --              --                                                        --
                                                                                              --              --                                                        --
        local env = r.GetTrackEnvelope(tr, e)                                                 --              --                                                        --
        local aiCount = r.CountAutomationItems(env)                                           --              --                                                        --                                                                                              --              --                                                        --

        for i = 0, aiCount-1 do                                                               --              --                                                        --

            if r.GetSetAutomationItemInfo(env, i, "D_UISEL", 0, false) == 1 then              --              --                                                        --
                                                                                              --              --                                                        --
                local pos = r.GetSetAutomationItemInfo(env, i, "D_POSITION", 0, false)        --              --                                                        --
                local newPos = pos + grid * direction                                         --              --                                                        --                                                                                              --              --                                                        --

                newPos = snapToGrid(newPos)                                                   --              --                                                        -- optional snapping
                r.GetSetAutomationItemInfo(env, i, "D_POSITION", newPos, true)                --              --                                                        --

            end                                                                               --              --                                                        --
        end                                                                                   --              --                                                        --
    end                                                                                       --              --                                                        --
end                                                                                           --              --                                                        --
                                                                                              --              --                                                        --
--[[========================================================================================]]--              --                                                        --
                                                                                                              --                                                        --
r.Undo_EndBlock("Move selected automation items by grid", -1)                                                 --                                                        --
r.UpdateArrange()                                                                                             --                                                        --
                                                                                                              --                                                        --
--[[========================================================================================================]]--                                                        --
                                                                                                                                                                        --
--[[==================================================================================================================================================================]]--
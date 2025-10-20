-- @description: Shorten selected automation items at end by 1 grid
-- @version: 1.0
-- @author: BIXIDOX
-- @assistant: GPT-5
-- @changelog: Initial release
-- @about:
-- Shortens automation items from the end by one grid division, snapped to project grid.




--[[===================================================================================================================================================]]
                                                                                                                                                       --
local r = reaper                                                                                                                                       -- just to make writing scripts easier by making "Reaper" simply typed "r"
                                                                                                                                                       --
--[[==========================================]]                                                                                                       --
                                              --                                                                                                       --
local function nothing() end                  --                                                                                                       --
local function defer() r.defer(nothing) end   --                                                                                                       --
                                              --                                                                                                       --
--[[==========================================]]                                                                                                       --
                                                                                                                                                       --
                                                                                                                                                       --
                                                                                                                                                       --
                                                                                                                                                       --
--[[=======================================================================================================================]]                          --
                                                                                                                           --                          --
function main()                                                                                                            --                          --
    r.Undo_BeginBlock()                                                                                                    --                          --
                                                                                                                           --                          --
--[[==================================================================================================]]                   --                          --
                                                                                                      --                   --                          --
    local _, grid = r.GetSetProjectGrid(0, false)                                                     --                   --                          --
    local changed = false                                                                             --                   --                          --
                                                                                                      --                   --                          --
    for t = 0, r.CountTracks(0)-1 do                                                                  --                   --                          --
                                                                                                      --                   --                          --
        local tr = r.GetTrack(0, t)                                                                   --                   --                          --
                                                                                                      --                   --                          --
        for e = 0, r.CountTrackEnvelopes(tr)-1 do                                                     --                   --                          --
                                                                                                      --                   --                          --
            local env = r.GetTrackEnvelope(tr, e)                                                     --                   --                          --
                                                                                                      --                   --                          --
            for i = 0, r.CountAutomationItems(env)-1 do                                               --                   --                          --
                                                                                                      --                   --                          --
                if r.GetSetAutomationItemInfo(env, i, "D_UISEL", 0, false) == 1 then                  --                   --                          --
                                                                                                      --                   --                          --
                    local pos  = r.GetSetAutomationItemInfo(env, i, "D_POSITION", 0, false)           --                   --                          --
                    local len  = r.GetSetAutomationItemInfo(env, i, "D_LENGTH", 0, false)             --                   --                          --
                    local endp = pos + len                                                            --                   --                          --
                    local snappedEnd = r.SnapToGrid(0, endp)                                          --                   --                          -- snap current end to grid before adjusting
                    local newEnd = r.SnapToGrid(0, snappedEnd - grid)                                 --                   --                          --
                    local newLen = newEnd - pos                                                       --                   --                          --
                                                                                                      --                   --                          --
                    if newLen > 0 then                                                                --                   --                          --
                                                                                                      --                   --                          --
                        r.GetSetAutomationItemInfo(env, i, "D_LENGTH", newLen, true)                  --                   --                          --
                        changed = true                                                                --                   --                          --
                                                                                                      --                   --                          --
                    end                                                                               --                   --                          --
                end                                                                                   --                   --                          --
            end                                                                                       --                   --                          --
        end                                                                                           --                   --                          --
    end                                                                                               --                   --                          --
                                                                                                      --                   --                          --
--[[==================================================================================================]]                   --                          --
                                                                                                                           --                          --
--[[============================================================================]]                                         --                          --
                                                                                --                                         --                          --
    if changed then                                                             --                                         --                          --
                                                                                --                                         --                          --
        r.UpdateArrange()                                                       --                                         --                          --
        r.Undo_EndBlock("Shorten selected automation items end by 1 grid", -1)  --                                         --                          --
                                                                                --                                         --                          --
    else                                                                        --                                         --                          --
                                                                                --                                         --                          --
        r.Undo_EndBlock("No Automation Items changed", -1)                      --                                         --                          --
                                                                                --                                         --                          --
    end                                                                         --                                         --                          --
                                                                                --                                         --                          --
--[[============================================================================]]                                         --                          --
                                                                                                                           --                          --
    defer()                                                                                                                --                          --
end                                                                                                                        --                          --
                                                                                                                           --                          --
--[[=======================================================================================================================]]                          --
                                                                                                                                                       --
main()                                                                                                                                                 --
                                                                                                                                                       --
--[[===================================================================================================================================================]]

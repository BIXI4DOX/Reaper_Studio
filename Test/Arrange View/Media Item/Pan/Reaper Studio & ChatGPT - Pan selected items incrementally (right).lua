-- @description: Increment Item Take Pan by Custom Amount
-- @version: 1.0
-- @author: BIXIDOX
-- @assistant: GPT-5
-- @changelog: Initial release
-- @about: Adds a value to the pan of the active take in selected items




--[===============================================================================================================================]--
                                                                                                                                   --
--[============================]-- Positive values pan right, negative values pan left                                             --
                                --                                                                                                 --
local pan_increment = 0.1       -- Set the increment amount here (0.1 = 10%)                                                       --
                                --                                                                                                 --
--[============================]-- Change this to your desired step                                                                --
                                                                                                                                   --
                                                                                                                                   --
--[============================]--                                                                                                 --
                                --                                                                                                 --
function clamp(val, min, max)   --                                                                                                 --
                                --                                                                                                 --
  if val < min then             --                                                                                                 --
                                --                                                                                                 --
    return min                  --                                                                                                 --
                                --                                                                                                 --
  end                           --                                                                                                 --
                                --                                                                                                 --
  if val > max then             --                                                                                                 --
                                --                                                                                                 --
    return max                  --                                                                                                 --
                                --                                                                                                 --
  end                           --                                                                                                 --
                                --                                                                                                 --
  return val                    --                                                                                                 --
                                --                                                                                                 --
end                             --                                                                                                 --
                                --                                                                                                 --
--[============================]--                                                                                                 --
                                                                                                                                   --
                                                                                                                                   --
                                                                                                                                   --
                                                                                                                                   --
--[=================================================================================]--                                            --
                                                                                     --                                            --
function main()                                                                      --                                            --
                                                                                     --                                            --
  local num_items = reaper.CountSelectedMediaItems(0)                                --                                            --
                                                                                     --                                            --
  for i = 0, num_items - 1 do                                                        --                                            --
                                                                                     --                                            --
    local item = reaper.GetSelectedMediaItem(0, i)                                   --                                            --
                                                                                     --                                            --
    if item then                                                                     --                                            --
                                                                                     --                                            --
      local take = reaper.GetActiveTake(item)                                        --                                            --
                                                                                     --                                            --
      if take and not reaper.TakeIsMIDI(take) then                                   --                                            --
                                                                                     --                                            --
        local current_pan = reaper.GetMediaItemTakeInfo_Value(take, "D_PAN")         --                                            --
        local new_pan = clamp(current_pan + pan_increment, -1.0, 1.0)                --                                            --
                                                                                     --                                            --
        reaper.SetMediaItemTakeInfo_Value(take, "D_PAN", new_pan)                    --                                            --
                                                                                     --                                            --
      end                                                                            --                                            --
    end                                                                              --                                            --
  end                                                                                --                                            --
end                                                                                  --                                            --
                                                                                     --                                            --
--[=================================================================================]--                                            --
                                                                                                                                   --
                                                                                                                                   --
--[===================================================]--                                                                          --
                                                       --                                                                          --
reaper.Undo_BeginBlock()                               --                                                                          --
                                                       --                                                                          --
main()                                                 --                                                                          --
                                                       --                                                                          --
reaper.UpdateArrange()                                 --                                                                          --
reaper.Undo_EndBlock("Increment item take pan", -1)    --                                                                          --
                                                       --                                                                          --
--[===================================================]--                                                                          --
                                                                                                                                   --
--[===============================================================================================================================]--

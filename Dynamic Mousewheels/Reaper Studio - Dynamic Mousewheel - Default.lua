-- @description Zoom vertically if ruler is at mouse (otherwise scroll horizontally/adjust item's/active take gains)
-- @version 1.0
-- @author BIXI DOX
-- @template me2beats
-- @changelog
--  + init
-- @about
--   Dynamically triggers actions depending on the mouse context
--   and current selection states for items in arrange view.

r = reaper;

--[Native Actions Variables]------------------------------------------------------------------------------
gain_up = 41927 -- Take: Nudge active takes volume +1dB
gain_down = 41926 -- Take: Nudge active takes volume -1dB
zoom_in_horizontal = 1012 -- View: Zoom in horizontal
zoom_out_horizontal = 1011 -- View: Zoom out horizontal

--[Script Actions Variables]------------------------------------------------------------------------------
move_time_selection_and_item_left = r.NamedCommandLookup("_RS871e1c721fc40a67ab2c83d502300caca15c4768")
move_time_selection_and_item_right = r.NamedCommandLookup("_RScd52602d5f3a48e0c3107ba930d388c25982b3f0")



--======== Utility Functions ==========--
----------------------
function nothing()  --
end;                --
----------------------

--------------------------
function blank()        --
--------------------------
    r.defer(nothing)    --
--------------------------
end                     --
--------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------
function Dynamic_Mousewheel()                                                                                                                       --
------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                                                                                                    --
    local function action(id)                                                                                                                       --
        r.Main_OnCommand(id, 0)                                                                                                                     --
    end                                                                                                                                             --
                                                                                                                                                    --
    local _,_,_,_,_,_,val = r.get_action_context()                                                                                                  --
    local selected_count = r.CountSelectedMediaItems(0)                                                                                             --
    local window, segment, details = r.BR_GetMouseCursorContext()                                                                                   --
    if window == 'ruler' and segment == 'timeline' then                                                                                             --
        if val > 0 then                                                                                                                             --
            action(move_time_selection_and_item_left)                                                                                               --
        else                                                                                                                                        --
            action(move_time_selection_and_item_right)                                                                                              --
        end                                                                                                                                         --
                                                                                                                                                    --
                                                                                                                                                    --
                                                                                                                                                    --
    elseif selected_count > 0 and details == 'item' then                                                                                            --
        local item = r.BR_GetMouseCursorContext_Item()                                                                                              --
        local item_selected = r.IsMediaItemSelected(item, 0)                                                                                        --
        if val > 0 and item_selected  then                                                                                                          --
            action(gain_up)                                                                                                                         --
        elseif val < 0 and item_selected  then                                                                                                      --
            action(gain_down)                                                                                                                       --
        elseif val > 0 then                                                                                                                         -- If no item is selected and mouse hovers over any item, it does the default behaviour of the script    =--
            action(zoom_in_horizontal)                                                                                                              --
        elseif val < 0 then                                                                                                                         --
            action(zoom_out_horizontal)                                                                                                             --
        end                                                                                                                                         --
                                                                                                                                                    --
                                                                                                                                                    --
                                                                                                                                                    --
    elseif window == 'arrange' or (window == 'ruler' and (segment == 'region_lane' or segment == 'marker_lane' or segment == 'tempo_lane')) then    -- Zoom horizontally in arrange view & ruler regions.
        if val > 0 then                                                                                                                             --
            action(zoom_in_horizontal)                                                                                                              --
            action(zoom_in_horizontal)                                                                                                              --
            action(zoom_in_horizontal)                                                                                                              --
        else                                                                                                                                        --
            action(zoom_out_horizontal)                                                                                                             --
            action(zoom_out_horizontal)                                                                                                             --
            action(zoom_out_horizontal)                                                                                                             --
        end                                                                                                                                         --
    else                                                                                                                                            --
        nothing()                                                                                                                                   --
    end                                                                                                                                             --
                                                                                                                                                    --
------------------------------------------------------------------------------------------------------------------------------------------------------
end                                                                                                                                                 --
------------------------------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------
r.Undo_BeginBlock()                                                                                         --
r.PreventUIRefresh( 1 )                                                                                     --
--------------------------------------------------------------------------------------------------------------
                                                                                                            --
    Dynamic_Mousewheel()                                                                                    --
    blank()                                                                                                 --
                                                                                                            --
--------------------------------------------------------------------------------------------------------------
r.UpdateArrange()                                                                                           --
r.PreventUIRefresh( -1 )                                                                                    --
r.Undo_EndBlock('Dynamic Mousewheel - Default', 2)                                                          --
--------------------------------------------------------------------------------------------------------------
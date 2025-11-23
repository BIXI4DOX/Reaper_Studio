-- @description Scroll horizontally in arrange view or Move selected tracks up or down in track control panel, (otherwise, if items are selected, Adjust pitch by semitone with mousewheel)
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
pitch_semitone_up = 40204 -- Item properties: Pitch item up one semitone
pitch_semitone_down = 40205 -- Item properties: Pitch item down one semitone

--[Script Actions Variables]------------------------------------------------------------------------------
scroll_view_left_10 = r.NamedCommandLookup("_SWS_SCROLL_L10")
scroll_view_right_10 = r.NamedCommandLookup("_SWS_SCROLL_R10")
move_selected_tracks_up = r.NamedCommandLookup("_RS0f5e45f10c2d92595ec362c9f9afd84f2a541e32")
move_selected_tracks_down = r.NamedCommandLookup("_RSf6067c3d6a316b74acefe1c7689bffca84959eae")
move_time_selection_left = r.NamedCommandLookup("_RS65aa95c3f1c047e6fefb2244a2ec5288dc3f7d4a")
move_time_selection_right = r.NamedCommandLookup("_RS7d3498496f439fec961be55cd769b46a7fa64ce0")



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
            action(move_time_selection_left)                                                                                                        --
        else                                                                                                                                        --
            action(move_time_selection_right)                                                                                                       --
        end                                                                                                                                         --
                                                                                                                                                    --
                                                                                                                                                    --
                                                                                                                                                    --
    elseif selected_count > 0 and details == 'item' then                                                                                            --
        local item = r.BR_GetMouseCursorContext_Item()                                                                                              --
        local item_selected = r.IsMediaItemSelected(item, 0)                                                                                        --
        if val > 0 and item_selected  then                                                                                                          --
            action(pitch_semitone_up)                                                                                                               --
        elseif val < 0 and item_selected  then                                                                                                      --
            action(pitch_semitone_down)                                                                                                             --
        elseif val > 0 then                                                                                                                         -- If no item is selected and mouse hovers over any item, it does the default behaviour of the script    =--
            action(scroll_view_left_10)                                                                                                             --
        elseif val < 0 then                                                                                                                         --
            action(scroll_view_right_10)                                                                                                            --
        end                                                                                                                                         --
                                                                                                                                                    --
                                                                                                                                                    --
                                                                                                                                                    --
    elseif window == 'tcp' then                                                                                                                     --
        if val > 0 then                                                                                                                             --
            action(move_selected_tracks_up)                                                                                                         --
        else                                                                                                                                        --
            action(move_selected_tracks_down)                                                                                                       --
        end                                                                                                                                         --
                                                                                                                                                    --
                                                                                                                                                    --
                                                                                                                                                    --
    elseif window == 'arrange' or (window == 'ruler' and (segment == 'region_lane' or segment == 'marker_lane' or segment == 'tempo_lane')) then    -- Zoom horizontally in arrange view & ruler regions.
        if val > 0 then                                                                                                                             --
            action(scroll_view_left_10)                                                                                                             --
            action(scroll_view_left_10)                                                                                                             --
        else                                                                                                                                        --
            action(scroll_view_right_10)                                                                                                            --
            action(scroll_view_right_10)                                                                                                            --
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
r.Undo_EndBlock('Dynamic Mousewheel - First Modifier', 2)                                                   --
--------------------------------------------------------------------------------------------------------------
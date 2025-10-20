-- @description Script: Scroll horizontally in arrange view or Move selected tracks up or down in track control panel, (otherwise, if items are selected, Adjust pitch by semitone with mousewheel)
-- @version 1.0
-- @author me2beats
-- @editor BIXI DOX
-- @changelog
--  + init

local r = reaper; 
local function nothing() end; 
local function bla() r.defer(nothing) end

function act(id) r.Main_OnCommand(reaper.NamedCommandLookup(id), 0) end
function act2(id2) r.Main_OnCommand(id2, 0) end



--=V=-- Global Variables
_,_,_,_,_,_,val = r.get_action_context()
selected_count = r.CountSelectedMediaItems(0)
--=V=--

r.Undo_BeginBlock()
r.PreventUIRefresh( 1 )
local window, segment, details = r.BR_GetMouseCursorContext()





--//////////////////////////////////////////////////////////////////////--
-- Move selected tracks up/down when hovering over Track control panel. --
--//////////////////////////////////////////////////////////////////////--
--=@=-- BIXI DOX                                                        --
                                                                        --
if window == 'tcp' then                                                 --
  if val > 0 then                                                       --
    act("_RS0f5e45f10c2d92595ec362c9f9afd84f2a541e32")                  --
    act2(40913)                                                         --
  else                                                                  --
    act("_RSf6067c3d6a316b74acefe1c7689bffca84959eae")                  --
    act2(40913)                                                         --
  end                                                                   --
  
  elseif window == 'ruler' then                                                 --
    if val > 0 then                                                       --
      act("_RS65aa95c3f1c047e6fefb2244a2ec5288dc3f7d4a")                  --
      act2(40913)                                                         --
    else                                                                  --
      act("_RS7d3498496f439fec961be55cd769b46a7fa64ce0")                  --
      act2(40913)                                                         --
    end                                                                   --
--//////////////////////////////////////////////////////////////////////--
--//////////////////////////////////////////////////////////////////////--

--//////////////////////////////////////////////////////////////////////--
--  Pitch item's pitch up/down by semitones when hovering over them.    --
--//////////////////////////////////////////////////////////////////////--
-- BIXI DOX                                                             --
elseif selected_count > 0 and details == 'item' then                    --
                                                                        --
  --=v=-- Variables                                                     --
  local item = r.BR_GetMouseCursorContext_Item()                        --
  local item_selected = r.IsMediaItemSelected(item, 0)                  --
  --=v=--                                                               --
                                                                        --
                                                                        --
                                                                        --
                                                                        --
--=U=-- This is just peak.                                              --
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
  -- If there's items selected, Shift + Mousewheel to pitch items up down by semitones, overrides Horizontal scroll. --=@=-- BIXI DOX
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
                                                                                                                          --
  if val > 0 and item_selected  then                                                                                      --
      act2(40204, 0) -- Item properties: Pitch item up one semitone                                                       --
    elseif val < 0 and item_selected  then                                                                                --
      act2(40205, 0) -- Item properties: Pitch item down one semitone                                                     --
                                                                                                                          --
      ----------------------------------------------------------------------------------------------------------------------
      --=               If no item is selected and mouse hovers over any item, horizontally scroll.                      =--
      ----------------------------------------------------------------------------------------------------------------------
                                                                                                                          --
      elseif val > 0 then                                                                                                 --
        act("_SWS_SCROLL_L10")                                                                                            --  
        act("_SWS_SCROLL_L10")                                                                                            --  
      elseif val < 0 then                                                                                                 --
        act("_SWS_SCROLL_R10")                                                                                            --
        act("_SWS_SCROLL_R10")                                                                                            --
        else                                                                                                              --
      end                                                                                                                 --
                                                                                                                          --
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--


-----------------------------------------------------------------------------------------
-- Horizontal scroll when hovering over arrange view (no items selected)or ruler. --=@=-- BIXI DOX
-----------------------------------------------------------------------------------------

elseif window == 'arrange' then
  if val > 0 then 
    act("_SWS_SCROLL_L10") 
    act("_SWS_SCROLL_L10") 
  else 
    act("_SWS_SCROLL_R10")
    act("_SWS_SCROLL_R10")
  end
bla() end

---------------------------------------------------------------------------------------------------------------------------------------------------
-- I've been struggling to figure out why the pitching item up down on mouse hover doesn't work.
-- As it turns out, to make them work, it has to be placed in the correct order! simply putting at the second, gosh darn scripting logics.  --=@=-- BIXI DOX
-- And just like that, this feature is now possible! although there's some adjustments being made to make it "just right"
---------------------------------------------------------------------------------------------------------------------------------------------------

r.PreventUIRefresh( -1 )
r.Undo_EndBlock('Scroll horizontally, Move tracks up/down, Pitch items up & down by semitones', 2)
r.UpdateArrange()







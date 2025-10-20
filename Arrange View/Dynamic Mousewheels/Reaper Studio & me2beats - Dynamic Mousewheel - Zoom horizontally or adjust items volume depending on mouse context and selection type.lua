-- @description Zoom vertically if ruler is at mouse (otherwise scroll horizontally/adjust item's/active take gains)
-- @version 1.0
-- @author me2beats
-- @editor BIXI DOX
-- @changelog
--  + init

local r = reaper; 
local function nothing() end; 
local function bla() r.defer(nothing) end

function act(id) r.Main_OnCommand(id, 0) end

--=V=-- Global Variables
_,_,_,_,_,_,val = r.get_action_context()
selected_count = r.CountSelectedMediaItems(0)
--=V=-- 


r.Undo_BeginBlock()

--=v=-- Variables
local window, segment, details = r.BR_GetMouseCursorContext()
--=v=--

--if window ~= 'ruler' then

local move_time_selection_and_item_left = r.NamedCommandLookup("_RS871e1c721fc40a67ab2c83d502300caca15c4768")
local move_time_selection_and_item_right = r.NamedCommandLookup("_RScd52602d5f3a48e0c3107ba930d388c25982b3f0")

local move_track_previous = r.NamedCommandLookup("_RS0f5e45f10c2d92595ec362c9f9afd84f2a541e32")
local move_track_next = r.NamedCommandLookup("_RSf6067c3d6a316b74acefe1c7689bffca84959eae")



----------------------------------------------------
--=!=-- Zoom horizontally at ruler. --=!=--
----------------------------------------------------
if window == 'ruler' then 
  if val > 0 then 
  act(move_time_selection_and_item_left) -- 
  else 
  act(move_time_selection_and_item_right) -- 
  end

----------------------------------------------------
--=!=-- Adjust selected item's/takes volume. --=!=--
----------------------------------------------------
  elseif selected_count > 0 and details == 'item' then
  
  --=v=-- Variables
  local item = r.BR_GetMouseCursorContext_Item()
  local item_selected = r.IsMediaItemSelected(item, 0)
  --=v=--
  
  --=!=-- So in ChatGPT where they suggested the-
    --=*=-- reaper.IsMediaItemSelected()
  -- They told to put-
    --=*=-- reaper.BR_GetMouseCursorContext_Item()
  -- in the "()"
  -- (which the variable for that in our case is "item")
  -- But one little detail that ChatGPT miss is the "boolean", the number 0 after it.
  -- Without it, it won't work, because it misses the fundamental number that initializes the media item count, which is this case, is the amount of selected item.
  
  
  
      ---------------------------------------------------------------------------------
      --=       If item is selected and mouse hovers over them, adjust volume       =--
      ---------------------------------------------------------------------------------

      if val > 0 and item_selected  then
        act(41927) -- Take: Nudge active takes volume +1dB
      elseif val < 0 and item_selected  then
        act(41926) -- Take: Nudge active takes volume -1dB
        -------------------------------------------------------------------------------
        
        
      ----------------------------------------------------------------------------------------------------------------
      --=    If no item is selected and mouse hovers over any item, it does the default behaviour of the script    =--
      ----------------------------------------------------------------------------------------------------------------
      elseif val > 0 then
        act(1012) -- View: Zoom in horizontal
      elseif val < 0 then
        act(1011) -- View: Zoom out hoizontal
        else
      end
      ---------------------------------------------------------------------------------
      
      
      


----------------------------------------------------
--=!=-- Zoom horizontally in arrange view. --=!=--
----------------------------------------------------
  
  elseif window == 'arrange' then
    if val > 0 then 
    act(1012) -- View: Zoom in horizontal
    else 
    act(1011) -- View: Zoom out horizontal
    end
else 
bla() 
end
r.Undo_EndBlock('Zoom horizontally/vertically depending on ArrangeView/Ruler, If item/take selected, adjust volume', 2)

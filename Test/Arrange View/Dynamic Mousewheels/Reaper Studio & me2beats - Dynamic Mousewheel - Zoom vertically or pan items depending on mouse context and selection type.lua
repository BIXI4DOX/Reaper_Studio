-- @description Zoom vertically if ruler is at mouse (otherwise scroll horizontally/adjust item's/active take gains)
-- @version 1.0
-- @author me2beats
-- @editor BIXI DOX
-- @changelog
--  + init

local r = reaper; 
local function nothing() end; 
local function bla() r.defer(nothing) end

function act(id) r.Main_OnCommand(r.NamedCommandLookup(id), 0) end

--=V=-- Global Variables
_,_,_,_,_,_,val = r.get_action_context()
selected_count = r.CountSelectedMediaItems(0)
--=V=-- 


r.Undo_BeginBlock()

--=v=-- Variables
local window, segment, details = r.BR_GetMouseCursorContext()
--=v=--

--if window ~= 'ruler' then



----------------------------------------------------
--=!=-- Zoom horizontally at ruler. --=!=--
----------------------------------------------------
if window == 'ruler' then 
  if val > 0 then 
        act(40111) -- View: Zoom in vertical
      else
        act(40112) -- View: Zoom out vertical
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
        act("_RS842043b3893f85a23d3efaa9be4cae17a241688a") -- Script: Reaper Studio & ChatGPT - Pan selected items incrementally (left).lua
      elseif val < 0 and item_selected  then
        act("_RS583bace820ae5d3588317189d3444bf8744de682") -- Script: Reaper Studio & ChatGPT - Pan selected items incrementally (right).lua
        -------------------------------------------------------------------------------
        
        
      ----------------------------------------------------------------------------------------------------------------
      --=    If no item is selected and mouse hovers over any item, it does the default behaviour of the script    =--
      ----------------------------------------------------------------------------------------------------------------
      elseif val > 0 then
        act(40111) -- View: Zoom in vertical
      elseif val < 0 then
        act(40112) -- View: Zoom out vertical
        else
      end
      ---------------------------------------------------------------------------------
      
      
      


----------------------------------------------------
--=!=-- Zoom horizontally in arrange view. --=!=--
----------------------------------------------------
  
  elseif window == 'arrange' then
    if val > 0 then 
        act(40111) -- View: Zoom in vertical
      else
        act(40112) -- View: Zoom out vertical
    end
else 
bla() 
end
r.Undo_EndBlock('Zoom horizontally/vertically depending on ArrangeView/Ruler, If item/take selected, adjust volume', 2)

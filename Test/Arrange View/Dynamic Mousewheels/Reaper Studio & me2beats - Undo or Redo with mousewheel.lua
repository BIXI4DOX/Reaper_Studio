-- @description Undo or Redo (mousewheeel)
-- @version 1.0
-- @author me2beats
-- @changelog
--  + init

local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

-- function act(id) reaper.Main_OnCommand(reaper.NamedCommandLookup(id), 0) end
function act(id) reaper.Main_OnCommand(id, 0) end



_,_,_,_,_,_,val = r.get_action_context()

r.Undo_BeginBlock()

local window, segment, details = r.BR_GetMouseCursorContext() 
--if window ~= 'ruler' then bla() return end
if window == 'tcp' then
  if val > 0 then act(40030) else act(40029) end
elseif window == 'arrange' then
  if val > 0 then act(40030) else act(40029) end
else bla() end
r.Undo_EndBlock('Undo or Redo with mousewheel', 2)


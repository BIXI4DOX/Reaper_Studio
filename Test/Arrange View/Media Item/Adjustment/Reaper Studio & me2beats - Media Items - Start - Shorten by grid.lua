-- @description Trim sel items left edges to nearest grid divisions (increase items length)
-- @version 1.0
-- @author me2beats
-- @changelog
--  + init

function nothing() end
function hello()
  start_pos = reaper.GetMediaItemInfo_Value(it, 'D_POSITION')
  start_grid = reaper.BR_GetNextGridDivision(start_pos)
  reaper.ApplyNudge(1, 1, 1, 0, start_grid, false, 0)
  
  -- Additions by BIXI DOX
  reaper.Main_OnCommand(41173, 0) -- Item navigation: Move cursor to start of items
  reaper.Main_OnCommand(reaper.NamedCommandLookup("_RS5ff25ac8da379e554de8f468eb03ce0e744fc27d"), 0) -- Script: Amely Suncroll Auto Aim Item 3.0 (start).lua
end

items = reaper.CountSelectedMediaItems(0)
if items > 0 then
  script_title = 'Trim sel items left edges to nearest grid divisions (increase items length)'
  reaper.Undo_BeginBlock()
  reaper.PreventUIRefresh(1)
  if items == 1 then
    it = reaper.GetSelectedMediaItem(0, 0)
    hello()
  else
----  save selected items---------------
    t = {}
    for i = 0, items-1 do
      it = reaper.GetSelectedMediaItem(0,i)
      guid = reaper.BR_GetMediaItemGUID(it)
      table.insert(t, guid)
    end
---------------------------------------
    reaper.Main_OnCommand(40289, 0)--  unselect all items
    for i = 1, #t do
      it = reaper.BR_GetMediaItemByGUID(0, t[i])
      reaper.SetMediaItemSelected(it, true)
      hello()      
      reaper.SetMediaItemSelected(it, false)
    end
---- restore sel items-------------------
    for i = 1, #t do
      it = reaper.BR_GetMediaItemByGUID(0, t[i])
      reaper.SetMediaItemSelected(it, true)
    end
-----------------------------------------
  end
  reaper.Undo_EndBlock(script_title, -1)
  reaper.PreventUIRefresh(-1)
else
  reaper.defer(nothing)
end

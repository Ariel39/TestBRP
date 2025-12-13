include( "skins/" .. itemstore.config.Skin .. ".lua" )

for _, filename in ipairs( file.Find( "itemstore/vgui/*.lua", "LUA" ) ) do
	include( "vgui/" .. filename )
end

itemstore.ContextInventory = nil

function itemstore.CreateContextInventory()
	if not itemstore.config.ContextInventory then return end
	if not IsValid( g_ContextMenu ) then return end

	local inv = vgui.Create( "ItemStoreContainerWindow", g_ContextMenu )
	inv:SetTitle( itemstore.Translate( "inventory" ) )
	inv:SetContainerID( LocalPlayer().InventoryID )
	inv:ShowCloseButton( false )
	inv:SetDraggable( false )
	inv:InvalidateLayout( true )

	local side = itemstore.config.ContextInventoryPosition

	if side == "bottom" then
		inv:SetPos( ScrW() / 2 - inv:GetWide() / 2, ScrH() - inv:GetTall() )
	elseif side == "bottomleft" then
		inv:SetPos( 0, ScrH() - inv:GetTall() )
	elseif side == "bottomright" then
		inv:SetPos( ScrW() - inv:GetWide(), ScrH() - inv:GetTall() )
	elseif side == "top" then
		inv:SetPos( ScrW() / 2 - inv:GetWide() / 2, 0 )
	elseif side == "topleft" then
		inv:SetPos( 0, 0 )
	elseif side == "topright" then
		inv:SetPos( ScrW() - inv:GetWide(), 0 )
	elseif side == "left" then
		inv:SetPos( 0, ScrH() / 2 - inv:GetTall() / 2 )
	elseif side == "right" then
		inv:SetPos( ScrW() - inv:GetWide(), ScrH() / 2 - inv:GetTall() / 2 )
	end

	itemstore.ContextInventory = inv
end

hook.Add( "Tick", "ItemStoreHideContextInventory", function()
	if not IsValid( LocalPlayer() ) then return end

	if IsValid( itemstore.ContextInventory ) then 
		itemstore.ContextInventory:SetVisible( LocalPlayer():CanUseInventory() )
	else
		if LocalPlayer().InventoryID then
			itemstore.CreateContextInventory()
		end
	end
end )

hook.Add( "ContextMenuCreated", "ItemStoreInventory", function( context )
	if not IsValid( context ) then return end
	
	context:Receiver( "ItemStore", function( receiver, droppable, dropped )
		local container_id = droppable[ 1 ]:GetContainerID()
		local slot = droppable[ 1 ]:GetSlot()

		if dropped then
			LocalPlayer():DropItem( container_id, slot )
		end
	end )
end )

net.Receive( "ItemStoreRecreateContextMenu", function()
	if IsValid( itemstore.ContextInventory ) then
		itemstore.ContextInventory:Remove()
		itemstore.ContextInventory = nil
	end
end )
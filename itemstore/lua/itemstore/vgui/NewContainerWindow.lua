local PANEL = {}

function PANEL:Init()
	self:SetSkin( "itemstore" )

	self.Container = vgui.Create( "ItemStoreNewContainer", self )
	self.Container:Dock( FILL )
end

function PANEL:Refresh()
	self.Container:Refresh()
end

function PANEL:SetContainerID( id )
	self.Container:SetContainerID( id )

	local con = itemstore.containers.Get( id )
	if not con then return end

	local p = 1
	local sw, sh = 48, 48
	local cw, ch = con:GetWidth(), con:GetHeight()
	local w, h = 10 + ( sw + p ) * cw, 34 + 37 + ( sh + p ) * ch

	self:SetSize( w, h )
end

function PANEL:GetContainerID()
	return self.Container:GetContainerID()
end

vgui.Register( "ItemStoreNewContainerWindow", PANEL, "DFrame" )

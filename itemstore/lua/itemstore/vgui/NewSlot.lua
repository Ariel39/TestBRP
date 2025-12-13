local PANEL = {}

local GradientUp = Material( "gui/gradient_up" )
local GradientDown = Material( "gui/gradient_down" )

AccessorFunc( PANEL, "Item", "Item" )
AccessorFunc( PANEL, "ContainerID", "ContainerID", FORCE_NUMBER )
AccessorFunc( PANEL, "Slot", "Slot", FORCE_NUMBER )

function PANEL:Init()
	self.BaseClass.Init( self )

	self:Droppable( "ItemStore" )
	self:Receiver( "ItemStore", function( receiver, droptable, dropped )
		if not dropped then return end

		local droppable = droptable[ 1 ]
		if droppable == receiver then return end

		local from_con = droppable:GetContainerID()
		local to_con = droppable:GetContainerID()

		if not from_con then return end
		if not to_con then return end

		local from_slot = droppable:GetSlot()
		local to_slot = receiver:GetSlot()

		if not from_slot then return end
		if not to_slot then return end

		local from_item = droppable:GetItem()
		local to_item = receiver:GetItem()

		if from_item and to_item and ( from_item:CanMerge( to_item ) or
			from_item:CanUseWith( to_item ) ) then
			local menu = DermaMenu()

			if from_item:CanUseWith( to_item ) then
				menu:AddOption( itemstore.Translate( "usewith" ), function()
					LocalPlayer():UseItemWith( droppable:GetContainerID(), droppable:GetSlot(),
						receiver:GetContainerID(), receiver:GetSlot() )
				end ):SetIcon( "icon16/wrench_orange.png" )

				menu:AddSpacer()
			end

			menu:AddOption( itemstore.Translate( "move" ), function()
				LocalPlayer():MoveItem( droppable:GetContainerID(), droppable:GetSlot(),
					receiver:GetContainerID(), receiver:GetSlot() )
			end ):SetIcon( "icon16/arrow_switch.png" )

			if from_item:CanMerge( to_item ) then
				menu:AddOption( itemstore.Translate( "merge" ), function()
					LocalPlayer():MergeItem( droppable:GetContainerID(), droppable:GetSlot(),
						receiver:GetContainerID(), receiver:GetSlot() )
				end ):SetIcon( "icon16/arrow_join.png" )
			end

			menu:Open()
		else
			LocalPlayer():MoveItem( droppable:GetContainerID(), droppable:GetSlot(),
				receiver:GetContainerID(), receiver:GetSlot() )
		end
	end )
end

function PANEL:PaintHighlight( w, h )
    if true then return end

	local item = self:GetItem()

	if item and item.HighlightColor then
		local col = Color( item.HighlightColor.r, item.HighlightColor.g, item.HighlightColor.b )
		local bright = Color( col.r * 1.25, col.g * 1.25, col.b * 1.25 )
        local dark = Color( bright.r / 2, bright.g / 2, bright.b / 2 )
        
        local shape = {
            { x = 0, y = 0 },
            { x = w * 0.1, y = 0 },
            { x = 0, y = h * 0.1 }
        }

        draw.NoTexture()
        surface.SetDrawColor( col )
        surface.DrawPoly( shape )
	end
end

PANEL.Vingette = Material( "itemstore/vingette.png" )

function PANEL:PaintBackground( w, h )
    local item = self:GetItem()

    local col = Color( 50, 50, 50, 100 )

    if item then
		col = Color( item.HighlightColor.r, item.HighlightColor.g, item.HighlightColor.b )

		if self:IsDown() then
			col.r = math.min( col.r * 0.75, 255 )
			col.g = math.min( col.g * 0.75, 255 )
			col.b = math.min( col.b * 0.75, 255 )
		elseif self.Hovered then
			col.r = math.min( col.r * 1.25, 255 )
			col.g = math.min( col.g * 1.25, 255 )
			col.b = math.min( col.b * 1.25, 255 )
		end
    end

    surface.SetDrawColor( col )
    surface.DrawRect( 0, 0, w, h ) 

	if item then
		surface.SetMaterial( self.Vingette )
		surface.SetDrawColor( Color( 0, 0, 0, 125 ) )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
end

PANEL.LabelLerp = 0

surface.CreateFont( "ItemStoreSlotLabel", {
	font = "Montserrat",
	size = 18,
	weight = 500
} )

function PANEL:PaintLabel( w, h )
    if w < 100 or self:IsDragging() then return end

    local item = self:GetItem()
    if not item then return end

    self.LabelLerp = Lerp( FrameTime() * 15, self.LabelLerp, self.Hovered and 1 or -0.1 )

    local lw, lh = w, 32
    local lx, ly = 0, h - ( self.LabelLerp * lh )

    surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
    surface.DrawRect( lx, ly, lw, lh )
    draw.SimpleTextOutlined(
        item:GetName(),
        "ItemStoreSlotLabel",
        lw / 2, ly + ( lh / 2 ),
        color_white,
        TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
        1, color_black
    )
end

surface.CreateFont( "ItemStoreAmount", {
	font = "Montserrat",
	size = 18,
	weight = 500
} )

function PANEL:PaintAmount( w, h )
    local item = self:GetItem()

    if item and item:GetAmount() > 1 then
		draw.SimpleTextOutlined(
            item:FormatAmount(),
            "ItemStoreAmount",
            w - w * 0.05 - 2, h * 0.05 - 2,
            color_white,
            TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP,
            1, color_black
        )
	end
end

function PANEL:PaintBorder( w, h )
    surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
    surface.DrawOutlinedRect( 0, 0, w, h )

    surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
    surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )
end

function PANEL:Paint( w, h )
	self:PaintBackground( w, h )

    self.BaseClass.Paint( self, w, h )
    
    self:PaintHighlight( w, h )
    self:PaintAmount( w, h )

    self:PaintLabel( w, h )
    self:PaintBorder( w, h )
end

function PANEL:Refresh()
	local item = self:GetItem()

	if item then
		self:SetModel( item:GetModel() )
		self:SetColor( item:GetColor() or color_white )

		if IsValid( self.Entity ) then
			self.Entity:SetMaterial( item:GetMaterial() )

			local min, max = self.Entity:GetRenderBounds()

			self:SetCamPos( Vector( 0.55, 0.55, 0.55 ) * min:Distance( max ) )
			self:SetLookAt( ( min + max ) / 2 )
		end
	else
		self.Entity = nil
		self:SetTooltip( nil )
	end
end

function PANEL:DoDoubleClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end
	if not item.Use then return end

	LocalPlayer():UseItem( con_id, slot )
end

function PANEL:DoMiddleClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end

	LocalPlayer():DropItem( con_id, slot )
end

function PANEL:DoRightClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end

	local menu = DermaMenu()

	if item.Use then
		menu:AddOption( itemstore.Translate( "use" ), function()
			LocalPlayer():UseItem( con_id, slot )
		end ):SetIcon( "icon16/wrench.png" )

		menu:AddSpacer()
	end

	menu:AddOption( itemstore.Translate( "drop" ), function()
		LocalPlayer():DropItem( con_id, slot )
	end ):SetIcon( "icon16/arrow_out.png" )

	menu:AddOption( itemstore.Translate( "destroy" ), function()
		Derma_Query( itemstore.Translate( "destroy_confirmation" ), itemstore.Translate( "destroy_title" ), itemstore.Translate( "ok" ), function()
			LocalPlayer():DestroyItem( con_id, slot )
		end, itemstore.Translate( "cancel" ) ):SetSkin( "itemstore" )
	end ):SetIcon( "icon16/delete.png" )

	if item:CanSplit( 1 ) then
		menu:AddSpacer()

		local submenu, entry = menu:AddSubMenu( itemstore.Translate( "split" ) )
		entry:SetIcon( "icon16/arrow_divide.png" )

		local half = math.floor( item:GetAmount() / 2 )

		submenu:AddOption( itemstore.Translate( "split_half", half ), function()
			LocalPlayer():SplitItem( con_id, slot, half )
		end )

		submenu:AddSpacer()

		for _, amount in ipairs( { 1, 2, 5, 10, 25, 50, 100, 250, 1000 } ) do
			if item:CanSplit( amount ) then
				submenu:AddOption( amount, function()
					LocalPlayer():SplitItem( con_id, slot, amount )
				end )
			end
		end

		menu:Open()
	end

	item:Run( "PopulateMenu", menu )

	menu:Open()
end

local Tooltip

function PANEL:CreateTooltip()
	if IsValid( Tooltip ) then
		Tooltip:SetVisible( true )
		return
	end

	Tooltip = vgui.Create( "ItemStoreTooltip" )
	self:UpdateTooltip()
end

function PANEL:UpdateTooltip()
	if not IsValid( Tooltip ) then return end

	Tooltip:SetContainerID( self:GetContainerID() )
	Tooltip:SetSlot( self:GetSlot() )
	Tooltip:SetItem( self:GetItem() )
	Tooltip:Refresh()
end

function PANEL:HideTooltip()
	if IsValid( Tooltip ) then Tooltip:SetVisible( false ) end
end

function PANEL:OnCursorEntered()
	if not self:GetItem() then return end

	self:CreateTooltip()
	self:UpdateTooltip()
end

function PANEL:OnCursorMoved()
	if not IsValid( Tooltip ) then return end

	local x, y = gui.MousePos()
	Tooltip:SetPos( x, y - Tooltip:GetTall() )
end

function PANEL:OnCursorExited()
	self:HideTooltip()
end

vgui.Register( "ItemStoreNewSlot", PANEL, "DModelPanel" )

local blur = Material( "pp/blurscreen" )
local gradient_up = Material( "gui/gradient_up" )
local gradient_down = Material( "gui/gradient_down" )

concommand.Add( "itemstore_test", function()
    local lerp = 0

	-- todo: move this to it's own vgui element
	local frame = vgui.Create( "EditablePanel" )
	frame:DockPadding( 10, ScrH() * 0.1 + 10, 10, ScrH() * 0.1 + 10 )
    frame:SetAlpha( lerp )
    frame:SetSize( ScrW(), ScrH() )
    frame:Center()

    frame.Paint = function( self, w, h )
        lerp = Lerp( FrameTime() * 5, lerp, 1 )
        self:SetAlpha( lerp * 255 )

        blur:SetFloat( "$blur", 4 )
        blur:Recompute()
        render.UpdateScreenEffectTexture()

        surface.SetMaterial( blur )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( 0, 0, w, h )

        surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
        surface.DrawRect( 0, 0, w, h )

        local height = math.floor( ScrH() * 0.35 * lerp )

		surface.SetDrawColor( Color( 0, 0, 0, 225 ) )
		surface.SetMaterial( gradient_down )
		surface.DrawTexturedRect( 0, 0, w, height )
		surface.SetMaterial( gradient_up )
        surface.DrawTexturedRect( 0, h - height, w, height )
    end

    --[[
    local grid = vgui.Create( "DGrid", frame )
    grid:Dock( FILL )
    grid:SetCols( 8 )
    ]]

    --[[
    for i = 1, 80 do
        local slot = vgui.Create( "ItemStoreNewSlot" )
        slot:SetSize( 100, 100 )
        slot:SetItem( item )
        slot:Refresh()

        grid:AddItem( slot )
    end
    ]]

	local model = vgui.Create( "DModelPanel", frame )
	model:Dock( LEFT )
	model:DockMargin( 0, 0, 10, 0 )
	model:SetWidth( ScrW() * 0.25 )
	model:SetModel( "models/player/alyx.mdl" )

    local con = vgui.Create( "ItemStoreNewContainer", frame )
	con:Dock( FILL )
	con:Center()
	con:SetContainerID( LocalPlayer().InventoryID )

    local button = vgui.Create( "DButton", frame )
    button:SetPos( 10, 10 )
    button.DoClick  = function()
        frame:Remove()
    end
    button:SetText( "Close" )

    frame:MakePopup()
end )
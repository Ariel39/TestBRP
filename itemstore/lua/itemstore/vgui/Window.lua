local PANEL = {}

PANEL.TitleBarHeight = 24

function PANEL:Init()
	self:SetSkin( "itemstore" )

    self.TitleBar = vgui.Create( "Panel", self )
    self.TitleBar:Dock( TOP )
    self.TitleBar:SetHeight( 24 )
    self.TitleBar.Paint = function() return self:PaintTitleBar() end

    self.Title = vgui.Create( "DLabel", self.TitleBar )
    self.Title:Dock( LEFT )

    self.CloseButton = vgui.Create( "DButton", self.TitleBar )
    self.CloseButton:SetSize( 16, 16 )
    self.CloseButton:SetFont( "Marlett" )
    self.CloseButton:SetText( "r" )

    self.Body = vgui.Create( "Panel", self )
    self.Body:Dock( FILL )
    self.Body:SetPadding( 5, 5, 5, 5 )
    self.Body.Paint = function() return self:PaintContent() end

    self:SetTitle( "ItemStore" )
end

function PANEL:GetTitle()
    return self.Title:GetText()
end

function PANEL:SetTitle( text )
    self.Title:SetText( text )
end

function PANEL:PaintTitleBar( w, h )
end

function PANEL:PaintContent( w, h )
end

vgui.Register( "ItemStoreWindow", PANEL )

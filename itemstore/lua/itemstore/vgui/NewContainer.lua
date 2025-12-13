local PANEL = {}

function PANEL:Init()
    self.Page = 1

	self.Pages = {}
	self.Slots = {}
    self.PageButtons = {}

    self.Toolbar = vgui.Create( "Panel", self )
    self.Toolbar:SetHeight( 32 )
    self.Toolbar:Dock( TOP )
    self.Toolbar:DockMargin( 0, 0, 0, 5 )

    self.SearchClear = vgui.Create( "DButton", self.Toolbar )
    self.SearchClear:Dock( RIGHT )
    self.SearchClear:SetText( "X" )
    self.SearchClear:SetWidth( 32 )

    self.SearchClear.DoClick = function()
        self.Search:SetValue( "" )
        self:DoSearch()
    end

    self.Search = vgui.Create( "DTextEntry", self.Toolbar )
    self.Search:SetWidth( 200 )
    self.Search:Dock( RIGHT )
    self.Search:SetPlaceholderText( "Search..." )

    self.Search.OnChange = function()
        self:DoSearch()
    end

	table.insert( itemstore.containers.Panels, self )
end

function PANEL:GetPage()
    return self.Page
end

function PANEL:SetPage( page )
    self.Page = page

    for k, v in ipairs( self.Pages ) do
        if IsValid( v ) then
            v:SetVisible( k == page )
        end
    end
end

function PANEL:SetContainerID( id )
	self.ContainerID = id
	self:Refresh()
end

function PANEL:GetContainerID()
	return self.ContainerID
end

function PANEL:FadeToPage( page )
    local direction = page > self.Page and 1 or -1

    local current_page = self.Pages[ self.Page ]
    local next_page = self.Pages[ page ]

    if not IsValid( current_page ) or not IsValid( next_page ) then return end
    if current_page == next_page then return end

    --[[
    local x, y = current_page:GetPos()

    current_page:MoveTo( current_page:GetWide() * -direction , y, 0.25, 0, -1, function()
        next_page:SetPos( x + next_page:GetWide() * direction, y )
        self:SetPage( page )
        next_page:MoveTo( x, y, 0.25, 0, -1 )
    end )
    ]]

    current_page:AlphaTo( 0, 0.15, 0, function()
        next_page:SetAlpha( 0 )
        self:SetPage( page )
        next_page:AlphaTo( 255, 0.15, 0 )
    end )
end

function PANEL:Refresh()
	local id = self:GetContainerID()
	local con = itemstore.containers.Get( id )

    if con then
        for i = 1, con:GetPages() do
            if not self.PageButtons[ i ] then
                local button = vgui.Create( "DButton", self.Toolbar )
                button:SetWidth( 32 )
                button:Dock( LEFT )
                button:DockMargin( 0, 0, 5, 0 )
                button:SetText( i )

                button.DoClick = function()
                    self:FadeToPage( i )
                end

                button.DragHoverClick = function()
                    button:DoClick()
                end

                self.PageButtons[ i ] = button
            end
        end

        for i = 1, con:GetSize() do
            local page_id = con:GetPageFromSlot( i )
			local page = self.Pages[ page_id ]

            if not page then
                page = vgui.Create( "Panel", self )
                page:Dock( FILL )
                page:SetVisible( page_id == self:GetPage() )
                --page:SetAlpha( page_id == self:GetPage() and 255 or 0 )

                self.Pages[ page_id ] = page
			end

			local slot = self.Slots[ i ]

            if not slot then
				slot = vgui.Create( "ItemStoreNewSlot", page )
				slot:SetContainerID( self:GetContainerID() )
				slot:SetSlot( i )

                self.Slots[ i ] = slot
            end
            
            slot:SetItem( con:GetItem( i ) )            
			slot:Refresh()
        end
        
        self:DoSearch() 
        self:InvalidateLayout()
	end
end

function PANEL:PerformLayout()
	local id = self:GetContainerID()
    local con = itemstore.containers.Get( id )
    if not con then return end

    local p = 2

    local page = self.Pages[ self:GetPage() ]
    if not IsValid( page ) then return end

    local w, h = page:GetSize()
    local cw, ch = con:GetWidth(), con:GetHeight()

    w = w - ( cw * p ) + p
    h = h - ( ch * p ) + p

    local sw, sh = w / cw, h / ch
    local ox, oy = 0, 0

    if itemstore.config.SquareSlots then
        if sw > sh then
            ox = ( sw - sh ) * cw / 2
            sw = sh
        else
            oy = ( sh - sw ) * ch / 2
            sh = sw
        end
    end

    local slots = page:GetChildren()

    for k, v in ipairs( slots ) do
        local x = ( k - 1 ) % cw 
        local y = math.floor( ( k - 1 ) / cw )

        local calc_x = ox + ( x * sw ) + ( p * x )
        local calc_y = oy + ( y * sh ) + ( p * y )

        v:SetPos( calc_x, calc_y )
        v:SetSize( sw, sh )
    end

    local w, sw = self:GetWide(), self.Search:GetWide()

    if sw * 1.5 > w then
        self.SearchClear:Hide()
        self.Search:Hide()
        self.Search:SetText( "" )
        self:DoSearch()
    else
        self.SearchClear:Show()
        self.Search:Show()
    end
end

function PANEL:DoSearch()
    local search = string.lower( self.Search:GetValue() )

    if search ~= "" then
        for k, v in ipairs( self.Slots ) do
            local item = v:GetItem() 
            
            if item then
                local class = string.lower( item:GetClass() )
                local name = string.lower( item:GetName() )
                local desc = string.lower( item:GetDescription() )

                if string.find( class, search ) or string.find( name, search ) or string.find( desc, search ) then
                    v:SetAlpha( 255 )
                else
                    v:SetAlpha( 50 )
                end
            else
                v:SetAlpha( 50 )
            end
        end
    else
        for k, v in ipairs( self.Slots ) do
            v:SetAlpha( 255 )
        end
    end
end

vgui.Register( "ItemStoreNewContainer", PANEL )


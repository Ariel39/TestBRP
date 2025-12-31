/*
*   @package        : rcore
*   @module         : linx
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (c) 2015 - 2021
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
*
*   LICENSOR HEREBY GRANTS LICENSEE PERMISSION TO MODIFY AND/OR CREATE DERIVATIVE WORKS BASED AROUND THE
*   SOFTWARE HEREIN, ALSO, AGREES AND UNDERSTANDS THAT THE LICENSEE DOES NOT HAVE PERMISSION TO SHARE,
*   DISTRIBUTE, PUBLISH, AND/OR SELL THE ORIGINAL SOFTWARE OR ANY DERIVATIVE WORKS. LICENSEE MUST ONLY
*   INSTALL AND USE THE SOFTWARE HEREIN AND/OR ANY DERIVATIVE WORKS ON PLATFORMS THAT ARE OWNED/OPERATED
*   BY ONLY THE LICENSEE.
*
*   YOU MAY REVIEW THE COMPLETE LICENSE FILE PROVIDED AND MARKED AS LICENSE.TXT
*
*   BY MODIFYING THIS FILE -- YOU UNDERSTAND THAT THE ABOVE MENTIONED AUTHORS CANNOT BE HELD RESPONSIBLE
*   FOR ANY ISSUES THAT ARISE FROM MAKING ANY ADJUSTMENTS TO THIS SCRIPT. YOU UNDERSTAND THAT THE ABOVE
*   MENTIONED AUTHOR CAN ALSO NOT BE HELD RESPONSIBLE FOR ANY DAMAGES THAT MAY OCCUR TO YOUR SERVER AS A
*   RESULT OF THIS SCRIPT AND ANY OTHER SCRIPT NOT BEING COMPATIBLE WITH ONE ANOTHER.
*/

/*
*   standard tables and localization
*/

local base                  = rlib
local helper                = base.h
local access                = base.a
local design                = base.d
local ui                    = base.i
local mats                  = base.m
local cvar                  = base.v

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'linx' )
local cfg               	= base.modules:cfg( mod )

/*
*   Localized res func
*/

local function resources( t, ... )
    return base:resource( mod, t, ... )
end

/*
*   Localized translation func
*/

local function ln( ... )
    return base:translate( mod, ... )
end

/*
*	localized mat func
*/

local function mat( id )
    return mats:call( mod, id )
end

/*
*	prefix ids
*/

local function pref( str, suffix )
    local state = not suffix and mod or isstring( suffix ) and suffix or false
    return base.get:pref( str, state )
end

/*
*   panel
*/

local PANEL = { }

/*
*   accessorfunc
*/

AccessorFunc( PANEL, 'm_bDraggable', 'Draggable',   FORCE_BOOL )
AccessorFunc( PANEL, 'itemName',     'MenuItem',    FORCE_STRING )

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   parent pnl
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :padding                        ( 2, 34, 2, 3                           )
    :shadow                         ( true                                  )
    :sz                             ( self.w, self.h                        )
    :wmin                           ( self.w * 0.85                         )
    :hmin                           ( self.h * 0.85                         )
    :popup                          (                                       )
    :notitle                        (                                       )
    :canresize                      ( false                                 )
    :showclose                      ( false                                 )
    :scrlock                        ( true                                  )

    /*
    *   display parent
    */

    ui.anim_fadein                  ( self, 0.2, 0                          )

    /*
    *   ui placement
    */

    if cvar:GetBool( 'rlib_animations_enabled' ) then
        self:SetPos( ( ScrW( ) / 2 ) - ( self.w / 2 ), ScrH( ) + self.pos_h )
        self:MoveTo( ( ScrW( ) / 2 ) - ( self.w / 2 ), ( ScrH( ) / 2 ) - ( self.pos_h / 2 ), 0.4, 0, -1 )
    else
        self:SetPos( ( ScrW( ) / 2 ) - ( self.w / 2 ), ( ScrH( ) / 2 ) - ( self.pos_h / 2 ) )
    end

    /*
    *   titlebar
    *
    *   to overwrite existing properties from the skin; do not change this
    *   labels name to anything other than lblTitle otherwise it wont
    *   inherit position/size properties
    */

    self.lblTitle                   = ui.new( 'lbl', self                   )
    :notext                         (                                       )
    :font                           ( pref( 'ibws_name' )                   )
    :clr                            ( self.cf_d.clrs.header_txt             )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( helper.get:utf8( 'title_a' ), pref( 'ibws_icon' ), 4, 6, self.cf_d.clrs.header_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self:GetLabel( ), pref( 'ibws_name' ), 25, h / 2, self.cf_d.clrs.header_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   close button
    *
    *   to overwrite existing properties from the skin; do not change this
    *   buttons name to anything other than btnClose otherwise it wont
    *   inherit position/size properties
    */

    self.btnClose                   = ui.new( 'btn', self                   )
    :bsetup                         (                                       )
    :notext                         (                                       )
    :tooltip                        ( ln( 'tooltip_close_window' )          )
    :ocr                            ( self                                  )

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and self.cf_d.clrs.btn_exit_h or self.cf_d.clrs.btn_exit_n
                                        draw.SimpleText( helper.get:utf8( 'close' ), pref( 'ibws_exit' ), w / 2 - 8, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

                                    :oc( function( s )
                                        self:Destroy( )
                                        mod.ui:HideRegistered( )

                                        mod.ui:ToggleRegistered( '$pnl_slider', true )
                                        mod.ui:ToggleRegistered( '$pnl_footer', true )
                                        mod.ui:ToggleRegistered( '$pnl_navmenu', true, false, true, true )
                                    end )

    /*
    *   pnl > sub
    */

    self.ct_sub                     = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0, 10, 0                         )

    /*
    *   pnl > body
    */

    self.ct_body                    = ui.new( 'pnl', self.ct_sub, 1         )
    :fill                           ( 'm', 10, 5, 10, 5                     )

    /*
    *   pnl > body > sub
    */

    self.body_sub                   = ui.new( 'pnl', self.ct_body, 1        )
    :fill                           ( 'm', 8, 5, 8, 5                       )

    /*
    *   dhtml
    */

    self.dhtml                      = ui.new( 'dhtml', self.body_sub, 1     )
    :fill                           ( 'm', 5, 10, 5, 10                     )
    :url                            ( ''                                    )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, self.cf_n.general.clrs.bg_main )
                                    end )

    /*
    *   header
    */

    self.header                     = ui.new( 'pnl', self.body_sub, 1       )
    :top                            (                                       )
    :tall                           ( 32                                    )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, Color( 255, 255, 255, 1 ))
                                    end )

    /*
    *   header
    */

    self.header_l                   = ui.new( 'pnl', self.header, 1         )
    :left                           (                                       )
    :margin                         ( 5, 6, 3, 6                            )
    :wide                           ( 22                                    )

    /*
    *   tip
    */

    self.b_tip                      = ui.new( 'btn', self.header_l          )
    :bsetup                         (                                       )
    :fill                           (                                       )
    :tip                            ( ln( 'ibws_tip_warning' )              )

                                    :oc( function( s )
                                        if ui:registered( '$diag_ibws_notice', mod ) then
                                            ui:dispatch( '$diag_ibws_notice', mod )
                                            return
                                        end

                                        local get_id            = self:GetLinkData( )
                                        local diag_ibws         = ui.rlib( mod, 'diag_ibws_notice'      )
                                        :param                  ( 'SetMenuItem',  get_id                )
                                        :register               ( '$diag_ibws_notice', mod              )
                                    end )

                                    :draw( function( s, w, h )
                                        design.rbox( 5, 0, 0, w, h, Color( 202, 202, 202, 255 ) )

                                        local a	        = math.abs( math.sin( CurTime( ) * 5 ) * 255 )
                                        a		        = math.Clamp( a, s.hover and 100 or 255, 255 )
                                        local clr_ico   = Color( 0, 0, 0, 255 )

                                        draw.SimpleText( '', pref( 'ibws_diag_ico_hint' ), w / 2, h / 2, Color( clr_ico.r, clr_ico.g, clr_ico.b, a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   dhtml > controls
    */

    self.ctrlbar                    = ui.new( 'ctrls', self.header          )
    :fill                           ( 'm', 0                                )
    :pos                            ( 0                                     )
    :html                           ( self.dhtml or ''                      )

    /*
    *   dhtml > attach window
    */

    local window                    = ui.get( self.dhtml                    )
    :below                          ( self.ctrlbar                          )

end

/*
*   Think
*/

function PANEL:Think( )
    self.BaseClass.Think( self )

    self.allow_resize = self:GetSizable( ) or false

    -- if input.IsKeyDown( KEY_ESCAPE ) or gui.IsGameUIVisible( ) then self:Destroy( ) end

    self:MoveToFront( )

    local mousex = math.Clamp( gui.MouseX( ), 1, ScrW( ) - 1 )
    local mousey = math.Clamp( gui.MouseY( ), 1, ScrH( ) - 1 )

    if self.Dragging then
        local x = mousex - self.Dragging[ 1 ]
        local y = mousey - self.Dragging[ 2 ]

        local clamping =
        {
            x = 0,
            y = ScrH( ) - self:GetTall( ),
        }

        if cfg.ticker.enabled then
            clamping.y = clamping.y - 30
        end

        if cfg.servers.enabled then
            clamping.y = clamping.y - 60
        end

        if self:GetScreenLock( ) then
            x = math.Clamp( x, 0, ScrW( ) - self:GetWide( ) )
            y = math.Clamp( y, 60, clamping.y )
        end

        self:SetPos( x, y )
    end

    if self.Sizing then
        local x = mousex - self.Sizing[ 1 ]
        local y = mousey - self.Sizing[ 2 ]
        local px, py = self:GetPos( )

        if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW( ) - px and self:GetScreenLock( ) ) then x = ScrW( ) - px end
        if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH( ) - py and self:GetScreenLock( ) ) then y = ScrH( ) - py end

        self:SetSize( x, y )
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self.m_bSizable and mousex > ( self.x + self:GetWide( ) - 20 ) and mousey > ( self.y + self:GetTall( ) - 20 ) ) then
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self:GetDraggable( ) and mousey < ( self.y + 24 ) ) then
        self:SetCursor( 'sizeall' )
        return
    end

    self:SetCursor( 'arrow' )

    if self.y < 0 then self:SetPos( self.x, 0 ) end

end

/*
*   OnMousePressed
*/

function PANEL:OnMousePressed( )
    if ( self.m_bSizable and gui.MouseX( ) > ( self.x + self:GetWide( ) - 20 ) and gui.MouseY( ) > ( self.y + self:GetTall( ) - 20 ) ) then
        self.Sizing =
        {
            gui.MouseX( ) - self:GetWide( ),
            gui.MouseY( ) - self:GetTall( )
        }
        self:MouseCapture( true )
        return
    end

    if ( self:GetDraggable( ) and gui.MouseY( ) < ( self.y + 24 ) ) then
        self.Dragging =
        {
            gui.MouseX( ) - self.x,
            gui.MouseY( ) - self.y
        }
        self:MouseCapture( true )
        return
    end
end

/*
*   OnMouseReleased
*/

function PANEL:OnMouseReleased( )
    self.Dragging   = nil
    self.Sizing     = nil
    self:MouseCapture( false )
end

/*
*   PerformLayout
*/

function PANEL:PerformLayout( )
    local titlePush = 0
    self.BaseClass.PerformLayout( self )

    self.lblTitle:SetPos( 11 + titlePush, 7 )
    self.lblTitle:SetSize( self:GetWide( ) - 25 - titlePush, 20 )
end

/*
*   Paint
*/

function PANEL:Paint( w, h )
    design.rbox( 4, 0, 0, w, h, self.cf_d.clrs.shadow_box )
    design.rbox( 4, 2, 2, w - 4, h - 4, self.cf_d.clrs.body_box )
    design.rbox_adv( 4, 4, 4, w - 8, 34 - 8, self.cf_d.clrs.header_box, true, true, false, false )

    /*
    *   resizing arrows that display bottom-right
    *       >  requires self:SetSizable( true )
    */

    if not self.allow_resize then return end
    draw.SimpleText( helper.get:utf8( 'resize' ), pref( 'rules_size' ), w - 3, h - 7, self.cf_d.clrs.ico_resize, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    draw.SimpleText( helper.get:utf8( 'resize' ), pref( 'rules_size' ), w - 5, h - 9, self.cf_d.clrs.body_box, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
end

/*
*   ActionShow
*/

function PANEL:ActionShow( )
    self:SetMouseInputEnabled( true )
    self:SetKeyboardInputEnabled( true )
end

/*
*   GetLinkData
*/

function PANEL:GetLinkData( )
    local id        = self:GetMenuItem( )
                    if not id then return end

    for v in helper.get.data( cfg.nav.list ) do
        local name_static   = v.name:lower( )
        local name_dyn      = ln( name_static )

        if ( name_static ~= id ) and ( name_dyn ~= id ) then continue end

        return v.id
    end
end

/*
*   GetLabel
*
*   @return : str
*/

function PANEL:GetLabel( )
    return helper.str:ok( self.label ) and self.label or ln( 'browser_untitled' )
end

/*
*   SetLabel
*
*   @param  : str str
*/

function PANEL:SetLabel( str )
    self.lblTitle:SetText( '' )
    self.label = str
end

/*
*   GetWebURL
*/

function PANEL:GetWebURL( )
    return self.web_url
end

/*
*   SetWebURL
*
*   @param str str
*/

function PANEL:SetWebURL( str )
    self.web_url = str
    self.dhtml:OpenURL( str )
    self.ctrlbar.AddressBar:SetText( str )
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   _Declare
*/

function PANEL:_Declare( )

    /*
    *   declare > configs
    */

    self.cf_g                       = cfg.general
    self.cf_d                       = cfg.dialogs
    self.cf_n                       = cfg.nav

    /*
    *   declare > sizing
    */

    self.w, self.h                  = ScrW( ) * 0.75, ScrH( ) * 0.75

    /*
    *   declare > misc
    */

    self.allow_resize               = false

    /*
    *   declare > offset
    */

    self.pos_h = self.h
    if cfg.ticker.enabled then
        self.pos_h = self.h + ( 30 / 2 )
    end

    if cfg.servers.enabled then
        self.pos_h = self.h + ( 60 / 2 )
    end

end

/*
*   _Call
*/

function PANEL:_Call( )

    /*
    *   initialize sound
    */

    if cfg.general.sounds_enabled then
        local snd                   = CreateSound( LocalPlayer( ), resources( 'snd', 'swipe_01' ) )
        snd:PlayEx                  ( 0.1, 100 )
    end

end

/*
*   create
*/

ui:create( mod, 'pnl_ibws', PANEL )
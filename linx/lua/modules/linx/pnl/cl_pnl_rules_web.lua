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
*   Localized translation func
*/

local function ln( ... )
    return base:translate( mod, ... )
end

/*
*   Localized res func
*/

local function resources( t, ... )
    return base:resource( mod, t, ... )
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

AccessorFunc( PANEL, 'm_bDraggable', 'Draggable', FORCE_BOOL )

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
        self:SetPos( self.pos_w, ( ScrH( ) / 2 ) - (  self.pos_h / 2 ) )
        self:MoveTo( self.pos_w, ( ScrH( ) / 2 ) - (  self.pos_h / 2 ), 0.4, 0, -1 )
    else
        self:SetPos( self.pos_w, ( ScrH( ) / 2 ) - (  self.pos_h / 2 ) )
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
    :font                           ( pref( 'rules_name' )                  )
    :clr                            ( self.cf_d.clrs.header_txt             )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( helper.get:utf8( 'title_a' ), pref( 'rules_icon' ), 4, 6, self.cf_d.clrs.header_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self:GetLabel( ), pref( 'rules_name' ), 25, h / 2, self.cf_d.clrs.header_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and self.cf_d.clrs.btn_exit_h or self.cf_d.clrs.btn_exit_n
                                        draw.SimpleText( helper.get:utf8( 'close' ), pref( 'rules_exit' ), w / 2 - 8, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

    self.p_sub                      = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0, 10, 0                         )

    /*
    *   pnl > body
    */

    self.p_body                     = ui.new( 'pnl', self.p_sub, 1          )
    :fill                           ( 'm', 10, 5, 10, 5                     )

    /*
    *   pnl > dt > body
    */

    self.p_dt_body                  = ui.new( 'pnl', self.p_body            )
    :fill                           ( 'm', 0, 5, 0, 10                      )
    :rbox                           ( cfg.rules.clrs.primary, 6             )

    /*
    *   pnl > dt > body > sub
    */

    self.p_dt_sub                   = ui.new( 'pnl', self.p_dt_body, 1      )
    :fill                           ( 'm', 8, 8, 8, 20                      )

    /*
    *   dhtml
    */

    self.dhtml                      = ui.new( 'dhtml', self.p_dt_sub, 1     )
    :fill                           ( 'm', 10, 15, 5, 10                    )
    :url                            ( cfg.nav.btn.rules_url                 )

    /*
    *   dhtml controls
    */

    self.ctrlbar                    = ui.new( 'ctrls', self.p_dt_sub        )
    :top                            ( 'm', 0                                )
    :pos                            ( 0                                     )
    :html                           ( self.dhtml or ''                      )

    /*
    *   attach window
    */

    local window                    = ui.get( self.dhtml                    )
    :below                          ( self.ctrlbar                          )

    /*
    *   pnl > bottom (footer)
    */

    self.p_btm                      = ui.new( 'pnl', self.p_sub, 1          )
    :bottom                         ( 'm', 10, 0, 10, 5                     )
    :tall                           ( 2                                     )

    /*
    *   pnl > btn > sub
    */

    self.p_btn_sub                  = ui.new( 'pnl', self.p_body, 1         )
    :bottom                         ( 'm', 40, 3, 3, 3                      )
    :tall                           ( 36                                    )

    /*
    *   pnl > btn > sub > spacer
    */

    self.p_btn_sub_sp               = ui.new( 'pnl', self.p_btn_sub, 1      )
    :right                          ( 'm', 0, 3                             )
    :wide                           ( 100                                   )

    /*
    *   btn > rules > ok
    */

    self.b_rules_ok                 = ui.new( 'btn', self.p_btn_sub_sp      )
    :bsetup                         (                                       )
    :right                          ( 'm', 0                                )
    :notext                         (                                       )
    :sz                             ( 32, 28                                )
    :tip                            ( ln( 'tooltip_rules_btn' )             )

                                    :draw( function( s, w, h )
                                        local clr_a         = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                        clr_a	            = math.Clamp( clr_a, 100, 255 )

                                        local clr_box       = ColorAlpha( self.cf_d.clrs.opt_ok_btn_n, clr_a )

                                        design.rbox( 6, 0, 0, w, h, clr_box )

                                        if s.hover then
                                            design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.opt_ok_btn_h )
                                        end

                                        draw.SimpleText( helper.get:utf8( 'check' ), pref( 'rules_btn_confirm' ), w / 2, h / 2, self.cf_d.clrs.opt_ok_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

                                    :oc( function( s )
                                        self:Destroy( )
                                        mod.ui:HideRegistered( )

                                        mod.ui:ToggleRegistered( '$pnl_slider', true )
                                        mod.ui:ToggleRegistered( '$pnl_footer', true )
                                        mod.ui:ToggleRegistered( '$pnl_navmenu', true, false, true, true )
                                    end )

end

/*
*   GetLabel
*
*   @return : str
*/

function PANEL:GetLabel( )
    return helper.str:ok( self.label ) and self.label or ln( 'rules_name' )
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
*   Think
*/

function PANEL:Think( )
    self.BaseClass.Think( self )

    self.allow_resize = self:GetSizable( ) or false

    self:MoveToFront( )

    -- if input.IsKeyDown( KEY_ESCAPE ) or gui.IsGameUIVisible( ) then self:Destroy( ) end

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
    *       : requires self:SetSizable( true )
    */

    if not self.allow_resize then return end
    draw.SimpleText( helper.get:utf8( 'resize' ), pref( 'rules_size' ), w - 3, h - 7, self.cf_d.clrs.ico_resize, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    draw.SimpleText( helper.get:utf8( 'resize' ), pref( 'rules_size' ), w - 5, h - 9, self.cf_d.clrs.body_box, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
end

/*
*   ActionShow
*/

function PANEL:ActionShow( )
    self:SetMouseInputEnabled       ( true )
    self:SetKeyboardInputEnabled    ( true )
end

/*
*   GetRules
*
*   @return str
*/

function PANEL:GetRules( )
    return self.rules
end

/*
*   SetRules
*
*   @param str str
*/

function PANEL:SetRules( str )
    self.rules = str
end

/*
*   SetRules
*
*   @param str url
*/

function PANEL:SetURL( url )
    self.url = url
    self.dhtml:OpenURL( url )
    self.ctrlbar.AddressBar:SetText( url )
end

/*
*   GetRules
*
*   @return str
*/

function PANEL:GetURL( )
    return self.url
end

/*
*   GetStandalone
*
*   @return bool
*/

function PANEL:GetStandalone( )
    return helper:val2bool( self.bStandalone )
end

/*
*   SetStandalone
*
*   @param bool b
*/

function PANEL:SetStandalone( b )
    self.bStandalone = helper:val2bool( b )
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

    self.pos_w      = not self:GetStandalone( ) and ( ScrW( ) / 2 - self.w / 2 ) or 50
    self.pos_h      = self.h
    if cfg.ticker.enabled then
        self.pos_h  = self.h + ( 30 / 2 )
    end

    if cfg.servers.enabled then
        self.pos_h  = self.h + ( 60 / 2 )
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

ui:create( mod, 'pnl_rules_web', PANEL )
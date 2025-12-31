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
*   _Declare
*/

function PANEL:_Declare( )

    /*
    *   declare > demo mode
    */

    self.bDemoMode                 = rcore:bInDemoMode( mod ) or false

    /*
    *   declare > materials
    */

    self.m_console                  = mat( 'btn_console_2' )
    self.m_origmenu                 = mat( 'btn_gmod_menu_1' )
    self.m_close                    = mat( 'btn_close_1' )

    /*
    *   declare > btn > size
    */

    self.sz_ico                     = cfg.nav.general.header_sz_ico
    self.sz_header                  = ui:SmartScaleH( false, cfg.general.header_tall )
    self.marg_t                     = ui:SmartScaleH( false, cfg.general.margin_top )

    /*
    *   declare > network name size
    */

    self.sn_sizex                   = helper.str:len( cfg.general.network_name:upper( ), pref( 'g_section_name' ), 20 )

    /*
    *   declare > total player count
    */

    self.i_pl                       = ( not self.bDemoMode and player.GetCount( ) ) or cfg.dev.demo.online
    self.cp_sizex                   = 45

end

/*
*   Init
*/

function PANEL:Init( )

    /*
    *   parent
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :fill                           ( 'm', 0                                )
    :tall                           ( self.sz_header                        )

    /*
    *   content
    */

    local content                   = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0                                )

    /*
    *   btn > close
    */

    local b_close                   = ui.new( 'btn', content                )
    :bsetup                         (                                       )
    :pos                            ( ScrW( ) - 32 - cfg.general.margin_left, ui:SmartScaleH( false, cfg.general.margin_top ) )
    :tooltip                        ( ln( 'tooltip_close_window' )          )
    :sz                             ( 32, 40                                )

                                    :draw( function( s, w, h )
                                        local clr_btn           = cfg.general.clrs.btn_exit
                                        if s.hover then
                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 150, 255 )
                                            clr_btn             = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                        end

                                        design.mat( ( w / 2 ) - ( 32 / 2 ), ( h / 2 ) - ( 32 / 2 ), 32, 32, self.m_close, clr_btn )
                                    end )

                                    :oc( function( s )
                                        mod.ui:Hide( )
                                    end )

    /*
    *   server name
    */

    local p_srv_name                = ui.new( 'pnl', content                )
    :pos                            ( cfg.general.margin_left + ( cfg.nav.general.btn_lines_enabled and 0 or 10 ), self.marg_t )
    :size                           ( self.sn_sizex, cfg.header.height      )

                                    :draw( function( s, w, h )
                                        design.rbox( 0, 0, 0, self.sn_sizex, h, cfg.header.clrs.servname_box or Color( 255, 255, 255, 100 ) )
                                        draw.DrawText( cfg.general.network_name:upper( ), pref( 'g_section_name' ), s:GetWide( ) - 10, 4, cfg.header.clrs.servname_text or Color( 100, 100, 100, 255 ), TEXT_ALIGN_RIGHT )
                                    end )

    /*
    *   ply count
    */

    local p_cnt_online              = ui.new( 'pnl', content                )
    :pos                            ( cfg.general.margin_left + self.sn_sizex + 2 + ( cfg.nav.general.btn_lines_enabled and 0 or 10 ), self.marg_t )
    :size                           ( self.cp_sizex + 3, cfg.header.height  )

                                    :draw( function( s, w, h )
                                        design.rbox( 0, 0, 0, w, h, cfg.header.clrs.online_box or Color( 58, 111, 225, 255 ) )
                                        draw.DrawText( ln( 'online_title' ), pref( 'pl_online_text' ), w / 2, 4, cfg.header.clrs.online_text or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
                                        draw.DrawText( self.i_pl, pref( 'pl_online_data' ), w / 2, 18, cfg.header.clrs.online_text or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   btn > origmenu
    */

    self.b_origmenu                 = ui.new( 'btn', content                )
    :bsetup                         (                                       )
    :pos                            ( cfg.general.margin_left + self.sn_sizex + 2 + ( cfg.nav.general.btn_lines_enabled and 0 or 10 ) + self.cp_sizex + 10, self.marg_t + 7 )
    :margin                         ( 0, 0, 0, 0                            )
    :tooltip                        ( ln( 'tooltip_origmenu_window' )       )
    :size                           ( self.sz_ico                           )

                                    :draw( function( s, w, h )
                                        local clr_btn           = cfg.general.clrs.btn_origmenu
                                        if s.hover then
                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 150, 244 )
                                            clr_btn             = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                        end

                                        local i_rotate          = ( cfg.general.anim_rotate_enabled and ( s.hover and ( CurTime( ) % 360 * cfg.general.anim_rotate_speed ) ) ) or 0
                                        design.mat_r( ( w / 2 ), ( h / 2 ), self.sz_ico, self.sz_ico, i_rotate, self.m_origmenu, clr_btn )
                                    end )

                                    :oc( function( s )
                                        mod.ui:Hide( )
                                        gui.ActivateGameUI( )
                                    end )

                                    :logic( function( s )

                                        /*
                                        *	sfx > open
                                        */

                                        if s.hover then
                                            if not s.bSndHover and cfg.general.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_01' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        else
                                            s.bSndHover     = false
                                        end

                                    end )

    /*
    *   btn > console
    */

    self.b_console                  = ui.new( 'btn', content                )
    :bsetup                         (                                       )
    :pos                            ( cfg.general.margin_left + self.sn_sizex + 2 + ( cfg.nav.general.btn_lines_enabled and 0 or 10 ) + self.cp_sizex + 10 + self.sz_ico + 5, self.marg_t + 7 )
    :margin                         ( 0, 0, 0, 0                            )
    :tooltip                        ( ln( 'tooltip_console_window' )        )
    :size                           ( self.sz_ico                           )

                                    :draw( function( s, w, h )
                                        local clr_btn           = cfg.general.clrs.btn_console
                                        if s.hover then
                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 150, 244 )
                                            clr_btn             = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                        end

                                        local i_rotate          = ( cfg.general.anim_rotate_enabled and ( s.hover and ( CurTime( ) % 360 * cfg.general.anim_rotate_speed ) ) ) or 0
                                        design.mat_r( w / 2, h / 2, self.sz_ico, self.sz_ico, i_rotate, self.m_console, clr_btn )
                                    end )

                                    :logic( function( s )

                                        /*
                                        *	sfx > open
                                        */

                                        if s.hover then
                                            if not s.bSndHover and cfg.general.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_01' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        else
                                            s.bSndHover     = false
                                        end

                                    end )

                                    :oc( function( s )
                                        rcc.run.gmod( 'showconsole' )
                                        timex.simple( 0, function( ) rcc.run.gmod( 'gameui_activate' ) end )
                                    end )

end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h ) end

/*
*   Think
*/

function PANEL:Think( )
    if not cfg.header.enabled then
        self:Destroy( )
        return
    end

    if not cfg.header.qmenu_enabled and ui:visible( self.b_origmenu ) then
        ui:unstage( self.b_origmenu )
        ui:unstage( self.b_console )
    elseif cfg.header.qmenu_enabled and not ui:visible( self.b_origmenu ) then
        ui:stage( self.b_origmenu )
        ui:stage( self.b_console )
    end
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   assign
*/

ui:create( mod, 'pnl_header', PANEL, 'pnl' )
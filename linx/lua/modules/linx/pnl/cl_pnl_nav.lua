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
    self.cf_n                       = cfg.nav
    self.cf_g                       = cfg.general
end

/*
*   Init
*/

function PANEL:Init( )

    /*
    *   mark ply on main screen
    */

    mod.breadcrumb:Set( true )

    /*
    *   parent
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :nodraw                         (                                       )

    /*
    *   localized
    */

    local clrs                      = self.cf_n.general.clrs

    /*
    *   navmenu
    */

    local i = 0
    for v in helper.get.data( cfg.nav.list ) do
        if not v.enabled then continue end

        if v.bSpacer then
            local scale_tall        = ui:SmartScaleH( true, 4, 15, 55, 55, 150, 200, 240, 240 )

            local spacer            = ui.new( 'pnl', self, 1                )
            :top                    ( 'm', 0                                )
            :tall                   ( scale_tall                            )

            continue
        end

        /*
        *   define > general
        */

        local b_mat                         = false
        local bTextOnly                     = cfg.nav.general.btn_use_textonly or false

        /*
        *   define > colors
        */

        local clr_text, clr_text_h          = v.clrs and v.clrs.text or clrs.text, v.clrs and v.clrs.text_hover or clrs.text_hover
        local clr_txt_s, clr_txt_s_h        = v.clrs and v.clrs.textsub or clrs.textsub, v.clrs and v.clrs.textsub_hover or clrs.textsub_hover
        local clr_icon, clr_icon_h          = v.clrs and v.clrs.icon or clrs.icon, v.clrs and v.clrs.icon_hover or clrs.icon_hover
        local clr_lines, clr_lines_h        = v.clrs and v.clrs.box_lines or clrs.box_lines, v.clrs and v.clrs.box_lines_hover or clrs.box_lines_hover
        local clr_lines_pulse               = clrs.box_lines_pulse
        local clr_box_ico, clr_box_h        = clrs.box_icon, clrs.box_hover
        clr_lines                           = not bTextOnly and clr_box_ico or clr_lines

        /*
        *   define > sizes
        */

        local sz_min                = cfg.nav.general.btn_sz_w
        local sz_h                  = cfg.nav.general.btn_sz_h
        local sz_ico                = 26

        /*
        *   define > button > name / desc
        */

        local btn_name              = v.name and ln( v.name ) or ( not btn_name or btn_name == '' and ln( 'sys_btn_noname' ) )
        btn_name                    = helper.str:truncate( btn_name, isnumber( v.truncate_len_name ) and v.truncate_len_name or cfg.nav.general.truncate_len_name ) or ln( 'sys_btn_noname' )

        local btn_desc              = v.desc and ln( v.desc ) or ( not btn_desc or btn_desc == '' and ln( 'sys_btn_noname' ) )
        btn_desc                    = helper.str:truncate( btn_desc, isnumber( v.truncate_len_desc ) and v.truncate_len_desc or cfg.nav.general.truncate_len_desc ) or ln( 'sys_btn_noname' )

        /*
        *   nav button
        */

        local b_item                = ui.new( 'btn', self                   )
        :top                        ( 'm', 0, 0, 0, 1                       )
        :size                       ( sz_min - 32, sz_h                     )
        :notext                     (                                       )
        :onhover                    (                                       )
        :anim_click_ol              ( Color( 175, 45, 45, 100 )             )
        :SetupAnim                  ( 'OnHoverFill', 10, function( s ) return s:IsHovered( ) end )

                                    :oc( function( s )
                                        if v.action then v.action( ) end
                                    end )

                                    :draw( function( s, w, h )
                                        if not s.OnHoverFill then
                                            s.OnHoverFill = 10
                                        end

                                        local x, y, fw, fh      = ( not bTextOnly and 50 ) or 10, 0, math.Round( w * s.OnHoverFill ), h
                                        design.box( x, y, fw, fh, clr_box_h )

                                        local clr_text_n        = ( s.hover and clr_text_h ) or clr_text
                                        local clr_txt_s_n       = ( s.hover and clr_txt_s_h ) or clr_txt_s
                                        local clr_icon_n        = ( s.hover and clr_icon_h ) or clr_icon
                                        local clr_box_lines     = ( s.hover and clr_lines_h ) or clr_lines
                                        local i_lines_w         = cfg.nav.general.btn_lines_width

                                        if not bTextOnly then
                                            design.box( 10, 0, 40, h, clr_box_ico )
                                        end

                                        local clr_anim          = clr_lines_pulse
                                        if s.hover then
                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 150, 200 )
                                            clr_anim            = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                        end

                                        if cfg.nav.general.btn_lines_enabled then
                                            surface.SetDrawColor    ( clr_box_lines                 )
                                            surface.DrawRect        ( 0, 0, i_lines_w, h            )
                                            surface.DrawRect        ( 0 + 4, 0, i_lines_w, h        )

                                            if s.hover then
                                                surface.SetDrawColor    ( clr_anim                  )
                                                surface.DrawRect        ( 0, 0, i_lines_w, h        )
                                                surface.DrawRect        ( 0 + 4, 0, i_lines_w, h    )
                                            end
                                        end

                                        local i_pos             = not bTextOnly and 55 or 15
                                        local i_rotate          = ( self.cf_g.anim_rotate_enabled and ( s.hover and ( CurTime( ) % 360 * self.cf_g.anim_rotate_speed ) ) ) or 0
                                        if not bTextOnly and v.icon then
                                            design.mat_r( 30, 13 + ( sz_h / 2 ) - ( sz_ico / 2 ), sz_ico, sz_ico, i_rotate, b_mat, clr_icon_n )
                                        end

                                        local name_pos, name_fnt = .33, pref( 'nav_item_name' )
                                        if cfg.nav.general.btn_hide_desc then
                                            name_pos, name_fnt = .50, pref( 'nav_item_name_lg' )
                                        end

                                        draw.SimpleText( btn_name:upper( ), name_fnt, i_pos, h * name_pos, clr_text_n, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

                                        if not cfg.nav.general.btn_hide_desc then
                                            draw.SimpleText( btn_desc:upper( ), pref( 'nav_item_desc' ), i_pos, h * .71, clr_txt_s_n, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        end
                                    end )

                                    :logic( function( s )

                                        /*
                                        *	sfx > open
                                        */

                                        if s.hover then
                                            if not s.bSndHover and self.cf_g.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_02' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        else
                                            s.bSndHover     = false
                                        end

                                    end )

        if ( v.icon and not bTextOnly ) then
            b_mat = mat( v.icon )
            b_item:SetSize( b_item:GetWide( ) + 32, b_item:GetTall( ) )
        end

        i = i + sz_h + 2
    end

end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h ) end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   assign
*/

ui:create( mod, 'pnl_nav', PANEL, 'pnl' )
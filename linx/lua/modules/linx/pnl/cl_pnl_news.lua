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
*	localized mat func
*/

local function mat( id )
    return mats:call( mod, id )
end

/*
*   Localized res func
*/

local function resources( t, ... )
    return base:resource( mod, t, ... )
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
*   Init
*/

function PANEL:Init( )

    self.sl_h                      = ui:SmartScaleH( false, cfg.slider.height )

    /*
    *   populate slider data
    */

    local populate_data = { }
    for v in helper.get.data( cfg.slider.list ) do
        if not v.enabled then continue end
        table.insert( populate_data, v )
    end

    /*
    *   parent
    */

    self:SetPos                     ( ScrW( ) - cfg.slider.width - 100, self.sl_h )
    self:SetSize                    ( cfg.slider.width, 500                 )

    /*
    *   inner btm shaded bar
    */

    self.object                     = ui.rlib( mod, 'pnl_news_item', self, 1 )
    :fill                           ( 'm', 0                                )

    /*
    *   container > slider selection
    */

    self.sub                        = ui.new( 'pnl', self, 1                )
    :bottom                         ( 'm', 0, 5, 0                          )
    :tall                           ( cfg.slider.btn_sz + 2                 )

    /*
    *   slider > localize data
    */

    local i_pos                     = ( ( cfg.slider.orientation == 2 ) and ( cfg.slider.width - cfg.slider.btn_sz ) ) or 0
    local tabs                      = { }

    /*
    *   slider > loop slides
    */

    local slides_total              = #populate_data
    local i                         = ( cfg.slider.orientation == 2 and slides_total ) or 1

    for k, v in SortedPairs( populate_data ) do
        if not v.enabled then continue end

        local i_pad                 = ( cfg.slider.orientation == 2 and cfg.slider.rounded_bg and ( cfg.slider.rounded_bg_amt + 10 ) ) or 0
        self.b_slidesel             = ui.new( 'btn', self.sub               )
        :bsetup                     (                                       )
        :size                       ( cfg.slider.btn_sz                     )
        :pos                        ( i_pos - i_pad, 0                      )
        :notext                     (                                       )
        :onhover                    (                                       )
        :tip                        ( ln( 'slide_incr', i )                 )

                                    :draw( function( s, w, h )
                                        local clr_outer         = s.hover and cfg.slider.clrs.btn_outer_hover or cfg.slider.clrs.btn_outer
                                        local clr_inner         = s.hover and cfg.slider.clrs.btn_inner_hover or cfg.slider.clrs.btn_inner

                                        if s.active then
                                            clr_inner           = cfg.slider.clrs.btn_active

                                            local calc_pulse    = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                            calc_pulse          = math.Clamp( calc_pulse, 100, 255 )
                                            clr_inner           = Color( clr_inner.r, clr_inner.g, clr_inner.b, calc_pulse )
                                        end

                                        design.rbox( 4, 0, 0, w, h, clr_outer )
                                        design.rbox( 4, 2, 2, w - 4, h - 4, clr_inner )
                                    end )

        /*
        *   slider > default slide
        */

        if k == 1 then
            self.b_slidesel.active = true
            if ui:ok( self.object ) then
                self.object:Clear( )

                self.object:SetHeader      ( v.header          )
                self.object:SetHeaderSub   ( v.header_sub      )
                self.object:SetBodyTitle   ( v.body_title      )
                self.object:SetBodyMsg     ( v.body_msg        )
                self.object:SetImg         ( v.img             )
                self.object:SetURL         ( v.link            )
                self.object:SetMaterial    ( v.bUseMat, v.mat  )
                self.object:SetState       ( false             )
            end
        end

        /*
        *   slider > DoClick
        */

        self.b_slidesel.DoClick = function( s )
            for _, button in pairs( tabs ) do
                button.active = false
            end

            s.active = true

            if ui:ok( self.object ) then
                self.object:Clear( )

                self.object:SetHeader      ( v.header          )
                self.object:SetHeaderSub   ( v.header_sub      )
                self.object:SetBodyTitle   ( v.body_title      )
                self.object:SetBodyMsg     ( v.body_msg        )
                self.object:SetImg         ( v.img             )
                self.object:SetURL         ( v.link            )
                self.object:SetMaterial    ( v.bUseMat, v.mat  )
                self.object:SetState       ( false             )
            end

            timex.expire( 'linx_slider_sw_pause' )
            timex.pause( 'linx_slider_sw' )
            timex.create( 'linx_slider_sw_pause', cfg.slider.resume_delay or 30, 1, function( )
                timex.resume( 'linx_slider_sw' )
            end )

            local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'swipe_01' ) )
            snd:PlayEx      ( 0.1, 100 )
        end

        /*
        *   slider > register slides
        */

        table.insert( tabs, self.b_slidesel )

        /*
        *   slider > left or right orientation pos of footer buttons
        */

        if ( cfg.slider.orientation == 2 ) then
            i_pos = i_pos - cfg.slider.btn_sz - 4
        else
            i_pos = i_pos + cfg.slider.btn_sz + 4
        end

        if ( cfg.slider.orientation == 2 ) then
            i = i - 1
        else
            i = i + 1
        end
    end

    self.rotateres, self.rotatingdata = 1, populate_data
    timex.create( 'linx_slider_sw', cfg.slider.autosw_delay, 0, function( )
        if not ui:ok( self ) then return end
        self.rotateres = ( isnumber( self.rotateres ) and self.rotateres + 1 ) or 1
        if ( self.rotateres > #self.rotatingdata ) then
            self.rotateres = 1
        end

        for k, v in pairs( populate_data ) do
            if not v.enabled then continue end
            tabs[ k ].active = false
            if k ~= self.rotateres then continue end

            self.object:Clear( )

            self.object:SetHeader      ( v.header          )
            self.object:SetHeaderSub   ( v.header_sub      )
            self.object:SetBodyTitle   ( v.body_title      )
            self.object:SetBodyMsg     ( v.body_msg        )
            self.object:SetImg         ( v.img             )
            self.object:SetURL         ( v.link            )
            self.object:SetMaterial    ( v.bUseMat, v.mat  )
            self.object:SetState       ( false             )

            tabs[ k ].active = true
        end
    end )

    /*
    *   slider > kill autoswitch timer if slide count less than
    *   2 total enabled
    */

    if #populate_data < 2 then
        timex.expire( 'linx_slider_sw' )
        ui:unstage( self.b_slidesel )
    end

end

/*
*   Resolution
*/

function PANEL:Resolution( )

    /*
    *   parent
    */

    self.p_resolution               = ui.new( 'pnl', self                   )
    :fill                           ( 'p', 10                               )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
                                        design.rbox( 4, 3, 3, w - 6, h - 6, Color( 25, 25, 25, 235 ) )
                                    end )

    /*
    *   msg title
    */

    self.p_title                    = ui.new( 'pnl', self.p_resolution      )
    :top                            ( 'm', 25, ScreenScale( 5 ), 25, 10     )
    :tall                           ( 25                                    )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( ln( 'sys_res_err_title' ), pref( 'news_res_name' ), w / 2, h / 2, Color( 220, 220, 220, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   msg description
    */

    self.dtxt_desc                  = ui.new( 'dt', self.p_resolution       )
    :fill                           ( 'm', 5, 2, 5, 5                       )
    :drawbg                         ( false                                 )
    :mline	                        ( true 				                    )
    :enabled                        ( true                                  )
    :canedit                        ( true                                  )
    :autoupdate	                    ( true 					                )
    :scur	                        ( Color( 200, 200, 200, 255 ), 'beam'   )
    :hlclr                          ( Color( 25, 25, 25, 255 )              )
    :txt	                        ( ln( 'sys_res_err_msg' ), Color( 230, 230, 230, 255 ), pref( 'news_res_text' ) )
    :align                          ( 5                                     )


    /*
    *   button > settings
    */

    self.b_settings                 = ui.new( 'btn', self.p_resolution      )
    :bsetup                         (                                       )
    :bottom                         ( 'm', 30, 5, 30, 5                     )
    :tall                           ( 30                                    )
    :clr                            ( Color( 255, 255, 255, 255 )           )
    :font                           ( pref( 'news_res_btn_cfg' )            )
    :text                           ( ln( 'sys_res_btn_settings' )          )
    :tip                            ( ln( 'sys_res_btn_tooltip' )           )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, w, h, clr_bind_active )

                                        local clr_box = s.hover and Color( 60, 60, 60, 255 ) or Color( 222, 98, 31, 255 )
                                        design.rbox( 4, 1, 1, w - 2, h - 2, clr_box )
                                    end )

                                    :oc( function( s )
                                        rcc.run.gmod( 'gamemenucommand', 'openoptionsdialog' )
                                        timex.simple( 0, function( ) rcc.run.gmod( 'gameui_activate' ) end )
                                    end )

end

/*
*   Think
*/

function PANEL:Think( )
    if not ui:ok( self ) then return end

    if ScrW( ) <= 1280 then
        ui:unstage( self.object )
        ui:unstage( self.sub )
        if not ui:visible( self.p_resolution ) then
            self:Resolution( )
            self:SetWide( cfg.general.reswarn_w )
            self:SetTall( cfg.general.reswarn_h )
            self:SetPos( ScrW( ) - cfg.general.reswarn_w - 100, self.sl_h - 13 )
        end
    else
        if ui:visible( self.p_resolution ) then
            ui:unstage( self.p_resolution )
            ui:stage( self.object )
            ui:stage( self.sub )
        end
    end
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    if cfg.slider.blur_enabled then
        design.blur( self, cfg.slider.blur_amt )
    end

    if cfg.slider.rounded_bg then
        design.rbox( 10, 0, 0, w, h, cfg.slider.clrs.rounded_bg )
    end
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   create
*/

ui:create( mod, 'pnl_news', PANEL, 'pnl' )
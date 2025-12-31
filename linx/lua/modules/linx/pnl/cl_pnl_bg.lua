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
    *   declare > bg
    */

    self.mat_bg                     = self:GetMaterial( )
    self.mat_clr                    = IsColor( cfg.bg.material.clr ) and cfg.bg.material.clr or Color( 255, 255, 255, 255 )

    /*
    *   declare > brokeh
    */

    self.bokeh_amt, self.bokeh_obj  = design:bokeh( cfg.bg.bokeh.quantity or 50, cfg.bg.bokeh.size or 50, cfg.bg.bokeh.speed or 10, cfg.bg.bokeh.clr or Color( 255, 255, 255 ), cfg.bg.bokeh.clr_a or 5 )

end

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   parent
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :fill                           ( 'm', 0                                )

    /*
    *   background
    */

    local bg                        = ui.new( 'dhtml', self                 )
    :fill                           ( 'm', 0                                )

                                    if ( cfg.bg.live.enabled or cfg.bg.static.enabled ) and ( cfg.bg.static.list or cfg.bg.live.list ) then
                                        local src_table = cfg.bg.static.list
                                        if cfg.bg.live.enabled then
                                            src_table = cfg.bg.live.list
                                            bg:SetHTML( ui:html_iframe( src_table, true ) )
                                        elseif cfg.bg.static.enabled then
                                            local htm = ui:html_img( src_table, true )
                                            bg:SetHTML( htm )
                                        end
                                    end

    /*
    *   filter
    *
    *   pnl that rests in front of the background pnl. allows for dimming, blur, and bokeh effects to appear
    *   in front of the selected wallpaper / live backgrounds
    */

    local filter                    = ui.new( 'pnl', bg                     )
    :size                           ( 'screen'                              )

                                    :draw( function( s, w, h )
                                        if cfg.bg.material.enabled and self.mat_bg then
                                            design.mat( 0, 0, w, h, self.mat_bg, self.mat_clr )
                                        end

                                        if cfg.bg.filter.blur then
                                            local amt = cfg.bg.filter.blur_power or 3
                                            design.blur( s, amt )
                                        end

                                        if cfg.bg.filter.enabled then
                                            design.box( 0, 0, w, h, cfg.bg.filter.clr or Color( 0, 0, 0, 200 ) )
                                        end

                                        if cfg.bg.bokeh.enabled then
                                            local bskin = cfg.bg.bokeh.skin or 'outlines'
                                            design:bokehfx( w, h, self.bokeh_amt, self.bokeh_obj, helper._bokehfx, bskin )
                                        end
                                    end )

end

/*
*   GetMaterial
*/

function PANEL:GetMaterial( )
    local src = ( istable( cfg.bg.material.list ) and table.Random( cfg.bg.material.list ) ) or nil
    return src or nil
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

ui:create( mod, 'pnl_bg', PANEL, 'pnl' )
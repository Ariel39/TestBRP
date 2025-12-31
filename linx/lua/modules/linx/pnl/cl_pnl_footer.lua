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
*   local declarations
*/

local clr_box       = cfg.footer.clrs.box
local clr_bar       = cfg.footer.clrs.bar

/*
*   panel
*/

local PANEL = { }

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   validate ply
    */

    if not helper.ok.ply( LocalPlayer( ) ) then return end
    local pl = LocalPlayer( )

    /*
    *   declare > demo mode
    */

    local bDemoMode                 = rcore:bInDemoMode( mod ) or false

    /*
    *   declare
    */

    local clr_pl_nfo                = cfg.general.clrs.text_plinfo

    /*
    *   pnl > bottom bar > left
    */

    self.p_left                     = ui.new( 'pnl', self, 1                )
    :left                           ( 'm', 0, 0, 0, 3                       )
    :wide                           ( ScreenScale( 150 )                    )

    /*
    *   pnl > bottom bar > left > col 1
    */

    self.p_left_col_1               = ui.new( 'pnl', self.p_left, 1         )
    :left                           ( 'm', 0                                )
    :wide                           ( 60                                    )

    /*
    *   pnl > bottom bar > left > col 2
    */

    self.p_left_col_2               = ui.new( 'pnl', self.p_left, 1         )
    :fill                           ( 'm', 5, 12, 0, 6                      )

    /*
    *   pnl > bottom bar > right
    */

    self.p_right                    = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0                                )

    /*
    *   player self.avatar
    */

    self.avatar                     = ui.new( 'rlib.ui.avatar', self.p_left_col_1 )
    :left                           ( 'm', 4, 7, 4                          )
    :wide                           ( 56                                    )
    :player                         ( pl, 56                                )
    :rounded                        ( true                                  )

    /*
    *   player name
    */

    self.l_name                     = ui.new( 'lbl', self.p_left_col_2      )
    :top                            ( 'm', 0                                )
    :notext                         (                                       )

                                    :draw( function( s, w, h )
                                        local pl_name = bDemoMode and cfg.dev.demo.name or pl:Name( )
                                        draw.SimpleText( pl_name:upper( ), pref( 'footer_pl_name' ), 0, h / 2 - 1, clr_pl_nfo, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   label > player steamid
    */

    self.l_group                    = ui.new( 'lbl', self.p_left_col_2      )
    :top                            ( 'm', 0                                )
    :notext                         (                                       )

                                    :draw( function( s, w, h )
                                        local pl_grp            = pl:getgroup( true )
                                        local pl_grp_title      = cfg.ugroups.titles[ pl_grp ] or 'User'
                                        local pl_grp_clr        = cfg.ugroups.clrs[ pl_grp ]
                                        draw.SimpleText( pl_grp_title, pref( 'footer_pl_group' ), 0, h / 2 - 1, pl_grp_clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   pnl > servers
    */

    self.p_servers                  = ui.rlib( mod, 'pnl_servers', self.p_right, 1 )
    :fill                           ( 'm', 0                                )
    :register                       ( '$pnl_servers', mod                   )

end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    design.box( 0, 0, w, h, clr_box )
    design.box( 0, 0, w, 2, clr_bar )
    design.box( 0, h - 2, w, 2, clr_bar )
end

/*
*   Think
*/

function PANEL:Think( )
    if not cfg.footer.enabled then
        self:Destroy( )
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

ui:create( mod, 'pnl_footer', PANEL, 'pnl' )
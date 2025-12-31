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
*   StructureMsg
*
*   handles ticker msgs that are available from config file.
*   supports string variable replacements which are explained
*   in the config file
*
*   @param  : str msg
*   @return : str
*/

function PANEL:StructureMsg( msg )
    if not isstring( msg ) then return '' end
    local bDemoMode     = rcore:bInDemoMode( mod ) or false

    msg                 = msg:Replace( '[sv_name]',         bDemoMode and cfg.dev.demo.server       or GetHostName( ) )
    msg                 = msg:Replace( '[sv_addr]',         bDemoMode and cfg.dev.demo.ip           or game.GetIPAddress( ) )
    msg                 = msg:Replace( '[pl_name]',         bDemoMode and cfg.dev.demo.name         or LocalPlayer( ):Name( ) )
    msg                 = msg:Replace( '[pl_sid]',          bDemoMode and cfg.dev.demo.sid32        or LocalPlayer( ):SteamID( ) )
    msg                 = msg:Replace( '[pl_sid64]',        bDemoMode and cfg.dev.demo.sid          or LocalPlayer( ):SteamID64( ) )
    msg                 = msg:Replace( '[sv_pop_now]',      bDemoMode and cfg.dev.demo.sv_pop_now   or helper.get.popcount( ) )
    msg                 = msg:Replace( '[sv_pop_max]',      bDemoMode and cfg.dev.demo.sv_pop_max   or game.MaxPlayers( ) )

    msg         = msg:upper( )

    return msg
end

/*
*   Init
*/

function PANEL:Init( )

    /*
    *   parent
    */

    self:Dock                       ( FILL                                  )

    /*
    *   declarations
    */

    self.bInitialized               = false
    self.results                    = math.random( table.Count( cfg.ticker.msgs ) )
    self.selected                   = cfg.ticker.msgs[ self.results ]
    self.selected                   = self:StructureMsg( self.selected )
    self.entry                      = isstring( self.selected ) and self.selected:upper( ) or ' '

    /*
    *   create ticker timer
    */

    timex.simple( 'linx_ticker_loader', 1,  function( )
        if not ui:ok( self ) then return end
        self:Run( )
    end )

end

/*
*   Run
*/

function PANEL:Run( )

    /*
    *   localized glua
    */

    local expire, exists, create    = timex.expire, timex.exists, timex.create

    /*
    *   ticker > parent
    */

    local parent                    = ui:call( '$pnl_ticker', mod )
                                    if not ui:ok( parent ) then return end
    /*
    *   ticker > sub
    */

    local sub                       = ui.new( 'pnl', parent                 )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0                                )

    /*
    *   ticker
    */

    self.ticker                     = ui.new( 'lbl', sub                    )
    :fill                           ( 'm', 0                                )
    :textadv                        ( cfg.ticker.clr or Color( 255, 255, 255, 255 ), pref( 'g_ticker' ), self.entry, true )
    :align                          ( 5                                     )

                                    :logic( function( s )
                                        if not self.bInitialized then
                                            expire( 'linx_ticker' )
                                        end

                                        if exists( 'linx_ticker' ) then return end

                                        self.bInitialized = true
                                        create( 'linx_ticker', cfg.ticker.delay or 10, 0, function( )
                                            if not self.results then return end

                                            self.results = ( isnumber( self.results ) and self.results + 1 ) or 1
                                            if ( self.results > table.Count( cfg.ticker.msgs ) ) then self.results = 1 end
                                            if not ui:valid( self ) or not ui:valid( s ) then return end

                                            local lbl   = cfg.ticker.msgs[ self.results ]
                                            local str   = self:StructureMsg( lbl ):upper( )

                                            s:alphato( 0, cfg.ticker.speed or 1.0, 0, function( )
                                                local ticker    = ui.get( s )
                                                :fill           ( 'm', 0                        )
                                                :txt            ( str, cfg.ticker.clr or Color( 255, 255, 255, 255 ), pref( 'g_ticker' ), true )
                                                :alphato        ( 255, cfg.ticker.speed or 1.0, 0, function( ) end )
                                            end )
                                        end )
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
*   assign
*/

ui:create( mod, 'pnl_ticker', PANEL, 'pnl' )
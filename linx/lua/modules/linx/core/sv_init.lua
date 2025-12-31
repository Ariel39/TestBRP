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
local access                = base.a
local helper                = base.h

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
*	initialize
*
*	initial setup
*/

local function initialize( )
    if not cfg.initialize.motd_enabled or not ulx then return end

    local int_cvar  = GetConVar( 'ulx_showMotd' )
    int_cvar:SetInt ( 0 )

    base:log( 1, ln( 'con_ulx_motd_disabled' ) )
end
rhook.new.gmod( 'Initialize', 'linx_sv_init', initialize )

/*
*	pl > join
*
*	determines if the ui should load when a player connects to the server.
*
*	@param  : ply pl
*/

local function ips_initialize( pl )
    timex.create( pl:aid64( mod.id, 'onjoin', 'delay' ), 3, 1, function( )

        /*
        *	welcome messages
        */

        if cfg.welcome.enabled and isfunction( cfg.welcome.action ) then
            cfg.welcome.action( pl )
        end

        /*
        *	precache
        */

        if cfg.initialize.precache and not cfg.initialize.motd_enabled then
            rnet.send.player( pl, 'linx_pl_join_pc' )
        end

        /*
        *	initialize data
        *
        *   motd_enabled == false
        *   setup pl tables but do not open motd
        */

        if not cfg.initialize.motd_enabled then
            rnet.send.player( pl, 'linx_initialize', { bopen = false } )
            return
        end

        /*
        *	cfg.dev.perm_canignore_enabled AND linx_motd_canignore perm true
        *
        *   setup pl tables but do not open motd
        */

        if cfg.dev.perm_canignore_enabled and access:strict( pl, 'linx_motd_canignore', mod ) then
            base.msg:target( pl, ln( 'motd' ), ln( 'sys_admin_ignore' ) )
            rnet.send.player( pl, 'linx_initialize', { bopen = false } )
            return
        end

        /*
        *	normal open
        *
        *   motd_enabled == true
        */

        rnet.send.player( pl, 'linx_initialize', { bopen = true } )
    end )
end
rhook.new.gmod( 'PlayerInitialSpawn', 'linx_pl_join_init', ips_initialize )
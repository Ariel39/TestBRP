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
*	psay > toggle
*
*	toggles the interface
*
*	@param  : ply pl
*	@param  : str text
*/

local function pl_say_toggle( pl, text )
    if not helper.ok.ply( pl ) then return end
    text = text:lower( )
    if cfg.binds.chat.main[ text ] then
        pl:rcc( 'linx_toggle_m0' )
        return ''
    end
end
rhook.new.gmod( 'PlayerSay', 'linx_ps_toggle', pl_say_toggle )

/*
*	psay > toggle > motd
*
*	toggles the interface if motd mode enabled
*
*	@param  : ply pl
*	@param  : str text
*/

local function pl_say_motd( pl, text )
    if not helper.ok.ply( pl ) then return end
    text = text:lower( )
    if cfg.binds.chat.motd[ text ] and cfg.initialize.motd_enabled then
        pl:rcc( 'linx_motd_m0' )
        return ''
    end
end
rhook.new.gmod( 'PlayerSay', 'linx_ps_motd', pl_say_motd )

/*
*	psay > toggle > rules
*
*	activates the rules ui without the main interface
*
*	@param  : ply pl
*	@param  : str text
*/

local function pl_say_rules( pl, text )
    if not helper.ok.ply( pl ) then return end
    text = text:lower( )
    if cfg.binds.chat.rules[ text ] then
        base.msg:route( pl, false, mod.name, ln( 'sys_gmsg_open_rules' ) )
        pl:rcc( 'linx_rules_m0' )
        return ''
    end
end
rhook.new.gmod( 'PlayerSay', 'linx_ps_rules', pl_say_rules )
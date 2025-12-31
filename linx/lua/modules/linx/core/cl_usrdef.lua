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
*	usrdef > setup
*
*	setup clientside params for a player
*
*   @param  : tbl data
*/

function mod.usrdef:Setup( data )

    local bHasRan   = false
    local bOpen     = data.bopen or false

    local function setup( )
        if not helper.ok.ply( LocalPlayer( ) ) or bHasRan then return end

        local pl                    = LocalPlayer( )

        pl.rlib                     = pl.rlib or { }                -- parent
        pl.rlib.linx                = pl.rlib.linx or { }           -- subparent
        pl.rlib.linx.res_w          = ScrW( )                       -- stored screen resolution ( w )
        pl.rlib.linx.res_h          = ScrH( )                       -- stored screen resolution ( h )

        if bOpen then
            mod.ui:Initialize( )
        end

        /*
        *	set initialized / destroy hook
        */

        bHasRan = true
        rhook.drop.gmod( 'Think', 'linx_usrdef_setup_think' )
    end
    rhook.new.gmod( 'Think', 'linx_usrdef_setup_think', setup )

end

/*
*	usrdef > res change
*
*	called when a player changes their monitor resolution
*
*   @param  : int old_w
*   @param  : int old_h
*/

local function usrdef_res_change( old_w, old_h )

end
rhook.new.gmod( 'OnScreenSizeChanged', 'linx_usrdef_res_change', usrdef_res_change )
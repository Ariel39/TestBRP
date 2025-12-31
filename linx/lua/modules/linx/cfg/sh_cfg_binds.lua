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

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'linx' )
local cfg               	= base.modules:cfg( mod )

/*
*   SETTINGS > BINDS
*/

    /*
    *   binds > key > main
    *
    *   key bind to activate interface
    *
    *   @type       : ENUM
    *   @default    : KEY_F2
    */

        cfg.binds.key.enabled       = true
        cfg.binds.key.main          = KEY_F8
        cfg.binds.key.delay         = 0.5

    /*
    *   binds > chat > main
    *
    *   chat commands which to open the main interface
    */

        cfg.binds.chat.main =
        {
            [ '!help' ]             = true,
        }

    /*
    *   binds > chat > motd
    *
    *   chat commands which to open the interface if motd enabled
    */

        cfg.binds.chat.motd =
        {
            [ '!motd' ]             = true,
        }

    /*
    *   binds > chat > rules
    *
    *   chat commands to open rules interface by itself without main
    *   interface
    */

        cfg.binds.chat.rules =
        {
            [ '!rules' ]            = true,
        }

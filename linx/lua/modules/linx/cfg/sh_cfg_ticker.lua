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
*   SETTINGS > TICKER
*/

    /*
    *   ticker > general
    *
    *	scrolls messages across the screen within the interface
    *
    *   >   enabled         : set TRUE to have the ticker show  within the interface
    *
    *   >   speed           : fade in / out speed time
    *                         higher numbers will make fade slower to complete
    *
    *   >   delay           : amount of time a message will stay in place before a new
    *                         message is selected
    *
    *   >   clrs            : various colors you can adjust
    *                         to change the actual text color, see cfg.ticker.messages
    */

        cfg.ticker =
        {
            enabled         = true,
            speed           = 2,
            delay           = 10,
            clr             = Color( 255, 255, 255, 255 )
        }

    /*
    *	ticker > messages
    *
    *   text allows for string variables to be used
    *
    *   >   string variables        : these are special vars you can use within the text of your ticker messages
    *                                 in order to pull specific data.
    *
    *                               : you MUST enclose them in brackets [sv_addr] || [sv_name] || [pl_name]
    *                                   >   sv_name         : server name / hostname
    *                                                         ( how it shows in gmod server browser )
    *                                   >   sv_addr         : server ip address
    *                                   >   sv_pop_now      : cur number of players on server
    *                                   >   sv_pop_max      : max number of players the server can support
    *                                   >   pl_name         : player name
    *                                   >   pl_sid          : player steam32 id
    *                                   >   pl_sid64        : player steam64 id
    */

        cfg.ticker.msgs =
        {
            '★★ Welcome to [sv_name] ★★',
            '★★ [pl_name] -- be sure to check out our links for more information! ★★',
            '★★ Click the servers tab to visit our other garrys mod servers ★★',
        }
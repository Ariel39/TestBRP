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
*   SETTINGS > WELCOME
*/

    /*
    *   posts a message in chat for all players to see when a new player joins
    *   the server
    *
    *   >   welcome.enabled         : true      > player will be introduced on server in chat
    *                               : false     > player will not be introduced
    *
    *   >   welcome.action          : what will happen when the player connects
    *                                 supports any lua ( if you have knowledge )
    */

        cfg.welcome.enabled     = false
        cfg.welcome.action      = function( pl )

            /*
            *	without steam id
            *   if you want steam id hidden, use the code below:
            *
            *   rlib.msg:target( nil, 'Welcome', 'Player', Color( 255, 255, 25 ), pl:palias( ), Color( 255, 255, 255 ), 'has connected.' )
            */

            rlib.msg:target( nil, 'Welcome', 'Player', Color( 255, 255, 25 ), pl:palias( ), Color( 13, 134, 255 ), '(' .. pl:sid( true ) .. ')', Color( 255, 255, 255 ), 'has connected.' )
        end
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
*   SETTINGS > ANNOUNCEMENTS
*/

    /*
    *	this displays a widget to the far right which allows for either text to be displayed, or an
    *   advertisement video.
    *
    *   typically used for announcing giveaways, new features, or big changes to your community.
    *
    *   :   note
    *       if cfg.slider.enabled = true, then announcements will not display. slider feature
    *       takes priority
    */

        cfg.announcements =
        {
            enabled             = false,
            blur_enabled        = true,
            blur_amt            = 5,
            clrs =
            {
                primary         = Color( 0, 0, 0, 220 ),
                header_icon     = Color( 240, 72, 133, 255 ),
                header_title    = Color( 240, 72, 133, 255 ),
                text            = Color( 255, 255, 255, 255 ),
            }
        }

    /*
    *	announcements > text
    *
    *	this is the actual text to display in the announcement widget
    */

        cfg.announcement =
        [[

Welcome to our server!

Your news will go here. It can be whatever you want, and can be modified by opening /sh/sh_config.lua

        ]]
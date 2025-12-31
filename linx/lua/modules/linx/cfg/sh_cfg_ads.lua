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
*   SETTINGS > ADS
*/

    /*
    *   this allows you to place video ads on your motd that are either sourced with youtube or webm format.
    *
    *   ensure that you enable only one method at a time, otherwise one will override the other and it may
    *   cause confusion.
    *
    *   :   WARNING
    *       due to gmod using an outdated copy of awesomium, youtube videos may not function properly and
    *       will throw back an HTML5 error. this is completely out of our control.
    *
    *       however, webm files do still work and will load properly if linked to a working video. you have
    *       the option to download a video on youtube and then use a free service to convert it to webm and
    *       then upload the converted webm to your host server.
    *
    *       free services:
    *           : youtube to mp4  =>  https://www.onlinevideoconverter.com/youtube-converter
    *           : mp4 to webm     =>  https://video.online-convert.com/convert-to-webm
    *
    *       converted webm can be resolutions of:
    *           : 640w x 360h
    *           : 320w x 180h
    *
    *       anything bigger appears will not render and videos will display as a black screen
    */

        cfg.ads =
        {
            youtube =
            {
                enabled     = false,
                urls =
                {
                    'http://www.youtube.com/embed/Bfr053KdD6w?autoplay=1&controls=1',
                }
            },
            webm =
            {
                enabled     = true,
                vol         = 0.2,
                autoplay    = false,
                urls =
                {
                    'http://cdn.rlib.io/ads/trailer_codbo4.webm',
                    'http://cdn.rlib.io/ads/trailer_lastyear.webm',
                }
            }
        }
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
*   SETTINGS > BACKGROUNDS
*/

    /*
    *   backgrounds > static
    *
    *   the first command of this section determines if the feature will be enabled or not this bool is
    *   associated to the table of objects directly below it.
    *
    *   if this option is enabled [ true ], please ensure you set its counter-part to false
    *   cfg.bg.live.enabled = false
    *
    *   set bg.enabled AND bg.live.enabled = false to have a transparent background (clear)
    */

        cfg.bg.static.enabled = true

        cfg.bg.static.list =
        {
            'http://cdn.rlib.io/wp/s/1.jpg',
            'http://cdn.rlib.io/wp/s/2.jpg',
            'http://cdn.rlib.io/wp/s/3.jpg',
            'http://cdn.rlib.io/wp/s/4.jpg',
            'http://cdn.rlib.io/wp/s/5.jpg',
            'http://cdn.rlib.io/wp/s/6.jpg',
            'http://cdn.rlib.io/wp/s/7.jpg',
            'http://cdn.rlib.io/wp/s/8.jpg',
            'http://cdn.rlib.io/wp/s/9.jpg',
        }

    /*
    *   backgrounds > live / animated
    *
    *   the first command of this section determines if the feature will be enabled or not
    *   this bool is associated to the table of objects directly below it.
    *
    *   if this option is enabled (set true), please ensure you set its counter-part to false
    *   cfg.bgs.enabled = false
    *
    *   @note   :   enabling live wallpapers can cause frame drops for players due to them being a full-screen
    *               moving video. seeing how this is an MOTD script that is full screen, the player won't
    *               notice any loss of frames since you're in the ui the entire time.
    *
    *   set bg.enabled AND bg.live.enabled = false to have a transparent background (clear)
    */

        cfg.bg.live.enabled = true

        cfg.bg.live.list =
        {
            'http://cdn.rlib.io/wp/l/index.php?id=default_1',
            'http://cdn.rlib.io/wp/l/index.php?id=default_2',
            'http://cdn.rlib.io/wp/l/index.php?id=default_3',
            'http://cdn.rlib.io/wp/l/index.php?id=default_4',
            'http://cdn.rlib.io/wp/l/index.php?id=default_5',
            'http://cdn.rlib.io/wp/l/index.php?id=default_6',
            'http://cdn.rlib.io/wp/l/index.php?id=default_7',
            'http://cdn.rlib.io/wp/l/index.php?id=default_8',
            'http://cdn.rlib.io/wp/l/index.php?id=default_9',
            'http://cdn.rlib.io/wp/l/index.php?id=default_10',
            'http://cdn.rlib.io/wp/l/index.php?id=default_11',
        }

    /*
    *   backgrounds > filter
    *
    *   applies a overlay color and/or effect to the background so that content on the interface appears better.
    *   this filter will display on TOP of any backgrounds you have enabled. this allows you to darken a
    *   background, or just use a solid color for the entire background if you wish
    *
    *   :   bg.filter.enabled
    *       determines if a filter should be used
    *
    *   :   bg.filter.clr
    *       filter overlay color to use (r, g, b, a )
    *
    *   :   bg.filter.blur
    *       applies a blur effect on top of backgrounds
    *       if you notice odd shadows on the edges of the interface; disable this.
    *
    *   :   bg.filter.blur_power
    *       how strong the blur should be. the higher the number, the stronger the blur.
    *       you can set this anywhere between 0 (no blur) and numbers like 5. do not go much
    *       higher or performance will be impacted
    */

        cfg.bg.filter.enabled       = true
        cfg.bg.filter.clr           = Color( 0, 0, 0, 50 )
        cfg.bg.filter.blur          = true
        cfg.bg.filter.blur_power    = 7

    /*
    *   backgrounds > material
    *
    *   should you wish to use a material as your primary background; enable this setting.
    *   if using this option; we recommend disabling the following:
    *
    *   >   cfg.bg.static.enabled = false
    *   >   cfg.bg.static.enabled = false
    */

        cfg.bg.material.enabled     = false
        cfg.bg.material.list        =
        {
            'path/to/material_1.png',
            'path/to/material_2.png',
        }
        cfg.bg.material.clr         = Color( 255, 255, 255, 255 )

    /*
    *   backgrounds > bokeh
    *
    *   animations that display in the background of the script
    *   you may either turn it on / off, or change the skin for everyone
    *
    *   :   enabled
    *       determines if bokeh is used or not
    *
    *   :   skin
    *       type of bokeh to use as the effect
    *           : outlines
    *           : gradients
    *           : circles
    *
    *   :   clr
    *       color to use for bokeh effect
    *           color table : Color( r, g, b )
    *           string      : random
    *
    *   :   clr_a
    *       opacity to apply for the coloring (alpha channel 0 - 255 )
    *           0       : invisible
    *           255     : solid
    *
    *   :   speed
    *       how fast the bokeh effects should move on the interface
    *
    *   :   size
    *       size of each bokeh effect that appears
    *
    *   :   quantity
    *       how many particles to generate in a given amount of time.
    *       larger renders more on screen at a time
    */

        cfg.bg.bokeh.enabled        = true
        cfg.bg.bokeh.skin           = 'circles'
        cfg.bg.bokeh.clr            = Color( 255, 255, 255 )
        cfg.bg.bokeh.clr_a          = 2
        cfg.bg.bokeh.speed          = 10
        cfg.bg.bokeh.size           = 50
        cfg.bg.bokeh.quantity       = 200
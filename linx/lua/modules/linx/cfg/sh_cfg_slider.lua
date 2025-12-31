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
*   SETTINGS > SLIDER
*/

    /*
    *   displays a news slider block to the right of the interface which will cycle through various
    *   slides after x seconds pass. slides can also be selected by pressing the buttons located below the
    *   slider boxes.
    *
    *   :   cfg.slider.enabled
    *       determines if the slider will be visible at all
    *
    *   :   cfg.slider.host
    *       this is utilized when you own multiple scripts with the same slider feature.
    *       setting ONE of the scripts cfg.slider.host = true will make ALL scripts
    *       grab the slider and color information from the host script. this keeps you from having
    *       to configure each and every one.
    *
    *   :   cfg.slider.host_define
    *       specifies which module will be the hoster of the data.
    *       setting this means that multiple scripts with a slider feature can share the slider
    *       information so that you dont have to configure each one individually.
    *
    *       :   REQUIRES cfg.slider.host = true
    *       :   MUST have slider feature in host script
    *       :   ONLY supports scripts by richard
    *
    *       ex:     cfg.slider.host         = true
    *               cfg.slider.host_define  = 'linx'
    *
    *   :   cfg.slider.rounded_bg
    *       will make a dark background appear behind the entire sliders feature
    *
    *   :   cfg.slider.rounded_bg_amt
    *       amount of padding to give to content within the rounded box.
    *       the higher the number, the bigger the gap between edge of box and content
    *
    *   :   cfg.slider.width, cfg.slider.height
    *       width and height of slider interface
    *
    *   :   cfg.slider.height_ui
    *       slider interface height, this should be bigger than cfg.slider.height as it
    *       houses both the slider AND the slider nav buttons at the bottom
    *
    *   :   cfg.slider.btn_sz
    *       button size, this is both the height and width of the button in order to make
    *       them even
    *
    *   :   cfg.slider.autosw_delay
    *       time between slides automatically changing
    *
    *   :   cfg.slider.resume_delay
    *       if a slider btn is pressed, auto-switching is paused. this timer
    *       determines how long after a pause, until sliders resume auto-cycling
    *
    *   :   cfg.slider.orientation
    *       which side that the slider selection buttons will display
    *           1   : left
    *           2   : right
    *
    *   :   cfg.slider.clrs
    *       color options available to determine how the sliders look
    */

        cfg.slider.enabled          = true
        cfg.slider.host             = false
        cfg.slider.host_define      = false
        cfg.slider.rounded_bg       = false
        cfg.slider.rounded_bg_amt   = 10
        cfg.slider.blur_enabled     = true
        cfg.slider.blur_amt         = 3
        cfg.slider.width            = 450
        cfg.slider.height           = { 90, 120, 80, 120, 90, 100, 80, 80 }
        cfg.slider.height_ui        = 170
        cfg.slider.btn_sz           = 24
        cfg.slider.autosw_delay     = 10
        cfg.slider.resume_delay     = 30
        cfg.slider.orientation      = 2

        cfg.slider.clrs =
        {
            banner                  = Color( 0, 0, 0, 200 ),
            hover_shadow            = Color( 15, 15, 15, 100 ),
            text_title              = Color( 255, 255, 255, 255 ),
            text_desc               = Color( 255, 255, 255, 255 ),
            btn_inner               = Color( 168, 70, 70, 255 ),
            btn_inner_hover         = Color( 88, 42, 42, 255 ),
            btn_outer               = Color( 10, 10, 10, 255 ),
            btn_outer_hover         = Color( 25, 25, 25, 255 ),
            btn_active              = Color( 192, 107, 107, 255 ),
            rounded_bg              = Color( 0, 0, 0, 200 ),
        }

    /*
    *   list of banners to appear in slider rotation
    *
    *   :   enabled
    *       determines if the specific banner will display or not
    *
    *   :   img
    *       url to use for the banner image
    *
    *   :   link
    *       click to open when banner is clicked by the player
    *
    *   :   header
    *       text to display in the bottom right corner of the banner
    *       ( optional )
    *
    *   :   header_sub
    *       text to display in the bottom right corner of the banner under header text
    *       ( optional )
    *
    *   :   body_title
    *       text to display as the header for the announcement
    *       ( displays below the banner in the blank area )
    *
    *   :   body_msg
    *       text to display as the message for the announcement
    *       ( displays below the banner in the blank area )
    */

        cfg.slider.list =
        {
            {
                enabled         = true,
                img             = 'http://cdn.rlib.io/wp/b/1.png',
                link            = 'https://linx.rlib.io/interval/slider',
                body_title      = 'Slide Name',
                body_msg        =
                [[
This is an example slide that you can customize to display important updates about your server.

Ensure that banners are at least [ 512 x 184 ] for the best fit.
                ]],
            },
            {
                enabled         = true,
                img             = 'http://cdn.rlib.io/wp/b/2.png',
                link            = 'https://linx.rlib.io/interval/slider',
                body_title      = 'Slide Name',
                body_msg        =
                [[
This is an example slide that you can customize to display important updates about your server.

Ensure that banners are at least [ 512 x 184 ] for the best fit.
                ]],
            },
        }
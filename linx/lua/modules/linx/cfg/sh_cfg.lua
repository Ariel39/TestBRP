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
*   SETTINGS > LANGUAGE
*/

    /*
    *	language
    *
    *	determines the language to use when translating particular strings.
    *	a list of available languages can be found in the addon MANIFEST / ENV file.
    *
    *	@type       : str
    *	@default    : 'en'
    */

        cfg.lang = 'en'

/*
*   SETTINGS > INITIALIZE
*/

    /*
    *	initialize > escape
    *
    *	determines if the interface will be activated if the ply presses esc
    *   will func as an escape screen
    *
    *	@type       : bool
    *	@default    : true
    */

        cfg.initialize.esc_enabled = true

    /*
    *	initialize > motd ( message of the day ) mode
    *
    *   >   true            : script will be displayed right when the player connects to the server.
    *                         they will need to close out of the interface in order to continue play.
    *
    *   >   false           : this script will only activate if the player uses the bind key [ default F9 ] or
    *                         types the assigned chat command [ see cfg.binds.chat.main setting ]
    *
    *   @type       : bool
    *   @default    : true
    */

        cfg.initialize.motd_enabled = false

    /*
    *	initialize > precache
    *
    *   : true      escape screen will be opened 'in the background' while the player is connecting
    *               to the server. This makes it so the player gets a quicker opening escape screen
    *               that doesnt take a few extra seconds to open the first time they do.
    *
    *   : false     no precaching will take place
    *
    *   @type       : bool
    *   @default    : false
    */

        cfg.initialize.precache = false

/*
*   SETTINGS > GENERAL
*/

    /*
    *	basic config values
    */

        cfg.general.network_name            = 'Server Name'
        cfg.general.margin_left             = 100
        cfg.general.margin_top              = { 25, 60, 30, 40, 30, 30, 30, 30 }
        cfg.general.header_tall             = { 100, 95, 77, 75, 55, 65, 50, 50 }
        cfg.general.anim_rotate_enabled     = true
        cfg.general.anim_rotate_speed       = 50
        cfg.general.sounds_enabled          = true
        cfg.general.reswarn_w               = 320
        cfg.general.reswarn_h               = 175

    /*
    *	general > colors
    */

        cfg.general.clrs =
        {
            btn_icon                        = Color( 113, 27, 12 ),
            btn_origmenu                    = Color( 255, 255, 255, 255 ),
            btn_console                     = Color( 255, 255, 255, 255 ),
            text_plinfo                     = Color( 176, 144, 97, 255 ),
            btn_exit                        = Color( 255, 255, 255, 255 ),
            confl_n_text                    = Color( 255, 255, 255, 255 ),
            confl_n_icon                    = Color( 240, 113, 113, 255 ),
        }

/*
*   SETTINGS > DIALOGS
*/

    /*
    *	these settings handle the dialog boxes that appear when certain actions are triggered such as trying
    *   to close the motd without accepting the terms, or connecting to a different server (confirmation box)
    */

        cfg.dialogs =
        {
            clrs =
            {

                /*
                *	default values for boxes
                *   controls text, cursor, and text highlighted colors
                */

                txt_default         = Color( 255, 255, 255, 255 ),
                cur_default         = Color( 200, 200, 200, 255 ),
                hli_default         = Color( 25, 25, 25, 255 ),

                /*
                *	interface colors
                */

                body_box            = Color( 40, 40, 40, 255 ),
                shadow_box          = Color( 20, 20, 20, 150 ),
                header_box          = Color( 30, 30, 30, 255 ),
                header_txt          = Color( 237, 237, 237, 255 ),
                header_ico          = Color( 240, 72, 133, 255 ),
                footer_box          = Color( 30, 30, 30, 255 ),
                errors_box          = Color( 114, 44, 44, 255 ),
                errors_txt          = Color( 255, 255, 255, 255 ),
                icon_resize         = Color( 240, 72, 133, 255 ),
                icon_bullet         = Color( 240, 113, 113, 255 ),

                /*
                *	error / notices
                *   displays at the top of some boxes when things go wrong
                */

                msg_box             = Color( 114, 44, 44, 255 ),
                msg_txt             = Color( 255, 255, 255, 255 ),
                desc_txt            = Color( 255, 255, 255, 255 ),

                /*
                *	exit button
                */

                btn_exit_n          = Color( 237, 237, 237, 255 ),                  -- btn color > ( normal )
                btn_exit_h          = Color( 200, 55, 55, 255 ),                    -- btn color > ( hovered )

                /*
                *	icons
                */

                ico_resize          = Color( 240, 72, 133, 255 ),                   -- ico color for resizing windows in bottom left of panels
                ico_bullet          = Color( 240, 113, 113, 255 ),                  -- ico color for 'asterisk' icon at the bottom of confirm boxes

                /*
                *	options below control the 'OK' / Confirm buttons that display when confirmation boxes appear
                */

                opt_ok_btn_n        = Color( 60, 120, 62, 255 ),                    -- btn color > ( normal )
                opt_ok_btn_h        = Color( 15, 15, 15, 100 ),                     -- btn color > ( hovered )
                opt_ok_txt          = Color( 255, 255, 255, 255 ),                  -- txt color > ( checkmark )

                /*
                *	options below control the 'No' / Disconnect buttons that display when confirmation boxes appear
                */

                opt_no_btn_n        = Color( 200, 55, 55, 255 ),                    -- btn color > ( normal )
                opt_no_btn_h        = Color( 15, 15, 15, 100 ),                     -- btn color > ( hovered )
                opt_no_txt          = Color( 255, 255, 255, 255 ),                  -- txt color > ( checkmark )

                /*
                *	options below control the 'alt' / Copy to Clipboard buttons that display when confirmation boxes appear
                */

                opt_al_btn_n        = Color( 31, 133, 222, 255 ),                   -- btn color > ( normal )
                opt_al_btn_h        = Color( 15, 15, 15, 100 ),                     -- btn color > ( hovered )
                opt_al_txt          = Color( 255, 255, 255, 255 ),                  -- txt color > ( checkmark )
            }
        }
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
*   SETTINGS > NAV BUTTONS
*/

    /*
    *	menu buttons [ top header menu ]
    *
    *	buttons that will display at the very top of the UI, which house buttons such as your community
    *   forums, rules, website, donations, etc.
    *
    *   these settings allow you to specify what link the button will go to.
    *
    *       int    :   true     button will open website in integrated browser built into script
    *                           please note that using this feature relies on an outdated framework provided by
    *                           facepunch which may cause certain websites to not load properly.
    *
    *               :   false   button will open website in steam web browser overlay
    *
    *   @note   :   to translate the button names/description, open addons manifest file and change the language
    */

    /*
    *	menu button > network rules
    */

        cfg.nav.btn.rules_url       = 'https://linx.rlib.io/internal/rules'
        cfg.nav.btn.rules_int       = true

    /*
    *	menu button > donations
    */

        cfg.nav.btn.donate_url      = 'https://linx.rlib.io/internal/demo'
        cfg.nav.btn.donate_int      = false

    /*
    *	menu button > community website
    */

        cfg.nav.btn.website_url     = 'https://steamcommunity.com/groups/gmodstore'
        cfg.nav.btn.website_int     = false

    /*
    *	menu button > steam workshop collection
    */

        cfg.nav.btn.workshop_url    = 'https://steamcommunity.com/workshop/filedetails/?id=2315070701'
        cfg.nav.btn.workshop_int    = false

    /*
    *   navigation menu
    *
    *   settings related to the main menu that appears to the left of the interface
    *
    *   :   clrs.icon, clrs.icon_hover
    *       color of the icon to the far left
    *
    *   :   clrs.btn, clrs.btn_hover
    *       color of major (right) side of button where text will show
    *
    *   :   clrs.btn_icon
    *       color of the left-side background that sits behind the button icon
    *
    *   :   clrs.btn_icon_min, clrs.btn_icon_max
    *       color of alpha channel to pulse in range of when button is hovered
    *
    *   :   clrs.text, clrs.text_hover
    *       color of text for each button
    *
    *   :   clrs.textsub, clrs.textsub_hover
    *       color of secondary text (below button name)
    */

        cfg.nav.general =
        {
            btn_use_textonly        = false,
            btn_hide_desc           = false,
            truncate_len_name       = 20,
            truncate_len_desc       = 50,
            btn_lines_enabled       = true,
            btn_lines_width         = 2,
            btn_sz_h                = 44,
            btn_sz_w                = 300,
            header_sz_ico           = 28,
            clrs =
            {
                bg_main             = Color( 255, 255, 255, 255 ),
                icon                = Color( 255, 255, 255, 255 ),
                icon_hover          = Color( 168, 70, 70, 255 ),
                btn                 = Color( 255, 255, 255, 170 ),
                text                = Color( 255, 255, 255, 255 ),
                text_hover          = Color( 255, 255, 255, 255 ),
                textsub             = Color( 200, 200, 200, 255 ),
                textsub_hover       = Color( 168, 70, 70, 255 ),
                box_hover           = Color( 10, 10, 10, 150 ),
                box_icon            = Color( 25, 25, 25, 230 ),
                box_lines           = Color( 255, 255, 255, 100 ),
                box_lines_hover     = Color( 168, 70, 70, 255 ),
                box_lines_pulse     = Color( 255, 255, 255, 255 ),
            },
        }

    /*
    *	nav menu > list
    *
    *   :   enabled
    *       determines if the menu item displays or not
    *
    *   :   name
    *       name of menu item ( called from addon translation file )
    *
    *   :   desc
    *       description ( called under menu name )
    *
    *   :   icon
    *       icon to display ( registered in the addons manifest / env file )
    *       removing this will make icon default to a star
    *
    *   :   action
    *       functionality that occurs when button is clicked
    */

        cfg.nav.list =
        {
            {
                enabled         = true,
                id              = 'resume',
                name            = 'mnu_btn_resume_name',
                desc            = 'mnu_btn_resume_desc',
                icon            = 'btn_resume_2',
                action          = function( )
                                    mod.ui:Hide( )
                                end
            },
            {
                enabled         = true,
                bIntegrated     = cfg.nav.btn.rules_int,
                id              = 'rules',
                name            = 'mnu_btn_rules_name',
                desc            = 'mnu_btn_rules_desc',
                icon            = 'btn_rules_2',
                action          = function( )
                                    mod.rules:Open( cfg.nav.btn.rules_url, cfg.nav.btn.rules_int )
                                end
            },
            {
                enabled         = true,
                bIntegrated     = cfg.nav.btn.donate_int,
                id              = 'donate',
                name            = 'mnu_btn_donate_name',
                desc            = 'mnu_btn_donate_desc',
                icon            = 'btn_donate_2',
                action          = function( )
                                    mod.web:OpenURL( 'mnu_btn_donate_name', cfg.nav.btn.donate_url, cfg.nav.btn.donate_int or false )
                                end
            },
            {
                enabled         = true,
                bIntegrated     = cfg.nav.btn.website_int,
                id              = 'website',
                name            = 'mnu_btn_website_name',
                desc            = 'mnu_btn_website_desc',
                icon            = 'btn_website_2',
                action          = function( )
                                    mod.web:OpenURL( 'mnu_btn_website_name', cfg.nav.btn.website_url, cfg.nav.btn.website_int or false )
                                end
            },
            {
                enabled         = true,
                bIntegrated     = cfg.nav.btn.workshop_int,
                id              = 'workshop',
                name            = 'mnu_btn_workshop_name',
                desc            = 'mnu_btn_workshop_desc',
                icon            = 'btn_steam_2',
                action          = function( )
                                    mod.web:OpenURL( 'mnu_btn_workshop_name', cfg.nav.btn.workshop_url, cfg.nav.btn.workshop_int or false )
                                end
            },
            {
                enabled         = true,
                bSpacer         = true,
                tall            = 90,
            },
            {
                enabled         = true,
                id              = 'settings',
                name            = 'mnu_btn_settings_name',
                desc            = 'mnu_btn_settings_desc',
                icon            = 'btn_settings_1',
                action          = function( )
                                    rcc.run.gmod( 'gamemenucommand', 'openoptionsdialog' )
                                    timex.simple( 0, function( ) rcc.run.gmod( 'gameui_activate' ) end )
                                end
            },
            {
                enabled         = false,
                id              = 'console',
                name            = 'mnu_btn_console_name',
                desc            = 'mnu_btn_console_desc',
                icon            = 'btn_console_1',
                action          = function( )
                                    rcc.run.gmod( 'showconsole' )
                                    timex.simple( 0, function( ) rcc.run.gmod( 'gameui_activate' ) end )
                                end
            },
            {
                enabled         = true,
                id              = 'disconnect',
                name            = 'mnu_btn_disconnect_name',
                desc            = 'mnu_btn_disconnect_desc',
                icon            = 'btn_disconnect_2',
                action          = function( )
                                    if CLIENT then
                                        mod.dc:Initialize( )
                                    end
                                end
            },
            {
                enabled         = false,
                id              = 'mainmenu',
                name            = 'mnu_btn_mainmenu_name',
                desc            = 'mnu_btn_mainmenu_desc',
                icon            = 'btn_main_1',
                action          = function( )
                                    mod.ui:Hide( )
                                    gui.ActivateGameUI( )
                                end
            },
        }
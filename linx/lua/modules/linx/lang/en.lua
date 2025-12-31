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
*   translations
*/

mod.language[ 'en' ] =
{
    mnu_btn_group_name              = 'Steam Group',
    mnu_btn_group_desc              = 'Join our steam group',
    mnu_btn_forums_name             = 'Forums',
    mnu_btn_forums_desc             = 'Talk to our community',
    mnu_btn_donate_name             = 'Donate',
    mnu_btn_donate_desc             = 'Help keep us running',
    mnu_btn_website_name            = 'Website',
    mnu_btn_website_desc            = 'Official website',
    mnu_btn_workshop_name           = 'Workshop',
    mnu_btn_workshop_desc           = 'Steam Collection',
    mnu_btn_discord_name            = 'Discord',
    mnu_btn_discord_desc            = 'Visit our discord',
    mnu_btn_rules_name              = 'Rules',
    mnu_btn_rules_desc              = 'What you should know',
    mnu_btn_resume_name             = 'Resume',
    mnu_btn_resume_desc             = 'Continue playing',
    mnu_btn_settings_name           = 'Settings',
    mnu_btn_settings_desc           = 'Configure your GMod',
    mnu_btn_console_name            = 'Console',
    mnu_btn_console_desc            = 'Pretend to be important',
    mnu_btn_disconnect_name         = 'Disconnect',
    mnu_btn_disconnect_desc         = 'Disconnect from server',
    mnu_btn_mainmenu_name           = 'Main Menu',
    mnu_btn_mainmenu_desc           = 'Return to main menu',

    browser_untitled                = 'untitled',
    online_title                    = 'ONLINE',
    slide_incr                      = 'Slide %i',
    connect_to_server               = 'Connect » %s',
    connect_confirm                 = 'Are you sure you want to connect to %s?\n\nYou will be connected automatically',
    please_setup_servers            = 'Please setup server ip/port',
    invalid_ipport                  = 'Invalid ip/port',
    copied_to_clipboard             = 'Copied to clipboard',
    sec_announcements               = 'Announcements',
    rules_name                      = 'Rules & Network Policies',
    motd                            = 'MOTD',

    sys_res_err_title               = 'Bad Resolution',
    sys_res_btn_settings            = 'Video Settings',
    sys_res_err_msg                 = 'Your monitor resolution is too small to see certain features. Please increase it in Video Settings',
    sys_res_btn_tooltip             = 'Open video settings',
    sys_btn_noname                  = '#NONAME',
    sys_init_interface              = 'Initializing interface ...',
    sys_mreschng                    = 'monitor resolution changed',
    sys_ann_sl_confl_title          = 'Feature Collision Issue',
    sys_ann_sl_confl_msg            = 'Both cfg.slider AND cfg.announcements are enabled. Disable one to avoid conflict',
    sys_admin_ignore                = 'You have permissions to ignore the MOTD on join',
    sys_gmsg_open_rules             = 'Opening rules ...',
    con_ulx_motd_disabled           = 'ULX MOTD disabled',

    tooltip_rules_btn               = 'OK',
    tooltip_origmenu_window         = 'Show gmod menu',
    tooltip_console_window          = 'Open Console',
    tooltip_rules_window            = 'Open Rules',
    tooltip_confirm_yes             = 'Yes, connect',
    tooltip_confirm_no              = 'No, stay',
    tooltip_copy_ipport             = 'Copy ip/port to clipboard',
    tooltip_close_window            = 'Close Window',

    diag_dc_btn_title               = 'Disconnect?',
    diag_dc_btn_msg                 = 'Are you sure you want to disconnect from this server?',
    diag_dc_btn_sub                 = 'Wish to Leave?',
    diag_dc_btn_tip_stay            = 'Stay',
    diag_dc_btn_tip_leave           = 'Leave',
    diag_dc_con_resp_l1             = 'Thanks for playing!',
    diag_dc_con_resp_l2             = 'If you wish to return, please add us to your favorites:',

    ibws_name                       = 'Website Issues?',
    ibws_tip_warning                = 'Issues seeing websites?',
    ibws_diag_desc_admin            = 'Blank or bad pages? This is due to an issue with gmod which uses an outdated library to display websites.\n\nTo fix this; switch to the steam overlay browser by opening lua/modules/linx/cfg/sh_cfg_nav.lua and change the setting:',
    ibws_diag_desc_user             = 'Website won\'t load? Contact an admin and let them know',
    ibws_diag_srcstr_admin          = 'cfg.nav.btn.%s_int = false',
    ibws_diag_srcstr_user           = 'I understand',
    ibws_diag_ok_txt                = 'I understand',
    ibws_diag_ok_tip                = 'Got it',
}
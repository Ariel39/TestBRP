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
*   module data
*/

    MODULE                  = { }
    MODULE.calls            = { }
    MODULE.resources        = { }

    MODULE.enabled          = true
    MODULE.parent		    = linx or { }
    MODULE.demo             = false
    MODULE.name             = 'Linx'
    MODULE.id               = 'linx'
    MODULE.author           = 'Richard'
    MODULE.desc             = 'escape screen'
    MODULE.docs             = 'https://linx.rlib.io/'
    MODULE.url              = 'https://gmodstore.com/scripts/view/7a3ae40d-73de-4f55-81c6-769b74aa288c/'
    MODULE.icon             = 'https://cdn.rlib.io/gms/7a3ae40d-73de-4f55-81c6-769b74aa288c/env.png'
    MODULE.script_id	    = '7a3ae40d-73de-4f55-81c6-769b74aa288c'
    MODULE.owner		    = '76561198130610772'
    MODULE.build            = 0
    MODULE.version          = { 2, 4, 0, 0 }
    MODULE.libreq           = { 3, 2, 1, 0 }
    MODULE.released		    = 1616389083

/*
*   workshops
*/

    MODULE.fastdl           = true
    MODULE.precache         = true
    MODULE.ws_enabled       = true
    MODULE.ws_lst           = '2315070701'

/*
*   fonts
*/

    MODULE.fonts = { }

/*
*   logging
*/

    MODULE.logging = true

/*
*   translations
*/

    MODULE.language = { }

/*
*   materials
*/

    MODULE.mats =
    {
        [ 'btn_close_1' ]                   = { 'rlib/modules/linx/v2/btn_close_1.png' },
        [ 'btn_connect_1' ]                 = { 'rlib/modules/linx/v2/btn_connect_1.png' },
        [ 'btn_console_1' ]                 = { 'rlib/modules/linx/v2/btn_console_1.png' },
        [ 'btn_console_2' ]                 = { 'rlib/modules/linx/v2/btn_console_2.png' },
        [ 'btn_disconnect_1' ]              = { 'rlib/modules/linx/v2/btn_disconnect_1.png' },
        [ 'btn_disconnect_2' ]              = { 'rlib/modules/linx/v2/btn_disconnect_2.png' },
        [ 'btn_discord_1' ]                 = { 'rlib/modules/linx/v2/btn_discord_1.png' },
        [ 'btn_discord_2' ]                 = { 'rlib/modules/linx/v2/btn_discord_2.png' },
        [ 'btn_donate_1' ]                  = { 'rlib/modules/linx/v2/btn_donate_1.png' },
        [ 'btn_donate_2' ]                  = { 'rlib/modules/linx/v2/btn_donate_2.png' },
        [ 'btn_forums_1' ]                  = { 'rlib/modules/linx/v2/btn_forums_1.png' },
        [ 'btn_main_1' ]                    = { 'rlib/modules/linx/v2/btn_main_1.png' },
        [ 'btn_resume_1' ]                  = { 'rlib/modules/linx/v2/btn_resume_1.png' },
        [ 'btn_resume_2' ]                  = { 'rlib/modules/linx/v2/btn_resume_2.png' },
        [ 'btn_rules_1' ]                   = { 'rlib/modules/linx/v2/btn_rules_1.png' },
        [ 'btn_rules_2' ]                   = { 'rlib/modules/linx/v2/btn_rules_2.png' },
        [ 'btn_server_1' ]                  = { 'rlib/modules/linx/v2/btn_server_1.png' },
        [ 'btn_settings_1' ]                = { 'rlib/modules/linx/v2/btn_settings_1.png' },
        [ 'btn_settings_2' ]                = { 'rlib/modules/linx/v2/btn_settings_2.png' },
        [ 'btn_steam_1' ]                   = { 'rlib/modules/linx/v2/btn_steam_1.png' },
        [ 'btn_steam_2' ]                   = { 'rlib/modules/linx/v2/btn_steam_2.png' },
        [ 'btn_website_1' ]                 = { 'rlib/modules/linx/v2/btn_website_1.png' },
        [ 'btn_website_2' ]                 = { 'rlib/modules/linx/v2/btn_website_2.png' },
        [ 'btn_website_3' ]                 = { 'rlib/modules/linx/v2/btn_website_3.png' },
        [ 'btn_workshop_1' ]                = { 'rlib/modules/linx/v2/btn_workshop_1.png' },
        [ 'btn_gmod_menu_1' ]               = { 'rlib/modules/linx/v2/ico/gmod_logo_1.png' },
        [ 'btn_gmod_menu_2' ]               = { 'rlib/modules/linx/v2/ico/gmod_menu_1.png' },
    }

/*
*   permissions
*/

    MODULE.permissions =
    {
        [ 'index' ] =
        {
            category                = 'RLib » Linx',
            module                  = 'Linx',
        },
        [ 'linx_motd_canignore' ] =
        {
            id                      = 'linx_motd_canignore',
            svg_id                  = 'Linx » Can Ignore',
            desc                    = 'Allows a group to not see the MOTD at all when they join the server',
            usrlvl                  = 'superadmin',
        },
        [ 'linx_ui_open' ] =
        {
            id                      = 'linx_ui_open',
            name                    = 'UI: Open',
            ulx_id                  = 'ulx linx_ui_open',
            sam_id                  = 'esc_ui_open',
            xam_id                  = 'esc_ui_open',
            svg_id                  = 'Linx » Open UI',
            desc                    = 'Opens escape screen',
            notify                  = '%s forced interface open on %s',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
        [ 'linx_ui_rehash' ] =
        {
            id                      = 'linx_ui_rehash',
            name                    = 'UI: Rehash',
            ulx_id                  = 'ulx linx_ui_rehash',
            sam_id                  = 'esc_ui_rehash',
            xam_id                  = 'esc_ui_rehash',
            svg_id                  = 'Linx » Rehash UI',
            desc                    = 'Destroys and re-creates interface. Useful for forcing new settings',
            notify                  = '%s forced interface rehash on %s',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
        [ 'linx_rnet_reload' ] =
        {
            id                      = 'linx_rnet_reload',
            name                    = 'Reload RNet',
            ulx_id                  = 'ulx linx_rnet_reload',
            sam_id                  = 'esc_rnet_reload',
            xam_id                  = 'esc_rnet_reload',
            svg_id                  = 'Linx » Reload Rnet',
            desc                    = 'Registers all network entries for script. Developer purposes only.',
            notify                  = '%s successfully reloaded rnet',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
        [ 'linx_fonts_reload' ] =
        {
            id                      = 'linx_fonts_reload',
            name                    = 'Reload Fonts',
            ulx_id                  = 'ulx linx_fonts_reload',
            sam_id                  = 'esc_fonts_reload',
            xam_id                  = 'esc_fonts_reload',
            svg_id                  = 'Linx » Reload Fonts',
            desc                    = 'Reloads all registered fonts.',
            notify                  = '%s successfully reloaded fonts',
            usrlvl                  = 'superadmin',
            bExt                    = true,
        },
    }

/*
*   storage > sh
*/

    MODULE.storage =
    {
        breadcrumb          = { },
        dc                  = { },
        ticker              = { },
        web                 = { },
        rules               = { },
        settings =
        {
            servers         = { },
            slider          = { },
            ticker          = { },
            ugroups         = { },
            header          = { },
            footer          = { },
            welcome         = { },
        }
    }

/*
*   storage > sv
*/

    MODULE.storage_sv = { }

/*
*   storage > cl
*/

    MODULE.storage_cl = { }

/*
*   datafolder
*/

    MODULE.datafolder = { }

/*
*   calls > net
*/

    MODULE.calls.net =
    {
        [ 'linx_initialize' ]                   = { 'linx.initialize' },
        [ 'linx_ui_init' ]                      = { 'linx.ui.init' },
        [ 'linx_ui_rehash' ]                    = { 'linx.ui.rehash' },
        [ 'linx_pl_join_pc' ]                   = { 'linx.pl.join.pc' },
        [ 'linx_fonts_reload' ]                 = { 'linx.fonts.reload' },
    }

/*
*   calls > hooks
*/

    MODULE.calls.hooks =
    {
        [ 'linx_sv_init' ]                      = { 'linx.sv.init' },
        [ 'linx_cl_init' ]                      = { 'linx.cl.init' },
        [ 'linx_cl_ipe' ]                       = { 'linx.cl.ipe' },
        [ 'linx_pl_join_init' ]                 = { 'linx.pl.join.init' },
        [ 'linx_ps_toggle' ]                    = { 'linx.ps.toggle' },
        [ 'linx_ps_motd' ]                      = { 'linx.ps.motd' },
        [ 'linx_ps_rules' ]                     = { 'linx.ps.rules' },
        [ 'linx_binds_esc_prender' ]            = { 'linx.binds.esc.prender' },
        [ 'linx_th_general' ]                   = { 'linx.th.general' },
        [ 'linx_th_ui' ]                        = { 'linx.th.ui' },
        [ 'linx_th_keybind' ]                   = { 'linx.th.keybind' },
        [ 'linx_rnet_register' ]                = { 'linx.rnet.register' },
        [ 'linx_fonts_register' ]               = { 'linx.fonts.register' },
        [ 'linx_overlay_copy' ]                 = { 'linx.overlay.copy' },
        [ 'linx_usrdef_setup_think' ]           = { 'linx.usrdef.setup.think' },
        [ 'linx_usrdef_res_change' ]            = { 'linx.usrdef.res.change' },
    }

/*
*   calls > timers
*/

    MODULE.calls.timers =
    {
        [ 'linx_pl_join_delay' ]                = { 'linx.pl.join.delay' },
        [ 'linx_pl_join_pc' ]                   = { 'linx.pl.join.pc' },
        [ 'linx_slider_sw' ]                    = { 'linx.slider.sw' },
        [ 'linx_slider_sw_pause' ]              = { 'linx.slider.sw.pause' },
        [ 'linx_ticker' ]                       = { 'linx.ticker' },
        [ 'linx_refresh' ]                      = { 'linx.refresh' },
        [ 'linx_copy_anim' ]                    = { 'linx.copy.anim' },
    }

/*
*   calls > commands
*/

    MODULE.calls.commands =
    {
        [ 'linx_toggle_m0' ] =
        {
            id                      = 'linx',
            desc                    = 'opens escape screen',
            scope                   = 3
        },
        [ 'linx_toggle_m1' ] =
        {
            id                      = 'help',
            desc                    = 'opens escape screen',
            scope                   = 3
        },
        [ 'linx_motd_m0' ] =
        {
            id                      = 'motd',
            desc                    = 'opens motd (if enabled)',
            scope                   = 3
        },
        [ 'linx_rules_m0' ] =
        {
            id                      = 'linx.rules',
            desc                    = 'displays rules ui without motd',
            scope                   = 3
        },
        [ 'linx_rules_m1' ] =
        {
            id                      = 'rules',
            desc                    = 'displays rules ui without motd',
            scope                   = 3
        },
        [ 'linx_ui_rehash' ] =
        {
            id                      = 'linx.ui.rehash',
            desc                    = 'completely destroys all pnls and re-creates them',
            scope                   = 3
        },
        [ 'linx_rnet_reload' ] =
        {
            id                      = 'linx.rnet.reload',
            desc                    = 'reloads module rnet module',
            is_hidden               = true,
            scope                   = 1,
        },
        [ 'linx_fonts_reload' ] =
        {
            id                      = 'linx.fonts.reload',
            desc                    = 'reloads all fonts',
            is_hidden               = true,
            scope                   = 2,
        },
    }

/*
*   resources > particles
*/

    MODULE.resources.ptc = { }

/*
*   resources > sounds
*/

    MODULE.resources.snd =
    {
        [ 'mouseover_01' ]          = { 'rlib/general/actions/mo_1.mp3' },
        [ 'mouseover_02' ]          = { 'rlib/general/actions/mo_2.mp3' },
        [ 'swipe_01' ]              = { 'rlib/general/actions/sw_1.mp3' },
    }

/*
*   resources > models
*/

    MODULE.resources.mdl = { }

/*
*   resources > panels
*/

    MODULE.resources.pnl =
    {
        [ 'pnl_ann' ]               = { 'linx.pnl.announce' },
        [ 'pnl_bg' ]                = { 'linx.pnl.bg' },
        [ 'pnl_confl' ]             = { 'linx.pnl.confl' },
        [ 'pnl_header' ]            = { 'linx.pnl.header' },
        [ 'pnl_footer' ]            = { 'linx.pnl.footer' },
        [ 'pnl_nav' ]               = { 'linx.pnl.nav' },
        [ 'pnl_news' ]              = { 'linx.pnl.news' },
        [ 'pnl_news_item' ]         = { 'linx.pnl.news.item' },
        [ 'pnl_rules' ]             = { 'linx.pnl.rules' },
        [ 'pnl_rules_web' ]         = { 'linx.pnl.rules.web' },
        [ 'pnl_servers' ]           = { 'linx.pnl.servers' },
        [ 'pnl_ticker' ]            = { 'linx.pnl.ticker' },
        [ 'pnl_ibws' ]              = { 'linx.pnl.ibws' },
        [ 'diag_ibws_notice' ]      = { 'linx.diag.ibws.notice' },
        [ 'diag_dcserv' ]           = { 'linx.diag.dcserv' },
        [ 'diag_cwserv' ]           = { 'linx.diag.cwserv' },
    }

/*
*   doclick
*/

    MODULE.doclick = function( ) end

/*
*   dependencies
*/

    MODULE.dependencies =
    {

    }
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
local access                = base.a
local helper                = base.h
local font                  = base.f

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'linx' )
local cfg               	= base.modules:cfg( mod )

/*
*   misc localization
*/

local _f                    = font.new

/*
*   fonts > primary
*/

local function fonts_register( pl )

    /*
    *	perm > reload
    */

        if ( ( helper.ok.ply( pl ) or base.con:Is( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
    *   general
    */

        _f( pf, 'g_ticker',                 'Roboto Lt', 18, 200 )
        _f( pf, 'g_confl_icon',             'Roboto', 60, 400 )
        _f( pf, 'g_confl_name',             'Roboto', 18, 400 )
        _f( pf, 'g_confl_body',             'Roboto Lt', 16, 100 )
        _f( pf, 'g_section_name',           'Advent Pro Light', 32, 200, true )

    /*
    *   servers
    */

        _f( pf, 'serv_btn_name',            'Oswald Light', 25, 400 )

    /*
    *   pl info
    */

        _f( pf, 'pl_online_text',           'Advent Pro Light', 14, 300 )
        _f( pf, 'pl_online_data',           'Roboto Lt', 22, 200 )

    /*
    *   nav menu
    */

        _f( pf, 'nav_item_name',            'Oswald Light', 28, 300 )
        _f( pf, 'nav_item_name_lg',         'Oswald Light', 30, 300 )
        _f( pf, 'nav_item_desc',            'Open Sans', 15, 500 )

    /*
    *   switch server dialog
    */

        _f( pf, 'cws_hdr_icon',             'Roboto Light', 24, 100 )
        _f( pf, 'cws_hdr_name',             'Roboto Light', 16, 600 )
        _f( pf, 'cws_hdr_exit',             'Roboto', 40, 800 )
        _f( pf, 'cws_btn_clr',              'Roboto', 41, 800 )
        _f( pf, 'cws_btn_copy',             'Roboto', 18, 800 )
        _f( pf, 'cws_btn_confirm',          'Roboto', 18, 800 )
        _f( pf, 'cws_err',                  'Roboto', 14, 800 )
        _f( pf, 'cws_desc',                 'Roboto Light', 16, 400 )
        _f( pf, 'cws_info',                 'Roboto Light', 16, 400 )
        _f( pf, 'cws_info_icon',            'Roboto Light', 31, 100 )
        _f( pf, 'cws_copyclip',             'Roboto Light', 14, 100, true )

    /*
    *   news
    */

        _f( pf, 'news_res_name',            'Roboto', 24, 400, true )
        _f( pf, 'news_res_text',            'Roboto Light', 17, 200 )
        _f( pf, 'news_res_btn_cfg',         'Roboto Light', 18, 200 )

    /*
    *   sliders
    */

        _f( pf, 'sli_header',               'Roboto', 28, 200 )
        _f( pf, 'sli_header_sub',           'Roboto', 18, 200 )
        _f( pf, 'sli_body_name',            'Roboto Lt', 28, 200 )
        _f( pf, 'sli_body_body',            'Segoe UI Light', 20, 100 )

    /*
    *   ibws
    */

        _f( pf, 'ibws_exit',                'Roboto', 40, 800 )
        _f( pf, 'ibws_icon',                'Roboto Light', 34, 100 )
        _f( pf, 'ibws_name',                'Roboto Light', 16, 600 )

    /*
    *   ibws > diag
    */

        _f( pf, 'ibws_diag_hdr_icon',       'Roboto Light', 24, 100 )
        _f( pf, 'ibws_diag_hdr_name',       'Roboto Light', 16, 600 )
        _f( pf, 'ibws_diag_hdr_exit',       'Roboto', 40, 800 )
        _f( pf, 'ibws_diag_desc',           'Roboto Light', 16, 400 )
        _f( pf, 'ibws_diag_txt_ack',        'Roboto Light', 16, 400 )
        _f( pf, 'ibws_diag_btn_ack',        'Roboto', 18, 800 )
        _f( pf, 'ibws_diag_ico_hint',       'GSym Solid', 14, 800, false, true )
        _f( pf, 'ibws_diag_ftr_icon',       'Roboto Light', 31, 100 )

    /*
    *   diag > disconnect
    */

        _f( pf, 'diag_dc_hdr_icon',         'Roboto Light', 24, 100 )
        _f( pf, 'diag_dc_hdr_name',         'Roboto Light', 16, 600 )
        _f( pf, 'diag_dc_hdr_exit',         'Roboto', 40, 800 )
        _f( pf, 'diag_dc_btn_msg',          'Roboto Light', 20, 400 )
        _f( pf, 'diag_dc_btn_desc',         'Roboto Light', 18, 400 )
        _f( pf, 'diag_dc_ftr_icon',         'Roboto Light', 34, 100 )
        _f( pf, 'diag_dc_btn_x',            'Roboto', 38, 800 )
        _f( pf, 'diag_dc_btn_confirm',      'Roboto', 16, 100 )

    /*
    *   rules
    */

        _f( pf, 'rules_exit',               'Roboto', 40, 800 )
        _f( pf, 'rules_size',               'Roboto Light', 24, 100 )
        _f( pf, 'rules_btn_confirm',        'Roboto', 16, 100 )
        _f( pf, 'rules_icon',               'Roboto Light', 34, 100 )
        _f( pf, 'rules_name',               'Roboto Light', 16, 600 )
        _f( pf, 'rules_text',               'Roboto Light', 16, 400 )


    /*
    *   announcements
    */

        _f( pf, 'ann_icon',                 'Roboto', 50, 400 )
        _f( pf, 'ann_name',                 'Advent Pro Light', 34, 400 )
        _f( pf, 'ann_msg',                  'Roboto', 16, 400 )

    /*
    *   footer
    */

        _f( pf, 'footer_pl_name',           'Roboto Condensed', 24, 200 )
        _f( pf, 'footer_pl_group',          'Oort Light', 18, 100 )

    /*
    *   system
    */

        _f( pf, '76561198130610772',            'Roboto', 16, 400 )

    /*
    *   concommand > reload
    */

        if helper.ok.ply( pl ) or base.con:Is( pl ) then
            base:log( 4, '[ %s ] reloaded fonts', mod.name )
            if not base.con.Is( pl ) then
                base.msg:target( pl, mod.name, 'reloaded fonts' )
            end
        end

end
rhook.new.rlib( 'linx_fonts_register', fonts_register )
rcc.new.rlib( 'linx_fonts_reload', fonts_register )

/*
*   fonts > rnet > reload
*/

local function fonts_rnet_reload( data )
    fonts_register( LocalPlayer( ) )
end
rnet.call( 'linx_fonts_reload', fonts_rnet_reload )
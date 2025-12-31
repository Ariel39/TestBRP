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
local helper                = base.h
local access                = base.a
local design                = base.d
local ui                    = base.i
local mats                  = base.m
local cvar                  = base.v

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'linx' )
local cfg               	= base.modules:cfg( mod )

/*
*   Localized translation func
*/

local function ln( ... )
    return base:translate( mod, ... )
end

/*
*	localized mat func
*/

local function mat( id )
    return mats:call( mod, id )
end

/*
*	prefix ids
*/

local function pref( str, suffix )
    local state = not suffix and mod or isstring( suffix ) and suffix or false
    return base.get:pref( str, state )
end

/*
*   panel
*/

local PANEL = { }

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   title
    */

    self.lbl_title                  = ui.new( 'lbl', self                   )
    :top                            ( 'm', 10, 15, 0                        )
    :tall                           ( 30                                    )
    :textadv                        ( cfg.announcements.clrs.header_title, pref( 'ann_name' ), ln( 'sec_announcements' ) )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( helper.get:utf8( 'divonx' ), pref( 'ann_icon' ), 0, 13, cfg.announcements.clrs.header_icon, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self.header, pref( 'ann_name' ), 30, h / 2, cfg.announcements.clrs.header_title, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   announcement entry
    */

    self.dt_entry                   = ui.new( 'entry', self                 )
    :fill                           ( 'm', 10, 15, 10, 15                   )
    :multiline                      ( true                                  )
    :drawbg                         ( false                                 )
    :enabled                        ( true                                  )
    :vsbar                          ( true                                  )
    :textadv                        ( cfg.announcements.clrs.text, pref( 'ann_msg' ), cfg.announcement or 'Nothing to show' )

    /*
    *   interface > create
    *
    *   since we need size values in order to fit ads properly; use a delay timer to ensure the vals are
    *   available
    */

    timex.simple( 1, function( )
        if not IsValid( self ) then return end
        self:Create( )
    end )

end

/*
*   interface
*/

function PANEL:Create( )

    /*
    *   interface > webm or youtube ads
    */

    if ( cfg.ads.webm.enabled and cfg.ads.webm.urls ) or ( cfg.ads.youtube.enabled and cfg.ads.youtube.urls ) then

        local calc_sz_w             = self:GetWide( ) - 16
        local calc_sz_h             = 250 - 16

        self.ads                    = ui.new( 'dhtml', self, 1              )
        :bottom                     ( 'm', 0                                )
        :tall                       ( 250                                   )
        :sbar                       ( false                                 )

                                    if ( cfg.ads.webm.enabled ) then
                                        local autoplay = cfg.ads.webm.autoplay and 'autoplay' or ''
                                        self.ads:SetHTML(
                                        [[
                                            <body style='overflow: hidden; height: 100%; width: 100%;'>
                                                <video controls width=']] .. calc_sz_w .. [[' height=']] .. calc_sz_h .. [[' ]] .. autoplay .. [[ id='linxvidbg'><source src=']] .. table.Random( cfg.ads.webm.urls ) .. [[' type='video/webm'></video>
                                            </body>
                                        ]])
                                        self.ads:RunJavascript( 'var vid = document.getElementById( "linxvidbg" ); vid.volume = ' .. cfg.ads.webm.vol .. ';' )
                                    elseif ( cfg.ads.youtube.enabled ) then
                                        self.ads:SetHTML(
                                        [[
                                            <body style='overflow: hidden; height: ]] .. calc_sz_h .. [[px; width: ]] .. calc_sz_w .. [[px;'>
                                                <iframe frameborder='0' width=']] .. calc_sz_w .. [[' height=']] .. calc_sz_h .. [[' src=']] .. table.Random( cfg.ads.youtube.urls ) .. [['></iframe>
                                            </body>
                                        ]])
                                    end

    end

end

/*
*   Paint
*/

function PANEL:Paint( w, h )
    local clr_primary = cfg.announcements.clrs.primary or Color( 0, 0, 0, 240 )
    if cfg.announcements.blur_enabled then
        design.blur( self, cfg.announcements.blur_amt )
    end
    design.rbox( 5, 0, 0, w, h, clr_primary )
end

/*
*   GetTitle
*/

function PANEL:GetHeader( )
    return self.header
end

/*
*   SetTitle
*/

function PANEL:SetHeader( str )
    self.lbl_title:SetText( '' )
    self.header = str
end

/*
*   GetOpacity
*/

function PANEL:GetOpacity( )
    return self.opacity
end

/*
*   SetOpacity
*
*   @param int int
*/

function PANEL:SetOpacity( int )
    self.opacity = int
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   create
*/

ui:create( mod, 'pnl_ann', PANEL, 'pnl' )
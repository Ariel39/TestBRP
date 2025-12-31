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
*   Localized res func
*/

local function resources( t, ... )
    return base:resource( mod, t, ... )
end

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
*   Init
*/

function PANEL:Init( )

    /*
    *   parent pnl
    */

    self:Dock                       ( FILL                          )
    self:DockPadding                ( 0, 0, 0, 0                    )

    /*
    *   loop server list
    */

    local i = 0
    for v in helper.get.data( cfg.servers.list ) do

        if not v.enabled then continue end

        local sizex                 = helper.str:len( v.hostname:upper( ), pref( 'serv_btn_name' ) )
        local i_pad                 = 50

        local palign                = 50

        local b_server              = ui.new( 'btn', self                   )
        :bsetup                     (                                       )
        :right                      ( 'm', 0                                )
        :notext                     (                                       )
        :sz                         ( sizex + i_pad, 60                     )
        :tip                        ( v.desc or nil                         )
        :anim_click_ol              ( Color( 0, 0, 0, 200 )                 )
        :SetupAnim                  ( 'OnHoverFill', 5, function( s ) return s:IsHovered( ) end )

                                    local mat_id
                                    if ( v.rmat or v.mat ) and ( cfg.servers.type == 1 ) then
                                        mat_id = v.rmat and mat( v.rmat ) or Material( v.mat )
                                        b_server:SetSize( b_server:GetWide( ) + 32, b_server:GetTall( ) )
                                    elseif ( v.rmat or v.mat ) and ( cfg.servers.type == 2 ) then
                                        mat_id = v.rmat and mat( v.rmat ) or Material( v.mat )
                                        b_server:SetSize( 64, b_server:GetTall( ) )
                                    elseif ( v.rmat or v.mat ) and ( cfg.servers.type == 3 ) then
                                        b_server:SetSize( b_server:GetWide( ) + 10, b_server:GetTall( ) )
                                    end

    /*
    *   loop server list > button
    */

        local pnl_serv              = ui.get( b_server )

                                    :draw( function( s, w, h )
                                        s.OnHoverFill   = not s.OnHoverFill and 5 or s.OnHoverFill

                                        local clr_box   = s.hover and cfg.servers.clrs.btnhover or cfg.servers.clrs.btn
                                        local clr_text  = s.hover and cfg.servers.clrs.texthover or cfg.servers.clrs.text
                                        local clr_icon  = s.hover and cfg.servers.clrs.iconhover or cfg.servers.clrs.icon

                                        local prog      = math.Round( h * s.OnHoverFill )
                                        x, y, fw, fh    = 0, h - prog, w, prog

                                        design.box( x, y, fw, fh, clr_box )

                                        if ( cfg.servers.type == 1 and mat_id ) then
                                            design.imat( i_pad / 2 - 5, ( h / 2 ) - ( 32 / 2 ), 32, 32, mat_id, clr_icon )
                                            draw.SimpleText( v.hostname:upper( ), pref( 'serv_btn_name' ), w / 2 + 15 + 5, h / 2, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                        elseif ( cfg.servers.type == 2 and mat_id ) then
                                            design.imat( ( w / 2 ) - ( 32 / 2 ), ( h / 2 ) - ( 32 / 2 ), 32, 32, mat_id, clr_icon )
                                        else
                                            draw.SimpleText( v.hostname:upper( ), pref( 'serv_btn_name' ), w / 2, h / 2, clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                        end

                                        if s.hover then
                                            local clr_anim          = not cfg.servers.anim_enabled and cfg.servers.clrs.uline or Color( 0, 0, 0, 0 )
                                            if cfg.servers.anim_enabled then
                                                local calc_pulse    = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                                calc_pulse          = math.Clamp( calc_pulse, 150, 230 )
                                                clr_anim            = Color( calc_pulse, calc_pulse, calc_pulse, calc_pulse )
                                            end

                                            design.box( 0, h - 3, w, 3, clr_anim )

                                            /*
                                            *	sfx > open
                                            */

                                            if not s.bSndHover and cfg.general.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_01' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        end
                                    end )

                                    :oc( function( s )
                                        if not ui:ok( mod.pnl.swchange ) then
                                            mod.pnl.swchange = ui.rlib( mod, 'diag_cwserv' )
                                        end

                                        local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'swipe_01' ) )
                                        snd:PlayEx      ( 0.1, 100 )

                                        mod.pnl.swchange:SetServerName   ( v.hostname    )
                                        mod.pnl.swchange:SetServerIp     ( v.ip          )
                                        mod.pnl.swchange:ActionShow      (               )
                                    end )

                                    :logic( function( s )

                                        /*
                                        *	sfx > open
                                        */

                                        if s.hover then
                                            if not s.bSndHover and cfg.general.sounds_enabled then
                                                local snd       = CreateSound( LocalPlayer( ), resources( 'snd', 'mouseover_01' ) )
                                                snd:PlayEx      ( 0.1, 100 )
                                                s.bSndHover     = true
                                            end
                                        else
                                            s.bSndHover = false
                                        end

                                    end )

        i = i + 1

    end

end

/*
*   Think
*/

function PANEL:Think( )
    if not cfg.servers.enabled then
        self:Destroy( )
    end
end

/*
*   Paint
*/

function PANEL:Paint( w, h ) end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   create
*/

ui:create( mod, 'pnl_servers', PANEL, 'pnl' )
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
*   Localized cmd func
*/

local function call( t, ... )
    return base:call( t, ... )
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
*   accessorfunc
*/

AccessorFunc( PANEL, 'm_bDraggable', 'Draggable', FORCE_BOOL )

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   parent pnl
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :padding                        ( 2, 34, 2, 3                           )
    :shadow                         ( true                                  )
    :sz                             ( self.w, self.h                        )
    :wmin                           ( self.w * 0.85                         )
    :hmin                           ( self.h * 0.85                         )
    :popup                          (                                       )
    :notitle                        (                                       )
    :canresize                      ( false                                 )
    :showclose                      ( false                                 )
    :scrlock                        ( true                                  )

    /*
    *   display parent
    */

    ui.anim_fadein                  ( self, 0.2, 0                          )

    /*
    *   display parent > static || animated
    */

    if cvar:GetBool( 'rlib_animations_enabled' ) then
        self:SetPos( ( ScrW( ) / 2 ) - ( self.w / 2 ), ScrH( ) + self.h )
        self:MoveTo( ( ScrW( ) / 2 ) - ( self.w / 2 ), ( ScrH( ) / 2 ) - (  self.h / 2 ) - ( self.cf_f.height / 2 ), 0.4, 0, -1 )
    else
        self:SetPos( ( ScrW( ) / 2 ) - ( self.w / 2 ), ( ScrH( ) / 2 ) - (  self.h / 2 ) - ( self.cf_f.height / 2 ) )
    end

    /*
    *   titlebar
    *
    *   to overwrite existing properties from the skin; do not change this
    *   labels name to anything other than lblTitle otherwise it wont
    *   inherit position/size properties
    */

    self.lblTitle                   = ui.new( 'lbl', self                   )
    :notext                         (                                       )
    :font                           ( pref( 'cws_hdr_name' )                )
    :clr                            ( self.cf_d.clrs.header_txt             )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( helper.get:utf8( 'title' ), pref( 'cws_hdr_icon' ), 0, 8, self.cf_d.clrs.header_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self:GetLabel( ), pref( 'cws_hdr_name' ), 25, h / 2, self.cf_d.clrs.header_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   close button
    *
    *   to overwrite existing properties from the skin; do not change this
    *   buttons name to anything other than btnClose otherwise it wont
    *   inherit position/size properties
    */

    self.btnClose                   = ui.new( 'btn', self                   )
    :bsetup                         (                                       )
    :notext                         (                                       )
    :tooltip                        ( ln( 'tooltip_close_window' )          )
    :ocr                            ( self                                  )

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and self.cf_d.clrs.btn_exit_h or self.cf_d.clrs.btn_exit_n
                                        draw.SimpleText( helper.get:utf8( 'close' ), pref( 'cws_hdr_exit' ), w / 2 - 8, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   pnl > sub
    */

    self.p_sub                      = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0, 10, 0                         )

    /*
    *   pnl > error container
    */

    self.p_err_parent               = ui.new( 'pnl', self.p_sub, 1          )
    :top                            ( 'm', 4, 0, 4, 10                      )

    /*
    *   pnl > body
    */

    self.p_body                     = ui.new( 'pnl', self.p_sub, 1          )
    :fill                           ( 'm', 10, 5, 10, 5                     )

    /*
    *   pnl > bottom (footer)
    */

    self.p_btm                      = ui.new( 'pnl', self.p_sub, 1          )
    :bottom                         ( 'm', 10, 0, 10, 5                     )
    :tall                           ( 4                                     )

    /*
    *   pnl > error subcontainer
    */

    self.p_err_sub                  = ui.new( 'pnl', self.p_err_parent      )
    :fill                           ( 'm', 4, 0, 4, 0                       )
    :tall                           ( 20                                    )
    :rbox                           ( self.cf_d.clrs.msg_box, 4             )

    /*
    *   label > error msg
    */

    self.l_err                      = ui.new( 'lbl', self.p_err_sub         )
    :notext                         (                                       )
    :fill                           ( 'm', 3, 3, 0, 3                       )
    :txt                            ( ln( 'please_setup_servers' ), self.cf_d.clrs.msg_txt, pref( 'cws_err' ), false, 5 )

    /*
    *   dtxt > connect desc
    */

    self.dt_desc                    = ui.new( 'dt', self.p_body             )
    :notext                         (                                       )
    :top                            ( 'p', 3                                )
    :tall                           ( 90                                    )
    :drawbg                         ( false                                 )
    :mline                          ( true                                  )
    :lbllock                        (                                       )
    :font                           ( pref( 'cws_desc' )                    )
    :drawentry                      ( self.cf_d.clrs.txt_default, self.cf_d.clrs.cur_default, self.cf_d.clrs.hli_default )

    /*
    *   pnl > btn > sub
    */

    self.p_btn_sub                  = ui.new( 'pnl', self.p_body, 1         )
    :bottom                         ( 'p', 30, 3                            )
    :tall                           ( 32                                    )

                                    :draw( function( s, w, h )
                                        design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.footer_box )
                                        draw.SimpleText( helper.get:utf8( 'dtxt' ), pref( 'cws_info_icon' ), 4, 15, self.cf_d.clrs.ico_bullet, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   pnl > btn > sub > spacer
    */

    self.p_btn_sub_sp               = ui.new( 'pnl', self.p_btn_sub, 1      )
    :right                          ( 'm', 0                                )
    :sz                             ( 100, 18                               )

    /*
    *   dtxt > server ip/port
    */

    self.dt_servnfo                 = ui.new( 'dt', self.p_btn_sub          )
    :fill                           ( 'p', 0                                )
    :drawbg                         ( false                                 )
    :mline                          ( false                                 )
    :lbllock                        (                                       )
    :txt                            ( self.txt_dt_def, self.cf_d.clrs.txt_default, pref( 'cws_info' ) )

                                    :draw( function( s, w, h )
                                        s:SetCursorColor    ( self.cf_d.clrs.cur_default   )
                                        s:SetHighlightColor ( self.cf_d.clrs.hli_default    )

                                        local clr_txt = self.cf_d.clrs.txt_default
                                        if s:GetValue( ) == self.txt_dt_def then
                                            clr_txt = Color( 150, 150, 150, 255 )
                                        end

                                        s:DrawTextEntryText( clr_txt, s:GetHighlightColor( ), s:GetCursorColor( ) )
                                    end )

                                    :focuschg( function( s, bFocus )
                                        local value = string.Trim( s:GetValue( ) )
                                        if bFocus then
                                            if value == self.txt_dt_def then
                                                s:SetText( '' )
                                            end
                                        else
                                            if ( value == '' or not value ) then
                                                s:SetText( self.txt_dt_def )
                                            end
                                        end
                                    end )

    /*
    *   btn > connect deny
    */

    self.b_conn_no                  = ui.new( 'btn', self.p_btn_sub_sp      )
    :bsetup                         (                                       )
    :right                          ( 'm', 0                                )
    :notext                         (                                       )
    :wide                           ( 28                                    )
    :tip                            ( ln( 'tooltip_confirm_no' )            )
    :ocr                            ( self                                  )

                                    :draw( function( s, w, h )
                                        design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.opt_no_btn_n )
                                        if s.hover then
                                            design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.opt_no_btn_h )
                                        end
                                        draw.SimpleText( helper.get:utf8( 'x' ), pref( 'cws_btn_clr' ), w / 2 - 1, 6, self.cf_d.clrs.opt_no_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   btn > copy ip/port to clipboard
    */

    self.b_copy_clip                = ui.new( 'btn', self.p_btn_sub_sp      )
    :bsetup                         (                                       )
    :right                          ( 'm', 0, 0, 5, 0                       )
    :notext                         (                                       )
    :wide                           ( 28                                    )
    :tip                            ( ln( 'tooltip_copy_ipport' )           )

                                    :draw( function( s, w, h )
                                        design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.opt_al_btn_n )
                                        if s.hover then
                                            design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.opt_al_btn_h )
                                        end
                                        draw.SimpleText( helper.get:utf8( 'star_l' ), pref( 'cws_btn_copy' ), w / 2, h / 2 - 1, self.cf_d.clrs.opt_al_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

                                    :oc( function( s )
                                        SetClipboardText( self:GetServerIp( ) )
                                        self.clipb_delay = CurTime( ) + 0.5
                                    end )

    /*
    *   btn > connect confirm
    */

    self.b_conn_yes                 = ui.new( 'btn', self.p_btn_sub_sp      )
    :bsetup                         (                                       )
    :right                          ( 'm', 0, 0, 5, 0                       )
    :notext                         (                                       )
    :wide                           ( 28                                    )
    :tip                            ( ln( 'tooltip_confirm_yes' )           )

                                    :draw( function( s, w, h )
                                        local clr_a     = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
                                        clr_a	        = math.Clamp( clr_a, 100, 255 )

                                        local clr_box   = ColorAlpha( self.cf_d.clrs.opt_ok_btn_n, clr_a )

                                        design.rbox( 6, 0, 0, w, h, clr_box )

                                        if s.hover then
                                            design.rbox( 6, 0, 0, w, h, self.cf_d.clrs.opt_ok_btn_h )
                                        end

                                        draw.SimpleText( helper.get:utf8( 'check' ), pref( 'cws_btn_confirm' ), w / 2, h / 2, self.cf_d.clrs.opt_ok_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

                                        if self.conn_disabled then
                                            s:SetCursor( 'no' )
                                            design.rbox( 6, 0, 0, w, h, Color( 15, 15, 15, 100 ) )
                                        end
                                    end )

                                    :oc( function( s )
                                        if self.conn_disabled then return end
                                        if not self:GetServerIp( ) or self:GetServerIp( ) == '' then return end
                                        LocalPlayer( ):ConCommand( 'connect ' .. self:GetServerIp( ) )
                                    end )

end

/*
*   Think
*/

function PANEL:Think( )
    self.BaseClass.Think( self )

    local ui_w, ui_h = self.w, self.h

    local mousex = math.Clamp( gui.MouseX( ), 1, ScrW( ) - 1 )
    local mousey = math.Clamp( gui.MouseY( ), 1, ScrH( ) - 1 )

    if self.Dragging then
        local x = mousex - self.Dragging[ 1 ]
        local y = mousey - self.Dragging[ 2 ]

        if self:GetScreenLock( ) then
            x = math.Clamp( x, 0, ScrW( ) - self:GetWide( ) )
            y = math.Clamp( y, 0, ScrH( ) - self:GetTall( ) )
        end

        self:SetPos( x, y )
    end

    if self.Sizing then
        local x = mousex - self.Sizing[ 1 ]
        local y = mousey - self.Sizing[ 2 ]
        local px, py = self:GetPos( )

        if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW( ) - px and self:GetScreenLock( ) ) then x = ScrW( ) - px end
        if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH( ) - py and self:GetScreenLock( ) ) then y = ScrH( ) - py end

        self:SetSize( x, y )
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self.m_bSizable and mousex > ( self.x + self:GetWide( ) - 20 ) and mousey > ( self.y + self:GetTall( ) - 20 ) ) then
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self:GetDraggable( ) and mousey < ( self.y + 24 ) ) then
        self:SetCursor( 'sizeall' )
        return
    end

    self:SetCursor( 'arrow' )

    self:MoveToFront( )

    if self.y < 0 then self:SetPos( self.x, 0 ) end

    /*
    *   determines if the error container will display for user.
    *   checks to see if server owner has provided a valid ip/port for each server listed
    */

    if ui:ok( self.p_err_sub ) then
        if not cfg.servers.validation or ( cfg.servers.validation and helper.ok.addr( self:GetServerIp( ) ) ) then
            ui:unstage( self.p_err_parent )
            self:SetTall( ui_h )
            self.conn_disabled = false
        else
            ui:stage( self.p_err_parent )
            self:SetTall( ui_h + 20 )
            self.conn_disabled = true
        end
    end

end

/*
*   OnMousePressed
*/

function PANEL:OnMousePressed( )
    if ( self.m_bSizable and gui.MouseX( ) > ( self.x + self:GetWide( ) - 20 ) and gui.MouseY( ) > ( self.y + self:GetTall( ) - 20 ) ) then
        self.Sizing =
        {
            gui.MouseX( ) - self:GetWide( ),
            gui.MouseY( ) - self:GetTall( )
        }
        self:MouseCapture( true )
        return
    end

    if ( self:GetDraggable( ) and gui.MouseY( ) < ( self.y + 24 ) ) then
        self.Dragging =
        {
            gui.MouseX( ) - self.x,
            gui.MouseY( ) - self.y
        }
        self:MouseCapture( true )
        return
    end
end

/*
*   OnMouseReleased
*/

function PANEL:OnMouseReleased( )
    self.Dragging       = nil
    self.Sizing         = nil
    self:MouseCapture   ( false )
end

/*
*   PerformLayout
*/

function PANEL:PerformLayout( )
    local titlePush = 0
    self.BaseClass.PerformLayout( self )

    self.lblTitle:SetPos( 11 + titlePush, 7 )
    self.lblTitle:SetSize( self:GetWide( ) - 25 - titlePush, 20 )
end

/*
*   Paint
*/

function PANEL:Paint( w, h )
    design.rbox( 4, 0, 0, w, h, self.cf_d.clrs.shadow_box )
    design.rbox( 4, 2, 2, w - 4, h - 4, self.cf_d.clrs.body_box )
    design.rbox_adv( 4, 4, 4, w - 8, 34 - 8, self.cf_d.clrs.header_box, true, true, false, false )

    /*
    *   text animation for copy-to-clipboard btn
    */

    remaining   = math.Round( self.clipb_delay - CurTime( ) ) or 0
    limit       = math.Clamp( remaining, 0, 5 )

    if limit == 1 and #self.clipb_data == 0 then
        timex.simple( 'linx_copy_anim', 0.1, function( )
            if #self.clipb_data == 0 then
                local pos_x, pos_y = self.b_copy_clip:LocalToScreen( )
                local exp = CurTime( ) + ( self._anim_scrtxt or 2 )

                pos_x = pos_x
                pos_y = pos_y - 20

                table.insert( self.clipb_data, { pos = pos_x, x = pos_x, y = pos_y, expires = exp } )
            end
        end )
    end

end

/*
*   ActionShow
*/

function PANEL:ActionShow( )
    self:SetMouseInputEnabled       ( true )
    self:SetKeyboardInputEnabled    ( true )
end

/*
*   GetLabel
*
*   @return : str
*/

function PANEL:GetLabel( )
    return helper.str:ok( self.label ) and self.label or ln( 'connect_to_server', self.server_name )
end

/*
*   SetLabel
*
*   @param  : str str
*/

function PANEL:SetLabel( str )
    self.lblTitle:SetText( '' )
    self.label = str
end

/*
*   GetServerName
*/

function PANEL:GetServerName( )
    return self.server_name
end

/*
*   SetServerName
*
*   @param str str
*/

function PANEL:SetServerName( str )
    self.server_name = str
    self.dt_desc:SetText( ln( 'connect_confirm', str ) )
end

/*
*   GetServerIp
*/

function PANEL:GetServerIp( )
    return self.server_ip
end

/*
*   SetServerIp
*
*   @param str str
*/

function PANEL:SetServerIp( str )
    self.server_ip = str
    self.dt_servnfo:SetText( str )
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   SetVisible
*
*   @param  : bool bVisible
*/

function PANEL:SetVisible( bVisible )
    if bVisible then
        ui:show( self, true )
    else
        ui:hide( self, true )
    end
end

/*
*   _Declare
*/

function PANEL:_Declare( )

    /*
    *   declare > configs
    */

    self.cf_g                       = cfg.general
    self.cf_d                       = cfg.dialogs
    self.cf_f                       = cfg.footer

    /*
    *   declare > sizes
    */

    self.w, self.h                  = 420, 185

    /*
    *   declare >  misc
    */

    self.conn_disabled              = false
    self.clipb_data                 = { }
    self.clipb_delay                = 0
    self.txt_dt_def                 = ln( 'invalid_ipport' )

    /*
    *   animated text scroll for clipboard btn
    *   @return int speed
    */

    self._anim_scrtxt               = design.anim_scrolltext( ln( 'copied_to_clipboard' ), call( 'hooks', 'linx_copy_anim' ), self.clipb_data, pref( 'cws_copyclip' ), Color( 255, 255, 255, 255 ), 0.5, 2 )

end

/*
*   create
*/

ui:create( mod, 'diag_cwserv', PANEL )
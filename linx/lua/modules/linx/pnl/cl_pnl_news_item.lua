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
    *   define
    */

    self.sl_h                      = ui:SmartScaleH( false, cfg.slider.height )

    /*
    *   parent pnl
    */

    self:SetPos                     ( ScrW( ) - cfg.slider.width - 100, self.sl_h )
    self:SetSize                    ( cfg.slider.width, cfg.slider.height_ui )

    /*
    *   localization
    */

    self.state                      = false
    self.title                      = self.title    or ''
    self.desc                       = self.desc     or ''
    self.img                        = self.img      or 'http://cdn.rlib.io/wp/b/blank/1.jpg'
    self.bUseMat                    = self.bUseMat  or false
    self.mat                        = self.mat      or nil
    self.url                        = self.url      or ''
    self.rotateres                  = 1
    self.rotatingdata               = cfg.slider.list

end

/*
*   Render
*/

function PANEL:Render( )

    /*
    *   declarations
    */

    local mat_grad                  = helper._mat[ 'grad_up' ]
    local mat_clr                   = Color( 5, 5, 5, 255 )

    local clr_text_title            = cfg.slider.clrs.text_title or Color( 255, 255, 255, 255 )
    local clr_text_desc             = cfg.slider.clrs.text_desc or Color( 255, 255, 255, 255 )
    local clr_shade_hover           = cfg.slider.clrs.hover_shadow or Color( 15, 15, 15, 100 )

    /*
    *   content pnl
    */

    self.content                    = ui.new( 'pnl', self, 1                )
    :fill                           ( 'm', 0                                )
    :tall                           ( cfg.slider.height_ui                  )

    /*
    *   content pnl
    */

    self.banner                     = ui.new( 'dhtml', self.content, 1      )
    :top                            ( 'm', 0                                )
    :tall                           ( cfg.slider.height_ui                  )
    :sbar                           ( false                                 )

                                    if not self.bUseMat then
                                        self.banner:SetHTML(
                                        [[
                                            <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'>
                                                <img width='100%' height='100%' src=']] .. self:GetImg( ) .. [['>
                                            </body>
                                        ]])
                                    else
                                        self.banner.Paint = function( s, w, h )
                                            design.mat( 0, 0, w, h, self.mat, Color( 255, 255, 255, 255 ) )
                                        end
                                    end

    /*
    *   content inner
    */

    self.sub                        = ui.new( 'pnl', self.banner            )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        local w_sz, h_sz = w, h
                                        draw.TexturedQuad{ texture = surface.GetTextureID( mat_grad ), color = mat_clr, x = 0, y = h_sz * 0.04, w = w_sz, h = h_sz * 1 }

                                        draw.DrawText( self:GetHeader( ), pref( 'sli_header' ), w - 10, h - 55, clr_text_title, TEXT_ALIGN_RIGHT )
                                        draw.DrawText( self:GetHeaderSub( ), pref( 'sli_header_sub' ), w - 10, h - 27, clr_text_desc, TEXT_ALIGN_RIGHT )
                                    end )

    /*
    *   content pnl
    */

    self.p_text                     = ui.new( 'pnl', self.content, 1        )
    :fill                           ( 'm', 0, 10, 0, 0                      )
    :padding                        ( 0, 15, 25, 25                         )

    /*
    *   title
    */

    self.p_title                    = ui.new( 'dt', self.p_text             )
    :top                            ( 'm', 0, 5, 0, 10                      )
    :tall                           ( 35                                    )
    :drawbg                         ( false                                 )
    :mline	                        ( false 				                )
    :ascii	                        ( false 				                )
    :canedit	                    ( false 				                )
    :scur	                        ( Color( 255, 255, 255, 255 ), 'beam'   )
    :txt	                        ( self:GetBodyTitle( ), Color( 209, 155, 67, 255 ), pref( 'sli_body_name' ) )
    :ocnf                           ( true                                  )

    /*
    *   msg
    */

    self.p_msg                      = ui.new( 'dt', self.p_text             )
    :fill                           ( 'm', 0                                )
    :drawbg                         ( false                                 )
    :mline	                        ( true 				                    )
    :ascii	                        ( false 				                )
    :canedit	                    ( false 				                )
    :scur	                        ( Color( 255, 255, 255, 255 ), 'beam'   )
    :txt	                        ( self:GetBodyMsg( ), Color( 255, 255, 255, 255 ), pref( 'sli_body_body' ) )
    :ocnf                           ( true                                  )

    /*
    *   slideview > button
    *
    *   each slide is clickable which takes ply to an external url
    */

    self.b_slideview                = ui.new( 'btn', self.sub               )
    :bsetup                         (                                       )
    :fill                           ( 'm', 0                                )
    :notext                         (                                       )

                                    :draw( function( s, w, h )
                                        if s.hover then
                                            design.rbox( 0, 0, 0, w, h, clr_shade_hover )
                                        end
                                    end )

                                    :oc( function( s )
                                        if not isstring( self.url ) then return end
                                        gui.OpenURL( self.url )
                                    end )

end

/*
*   Think
*/

function PANEL:Think( )
    if self.state then return end
    self:Render( )
    self.state = true
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h ) end

/*
*   SetState
*
*   @param  : bool b
*/

function PANEL:SetState( b )
    self.state = b
end

/*
*   GetState
*
*   @return : bool
*/

function PANEL:GetState( )
    return self.state
end

/*
*   SetTitle
*
*   @param  : str str
*/

function PANEL:SetTitle( str )
    self.title = str or ''
end

/*
*   GetTitle
*
*   @return : str
*/

function PANEL:GetTitle( )
    return self.title or ''
end

/*
*   SetHeader
*
*   @param  : str str
*/

function PANEL:SetHeader( str )
    self.header = str or ''
end

/*
*   GetHeader
*
*   @return : str
*/

function PANEL:GetHeader( )
    return self.header or ''
end

/*
*   SetHeaderSub
*
*   @param  : str str
*/

function PANEL:SetHeaderSub( str )
    self.header_sub = str or ''
end

/*
*   GetHeaderSub
*
*   @return : str
*/

function PANEL:GetHeaderSub( )
    return self.header_sub or ''
end

/*
*   SetBodyTitle
*
*   @param  : str str
*/

function PANEL:SetBodyTitle( str )
    self.body_title = str or ''
end

/*
*   GetBodyTitle
*
*   @return : str
*/

function PANEL:GetBodyTitle( )
    return self.body_title or ''
end

/*
*   SetBodyMsg
*
*   @param  : str str
*/

function PANEL:SetBodyMsg( str )
    self.body_msg = str or ''
end

/*
*   GetBodyMsg
*
*   @return : str
*/

function PANEL:GetBodyMsg( )
    return self.body_msg or ''
end

/*
*   SetDesc
*
*   @param  : str str
*/

function PANEL:SetDesc( str )
    self.desc = str or ''
end

/*
*   GetDesc
*
*   @return : str
*/

function PANEL:GetDesc( )
    return self.desc or ''
end

/*
*   SetMsg
*
*   @param  : str str
*/

function PANEL:SetMsg( str )
    self.msg = str or ''
end

/*
*   GetDesc
*
*   @return : str
*/

function PANEL:GetMsg( )
    return self.msg or ''
end

/*
*   SetImg
*
*   @param  : str str
*/

function PANEL:SetImg( str )
    self.img = str
end

/*
*   GetImg
*
*   @return : str
*/

function PANEL:GetImg( )
    return self.img
end

/*
*   SetMaterial
*
*   @param  : str str
*/

function PANEL:SetMaterial( b, mat_id )
    self.bUseMat    = b or false
    self.mat        = mat_id
end

/*
*   SetURL
*
*   @param  : str str
*/

function PANEL:SetURL( str )
    self.url = str
end

/*
*   GetURL
*
*   @return : str
*/

function PANEL:GetURL( )
    return self.url
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

ui:create( mod, 'pnl_news_item', PANEL, 'pnl' )
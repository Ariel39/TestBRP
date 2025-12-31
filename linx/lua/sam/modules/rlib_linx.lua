/*
*   @package        : rcore
*   @module         : linx
*	@extends		: sam
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

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'linx' )
local cfg               	= base.modules:cfg( mod )

/*
*   check sam
*/

if not sam or SAM_LOADED then return end

local sam                   = sam
local command               = sam.command
local language              = sam.language

/*
*   get access perm
*
*   @param  : str id
*	@return	: tbl
*/

local function perm( id )
    return access:getperm( id, mod )
end

/*
*   declare
*/

local MODULE                = perm( 'index' ).module

/*
*   declare perm ids
*/

local id_ui_open 	        = perm( 'linx_ui_open' )
local id_ui_rehash 	        = perm( 'linx_ui_rehash' )
local id_rnet_reload        = perm( 'linx_rnet_reload' )
local id_fonts_reload       = perm( 'linx_fonts_reload' )

/*
*   check dependency
*
*   @param  : ply pl
*/

local function checkDependency( pl )
    if not base or not base.modules:bInstalled( mod ) then
        base.msg:target( pl, MODULE, 'An error has occured with a required dependency. Contact the developer and we will summon the elves.' )
        return false
    end
    return true
end

/*
*   sam > set category
*/

    command.set_category( MODULE )

/*
*   sam > cmd > linx_ui_open
*/

    command.new( id_ui_open.sam_id )
        :SetPermission      ( id_ui_open.sam_id, id_ui_open.access )
        :AddArg             ( 'player', { single_target = true } )
        :Help               ( id_ui_open.desc )

        /*
        *   OnExecute
        */

        :OnExecute( function( pl, targets )
            if not checkDependency( pl ) then return end

            /*
            *	action
            */

            local target = targets[ 1 ]
            if not helper.ok.ply( target ) then
                base.msg:target( pl, MODULE, 'Bad player selected.' )
                return
            end

            rnet.send.player( target, 'linx_ui_init' )
        end )
    :End( )

/*
*   sam > cmd > linx_ui_rehash
*/

    command.new( id_ui_rehash.sam_id )
        :SetPermission      ( id_ui_rehash.sam_id, id_ui_rehash.access )
        :AddArg             ( 'player', { single_target = true } )
        :Help               ( id_ui_rehash.desc )

        /*
        *   OnExecute
        */

        :OnExecute( function( pl, targets )
            if not checkDependency( pl ) then return end

            /*
            *	action
            */

            local target = targets[ 1 ]
            if not helper.ok.ply( target ) then
                base.msg:target( pl, MODULE, 'Bad player selected.' )
                return
            end

            rnet.send.player( target, 'linx_ui_rehash' )
        end )
    :End( )

/*
*   sam > cmd > linx_rnet_reload
*/

    command.new( id_rnet_reload.sam_id )
        :SetPermission      ( id_rnet_reload.sam_id, id_rnet_reload.access )
        :Help               ( id_rnet_reload.desc )

        /*
        *   OnExecute
        */

        :OnExecute( function( pl )
            if not checkDependency( pl ) then return end

            /*
            *	action
            */

            rhook.run.rlib( 'linx_rnet_register', pl )
        end )
    :End( )

/*
*   sam > cmd > linx_fonts_reload
*/

    command.new( id_fonts_reload.sam_id )
        :SetPermission      ( id_fonts_reload.sam_id, id_fonts_reload.access )
        :Help               ( id_fonts_reload.desc )

        /*
        *   OnExecute
        */

        :OnExecute( function( pl )
            if not checkDependency( pl ) then return end

            /*
            *	action
            */

            rnet.send.player( pl, 'linx_fonts_reload' )
        end )
    :End( )
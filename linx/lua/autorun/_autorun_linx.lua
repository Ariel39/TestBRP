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
*   script tables
*/

linx                = linx or { }
linx.sys            = linx.sys or { }

/*
*   localization
*/

local base          = linx
local prefix        = 'linx'

/*
*   begin autorun
*/

if not SERVER then return end

/*
*   localization > rlib init
*/

local nomsg         = '[ ' .. prefix .. ' ] not initialized » rlib missing! » review documentation / download rlib at \n          » https://rlib.io/\n\n'
local ichk          = 30
local idelay        = 3
local clr           = Color( 255, 255, 0 )
local id_tmr        = prefix .. '.rlib.warning'

/*
*   return rlib check
*/

local exec_rlib_chk = coroutine.create( function( )
    while ( true ) do
        MsgC( clr, nomsg )
        coroutine.yield( )
    end
    timer.Remove( id_tmr )
end )

/*
*   initialize
*
*   checks to see if rlib is available on the server or throws an error back to console for server
*   owner to diagnose issue
*/

function base:rlib_initialize( )
    if rlib then return end
    MsgC( clr, nomsg )
    timer.Simple( idelay, function( )
        coroutine.resume( exec_rlib_chk )
        timer.Create( id_tmr, ichk, 0, function( )
            coroutine.resume( exec_rlib_chk )
        end )
    end )
    hook.Remove( 'Think', prefix .. '.rlib.initialize' )
end
hook.Add( 'Think', prefix .. '.rlib.initialize', base.rlib_initialize )
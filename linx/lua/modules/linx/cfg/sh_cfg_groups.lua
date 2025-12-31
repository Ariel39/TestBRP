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
*   SETTINGS > USER GROUPS
*/

    /*
    *   list of user groups to be recognized by the script.
    *
    *   will display these at the bottom left of the motd under the players
    *   username
    *
    *   because different networks setup group names differently;
    *   please do the following when providing a group:
    *
    *       :   make all letters lowercase
    *       :   replace spaces with underscores
    *
    *   @ex :   SuperAdmin      =>      superadmin
    *           Trial Mod       =>      trial_mod
    */

        cfg.ugroups.titles =
        {
            [ 'superadmin' ]        = 'Owner',
            [ 'super_admin' ]       = 'Owner',
            [ 'admin' ]             = 'Admin',
            [ 'supervisor' ]        = 'Supervisor',
            [ 'operator' ]          = 'Moderator',
            [ 'moderator' ]         = 'Moderator',
            [ 'trialmod' ]          = 'Trial Moderator',
            [ 'tmod' ]              = 'Trial Moderator',
            [ 'donator' ]           = 'Donator',
            [ 'enthralled' ]        = 'Enthralled',
            [ 'respected' ]         = 'Respected',
            [ 'user' ]              = 'User',
            [ 'noaccess' ]          = 'User',
        }

    /*
    *   associated with the ugroup titles above.
    *
    *   this will determine what color the text is that displays
    *   depending on what the players usergroup is
    *
    *   will display these at the bottom left of the motd under the players
    *   username
    *
    *   because different networks setup group names differently;
    *   please do the following when providing a group:
    *
    *       :   make all letters lowercase
    *       :   replace spaces with underscores
    *
    *   @ex :   SuperAdmin      =>      superadmin
    *           Trial Mod       =>      trial_mod
    */

        cfg.ugroups.clrs =
        {
            [ 'superadmin' ]        = Color( 160, 74, 51 ),
            [ 'super_admin' ]       = Color( 160, 74, 51 ),
            [ 'admin' ]             = Color( 195, 210, 48 ),
            [ 'supervisor' ]        = Color( 246, 141, 67 ),
            [ 'operator' ]          = Color( 246, 141, 67 ),
            [ 'moderator' ]         = Color( 246, 94, 116 ),
            [ 'trialmod' ]          = Color( 246, 94, 116 ),
            [ 'tmod' ]              = Color( 246, 94, 116 ),
            [ 'donator' ]           = Color( 26, 127, 245 ),
            [ 'user' ]              = Color( 255, 255, 255 ),
            [ 'noaccess' ]          = Color( 200, 200, 200 ),
        }
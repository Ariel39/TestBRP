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
*   SETTINGS > DEVELOPER
*/

    /*
    *	dev > panel regeneration
    *
    *   : true      this will completely re-create the entire interface each time you close and re-open the ui.
    *	            this forces all panels to be freshly made.
    *
    *               only set true if instructed to do so by the developer or if you know what you're doing
    *
    *   : false     the interface will be created only the first time and then each time called, interface will
    *               show and hide.
    *
    *   @type       : bool
    *   @default    : false
    */

        cfg.dev.regeneration = false

    /*
    *	dev > perm > can ignore enabled
    *
    *   this setting MUST be enabled in order for the permission 'linx_motd_canignore' to work
    *
    *   >   true            : users with permission 'linx_motd_canignore' will not see the MOTD when they join the server
    *                         please note that all players with superadmin access are automatically given this permission
    *
    *   >   false           : no one will ignore the MOTD onjoin
    *
    *   to assign a usergroup to this permission, open your ulx menu in-game and click 'Manage Permissions'
    *   for the group you wish to add. The permission is located under the category 'rlib > MOTD'
    *
    *   @type       : bool
    *   @default    : true
    */

        cfg.dev.perm_canignore_enabled = false

    /*
    *   dev > demo mode cfg
    *
    *   you should not need to modify these for any reason
    */

        cfg.dev.demo =
        {
            sid             = '76561198XXXXXXXXX',
            name            = 'Player Name',
            server          = 'Example Server',
            fps             = 50,
            pop             = 64,
            ip              = '148.52.XX.XXX',
            sid32           = 'STEAM_0:1:010101',
            sv_pop_now      = 36,
            sv_pop_max      = 64
        }
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
*   SETTINGS > RULES
*/

    /*
    *	rules > general
    *
    *   you can either display rules via a website; or use text only for your players. the options below
    *   will determine what happens when a player clicks the rules button on your script.
    *
    *   @note   :   if you have enabled 'cfg.rules.override'; you must provide a text-based version of
    *               your rules in the text config provided in cfg.rules.text
    *
    *               you can still do external website rules; but those will only work when the player
    *               physically clicks the 'Rules' button on the script
    */

        cfg.rules =
        {
            use_text        = true,
            clrs            =
            {
                primary     = Color( 30, 30, 30, 255 ),
                text        = Color( 255, 255, 255, 255 )
            }
        }

    /*
    *	rules > text
    *
    *   the text below will display only if
    *       use_text = true
    *
    *   if the above setting is false, a website will be loaded if the player clicks the rules button
    *
    *   @note   :   if you have enabled 'cfg.rules.override'; you must provide a text-based version of
    *               your rules in the text config provided in cfg.rules.text
    *
    *               you can still do external website rules; but those will only work when the player
    *               physically clicks the 'Rules' button on the script
    */

        cfg.rules.text = [[
⚌⚌⚌ DO NOT DO THE FOLLOWING ⚌⚌⚌
⋆ No ghosting while in spectator mode or when dead
⋆ No racist or sexually abusive comments toward others
⋆ No impersonating staff members
⋆ No being disrespectful to other players or staff
⋆ No threatening to DDoS or take down our network [perm-ban and IP logging]
⋆ No asking for other players personal information (IE: home address, phone number)
⋆ No blocking doors or denying players access to a part of the map.
⋆ No abusing the !unstuck command.
⋆ No prop-killing.
⋆ No hiding in areas as a prop that hunters cannot access or see.
⋆ No mic or chat spamming.

⚌⚌⚌ INFRACTION CONSEQUENCES ⚌⚌⚌
The following actions may be taken in this order [unless violating a more serious offense]:

∘ Player shall be warned about the rule they have broken.
∘ Will be kicked from the server if they continue to break a rule.
∘ A ban will be issued for a term of 3-5 days (depending on what occured)
∘ A permanent ban will be issued and shall not be removed
        ]]
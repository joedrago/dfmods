# 3.10.10 (30-NOV-2022)
 - fixed - when on the dragon isles your land mount will be used by default, to use a dragonriding mount press the shift button and the summon mount keybinding
 - changed - the arkinventory icons on the default bag/bank/vault frames will now re-enable arkinventory if you have disabled it
 - added - config > general > actions > mail > enable.  defaults to false
 - added - config > general > actions > mail > manual.  defaults to true
 - added - config > general > actions > vendor > enable.  defaults to false
 - added - config > general > actions > vendor > manual.  defaults to true.
 - added - profession tool items are now scanned, and show up in item counts
 - fixed - toybox filters are now restored correctly after scanning
 - changed - (dragonflight) scan tooltip functionality replaced with the new tooltip information functions
 - fixed - (dragonflight) ItemRefTooltip should no longer disappear when the item counts refresh
 - fixed - (classic/wrath) C_TooltipInfo issue
 - changed - QUEST events should no longer trigger a forced refresh and will instead only set the bag window to refresh at the next update.
 - fixed - right clicking on a no value junk item should now delete it when at a vendor/merchant
 - added - config > profiles > controls > location > pre-load.  pre loads item data and builds the window in the background for a faster first open.  bag and bank enabled by default.
 
# known issues
 - (dragonflight) reagentbank slots are no longer readable unless the bank is open
 - recipes on vendors are showing item counts for the items they create, not the recipe
 - (dragonflight) currency tokens on the backback no longer have a fixed amount and will keep going until you run out of space, they can get messy
 - Enum.ItemConsumableSubclass is missing the Flask entry and everything after has moved down a value which screws up the category names (have hardcoded a workaround for the moment)
 - items with an active cooldown dont allow comparison tooltips to generate
 - cooldowns no longer start automatically.  you can close/open the bag to get them to show (if you enable that option).  all of the cooldown events ACTIONBAR_UPDATE_COOLDOWN, BAG_UPDATE_COOLDOWN, PET_BAR_UPDATE_COOLDOWN, SPELL_UPDATE_COOLDOWN, appear to trigger off other players as well, but do not provide any indication whether the event was triggered by you or them, so cooldowns will trigger window refreshes fairly constantly when you are around large numbers of players.  even limiting it to one update per second generated too much lag, especially in massive groups.
 - chat link for a battlepet in the guild bank will not send
 - the first time you click on a hyplink in chat it wont show the item counts
 
# to do
 - double check all categories show/hide for the right clients
 - confirm things havent broken in classic, wrath, or shadowlands
 - restack disable - maybe change this to require a modifier key instead of a straight disable?  might be easier to shift/alt/ctrl click on it than turning it on/off and its not like youll accidentally do it (which is why the disable was added)
 - backpack tokens to scroll when max width reached on second line
 - extend the categoryset actions to individual items for additional granular control.
 - add action; move (bank to bag, bag to bank, bag to vault, vault to bag)
 - add actions to items
 - allow multiple actions on a category / item
 
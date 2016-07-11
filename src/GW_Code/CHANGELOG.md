# [Get Wrecked](http://getwrecked.info) Changelog
## Last Updated: [12-07-2016] ##

Note: Some changes that are deemed spoilers are hidden from this log. 
(WIP) Indicates items that may not be fully functional and are only partially implemented.
Items without Fixed/Added/Removed proceeding are typically balance changes.

**v0.8.6** [Public alpha release — A3 1.62]

- Added hud marker for dead players in current race
- Added Prowler to unlockable vehicles
- Changes to loading process to ensure welcome message doesn't appear while on loading screen
- Race checkpoints now give 10% ammo on even points and 10% fuel on odd points
- Updated and simplified supply box script to allow them to function on bridges/steeper terrain
- Added Hunter Seeker Missile to supply crates (will be added to races at a later point)
- Added service points to Port, Quarry
- Lowered laser chance of burn, but increased raw damage output
- Service points now use notification icon instead of screen alert
- Invalid position icons for race editor
- Removed squadRadar
- Removed duplicate mouseHandler function
- Reverted boundary spawn to server side only
- Refactored HUD and playerLoop to run from same loop
- Reduced setPos frequency on lift vehicle
- Overall fire damage reduced
- Slightly lowered GMG rate of fire
- Removed zone boundaries from workshop
- New 'hidden' icon to targetCursor while using cloak
- Reduction in number of simulated objects in zones using makeSimpleObject
- Melee weapons now do more damage, break more easily and no longer collide with buildings
- Improved race editor usability (tooltips and changes to the way checkpoints are added to make it a bit more logical)
- Race checkpoint trigger area is now 15m (10m previously)
- Damage in race zones decreased slightly (it's now roughly 2x damage in a battle zone)
- Last loaded vehicle is no longer loaded on player respawn to prevent terminals overflowing
- Loading in a new vehicle will now clear other vehicles you own in the workshop
- Reduced sound volume on GMG, HMG, Rocket Pods
- Better handling of bad race data or ID when deploying to a race zone
- Removed an unnecessary loop from the chat commands system
- Improved angle of ramps at Terminal

- Fixed Clear bind button not correctly clearing entries that are waiting for a key press
- Fixed Race not correctly ending after at least one player has finished
- Fixed "_newFuel" undefined variable error
- Fixed Several outdated .wss file locations 
- Fixed isEqualType [] error related to lack of available vHud bar space
- Fixed Race checkpoints couldn't be placed on bridges
- Fixed Deploy point on plantation above flame pad (lol)
- Fixed setVehicleTexture no longer called for blank paints
- Fixed Closing settings menu too quickly causes corrupted keybinds
- Fixed Melee weapons colliding with invisible objects on bridges
- Fixed Potential HUD break related to getOut EH on vehicles
- Fixed Objects placed below vehicle when lifted caused vehicle to explode
- Fixed Param error when using Rocket Pods on opponents
- Fixed Battleye kick when using too many lasers
- Fixed Mines sitting above ground when deployed
- Fixed Race progress bar stopping for remaining players after first player completes it
- Fixed Player unable to return to workshop if all vehicle terminals are full
- Fixed Crash when deploying to a zone with a chat channel open
- Fixed Races not ending as intended when players killed outside their vehicles or DC
- Fixed Out of bounds deploy point on Plantation
- Fixed Workshop occasionally showed as an option when deploying to a battle
- Fixed HUD progress bar was overlapping player locations in race
- Fixed Renaming a race twice caused race library to break
- Fixed No sound when shooting some weapons
- Fixed Some actions (save, deploy) were running on multiple clients

**v0.8.2 - v0.8.5** [Closed alpha release]

- Added Race editor and race mode
- Added FlamePads to map
- Added 'Loading' text to vehicle preview
- Added 'Crash Test Dummy' texture for dev builds
- Added 'Napalm Bomb' as droppable module
- Race lobby menu and 'ready' threshold for race starting
- Caltrops now more reliable and destroyed after first collision
- Increased global damage scale by x2 (0.04 > 0.08)
- Decreased ammo requirements of some weapons
- Decreased breakage frequency for melee weapons
- EM Fencing now only mitigates the speed reduction of an EMP, rather than removing effect entirely
- Alert UI moved further upwards to reduce screen clutter
- Halo effect now follows ground when vehicle is airborne
- New system that uses server to determine empty setpos locations
- Reduced particle effect drop frequency on verticalThruster to improve FPS
- New method to dynamically spawn zone boundaries (client and local) on deploy to boost server FPS
- Typename comparisons updated to new isEqualType command (faster)
- Changed player proximity action refresh to a new lazy-update method
- New vehicle save name method to avoid profileNameSpace conflicts
- Renaming a vehicle now correctly deletes old named entry (no more cloning!)
- Global keybinds (settings, rotate keys) can now be set in the vehicle settings menu
- Changing keybinds no longer requires vehicle to be saved at the workshop
- Sponsorship money now triggered by server side events check
- Redesigned default vehicle 'Fresh Meat' to make it a bit more noob friendly
- Unit/Vehicle stance info is now hidden from HUD
- New command !boundary which toggles visible zone boundaries on/off (may improve Client FPS)
- Removed a number of buildings in Downtown Kavala to improve FPS in that zone
- Caching on entries in drawIcons to eliminate unnecessary repeat position finding per frame
- Damage now differs between Battle / Race zones
- Magnetic Coil now 50% less power/range in race zones
- Group global keybind added (open settings menu to configure)
- Mines can now be dropped while airborne
- Warning icons for mines and caltrops, now only added for first item in the group
- Snapping now aligns to axis of matching objects (rotation align currently disabled)
- Progress saved on DEV versions of Get Wrecked is now isolated from live version
- Emergency repair device now only repairs 50% damage
- Updated targetCursor to better calculate shooting while on steep terrain

- Fixed Issue with stats retrieval occuring too early on previewVehicle
- Fixed Bug preventing local vehicle setup from properly occuring
- Fixed Suspended vehicles no longer drop altitude when attaching/detaching objects
- Fixed Death camera sometimes triggering multiple times consecutively
- Fixed Settings menu keybind should now work for vehicles nearby the player
- Fixed HUD not fading in correctly if deploying in first person
- Fixed Incorrect offset on muzzle effect
- Fixed Unsaved vehicle prompt should now correctly show only for edited or non-loaded vehicles
- Fixed Hitting ESC/Enter should now correctly confirm or cancel dialog message boxes
- Fixed You can no longer disassemble static weapons
- Fixed Player going unconscious when hitting supply boxes or vehicles
- Fixed Vehicle spawn protection status being applied twice on deploy
- Fixed 'Beach' zone on Stratis with bad boundary detection
- Fixed occasional missing items on vehicle load
- Fixed 'Slytech' missing texture bug
- Fixed some vehicle items tending not to load under low server fps
- Fixed Items shifting position when saved multiple times 
- Fixed Purchasing multiple items should now correctly use nearby supply boxes owned by player
- Fixed Filter list on deploy menu should now correctly update when arrows are used
- Fixed Race menu should now correctly only show races valid on the current map

**v0.8.2c** [Public alpha release — 1.48 Compatibility]

- Combined cleanup scripts into events loop to improve server fps
- Guided missile, lock-on, railgun, mines and explosive damage now affected by target armor
- Notifications and alerts should now fade a bit more smoothly
- Updated several commands to avoid conflicts in 1.48
- Fixed - PreviewLocation defaulting to the sea
- Fixed - Owner not being set on vehicle creation to lock terminal correctly
- Fixed - Vehicle lock halo not showing
- Removed - Tailored vehicle textures in favor of file size reduction
- Removed - Respawn scoreboard flashing on death screen
- Added - Auto height snapping of similar types to object manipulation
- Added - Custom sound effects to attach/detach actions

**v0.8.2** [Public alpha release]

- Melee weapons now take a small amount of damage when used until they break (damage no longer less per item)
- Weapon damage and vehicle armor pass to help re-balance engagement times and viability
- Supply boxes should no longer take over the workshop
- Objects now hold their rotate while attaching them 
- effectIsVisible dedicated check to minimize unnecessary visual effects being spawned on clients
- Teleport mechanic adjusted to make it more practical to use
- Shockwave velocity limitation
- Increased audability of most weapon/module effects 
- Re-write to object manipulation system to avoid collisions in workshop
- loadVehicle system is now client side to improve reliability (WIP)
- Improved status effect handler system to improve fps
- Improved guided missile handling slightly
- Improved RPG accuracy and speed
- Debris effect to bag of explosives
- Flamethrower damage reduced slightly, but does additional damage with sustained hits
- Slightly increased HMG stock damage
- Refract effect to flame effects
- Pulse effect to railgun
- Bags of explosives now do scaled damage depending on distance
- Vehicle health tag now only shows when player is looking directly at it
- Fixed - Items detachable on vehicles player does not own
- Temp Fix - Ownership lost when cancelling deploy timer
- Fixed - Death camera focus mode
- Fixed - Taunt not triggering on first key press
- Fixed - 'You have no vehicle to deploy' message not showing for spawn menu check
- Fixed - Vehicle signatures not being correctly considered in lock time
- Fixed - Guided missile dealing no damage
- Fixed - Vehicles spawning simultaneously now are both deleted to avoid collisions
- Fixed - Laser firing from center of object
- Fixed - Memory crash involving object handle damage event handler
- Fixed - Crash on attaching HMGs/GMGs 
- Fixed - setVehicleTexture not exiting correctly on server
- Fixed - Vehicle stats should now be recorded properly
- Fixed - Infinite flight with the emergency parachute
- Fixed - Textures not loading occasionally for some vehicles
- Fixed - Script error causing guided missile screen to occasionally get stuck
- Fixed - Vendor item script error (1.44)
- Fixed - Custom font missing error on input dialog
- Fixed - Vehicle load UI list should now correctly match current preview
- Changed - 'Salt flat' is now 'Dry Lake'
- Added - Random vehicle name generator
- Added - Check to move player forwards if they get stuck when aborting deploy
- Added - !copy command for Admins to retrieve vehicles from remote clients
- Added - Weapon FOV preview when attaching items in the workshop
- Added - Rocket Pods, Grappling Hook, Teleportation Device, Electromagnet (WIP)
- Added - EMP Resistant Fencing, Military-Grade Concrete, Chainlink Panel, Thick Concrete Wall
- Added - Concrete Pylon, Hydraulic Hook (WIP)
- Added - Box Truck, Fuel and Ammo and Tempest Trucks to available vehicles 
- Added - Suspend option to lift vehicle mechanic


**v0.8.1** [Closed alpha release]

- Widespread fps improvements and optimizations
- Loading screen timeout to prevent endless black screen
- Using thruster while parachuting will now automatically cut it
- EMP duration changed to 10 seconds, 7 for source vehicle, 60 second timeout
- Mine damage reduced to 20-30%
- HMG damage increased by 25%
- Incorrect selection for GW_KILL_VALUE causing low kill values
- Removed unnecessary vehicle teleport in save/load system
- Own vehicle health bar now wider and at bottom of screen
- Tweaks to the ballistics system to better work on hills
- Fixed - Melee spikes now only pick up cars (and not whole radar stations!)
- Fixed - Weapon tagging unable to overwrite, even if different weapon
- Fixed - Corrupted or reset libraries using !reset should now auto-fill with defaults when loading preview menu
- Fixed - Save 'cancel' button not aborting properly
- Fixed - Aggressive cleanup now has a 75m nearby man check in workshop, 10m in zone
- Fixed - Buggy emergency parachute on kart
- Fixed - Occasional filterParam script error
- Fixed - Lock-on beeps causing unnecessary network traffic
- Fixed - Black icons in dialogs as of 1.40
- Fixed - Smoke generator script error
- Fixed - Self Destruct now has a delay and can't blow up invulnerable vehicles
- Added - Additional beep sound effects to alerts
- Added - First person camera is now enabled for building and combat
- Added - Customizable mission parameters (Starting cash, bounty rewards, game mode, respawn time etc)
- Added - Stringtable (English/French) (WIP)
- Added - Max data packet size variable to prevent server instability when loading large vehicles
- Added - Stratis map support with three new battle zones - Airbase, Peninsula and Beach (WIP)
- Added - Melee metal spikes (WIP), that do around 7.5% damage on hit and can grab vehicles
- Added - !grab to bring players to admin and !cleanup to manually execute the cleanup script
- Added - Auto detect for Karts DLC to remove racing helmets, (!fixdlc is no longer required)
- Added - !collision command for testing attached object collisions (WIP)

**v0.8.0c** [Public alpha hotfix 2]

- Fixed - Nuke not dealing any damage
- Fixed - Magnetic coil script error
- Fixed - Changed settings menu mouse bind back to double click to toggle
- Fixed - Emergency parachutes can be deployed multiple times while active

**v0.8.0b** [Public alpha hotfix]

- Fixed - Attached weapons should now be properly immune to damage
- Fixed - Flamethrower consuming ammo in addition to fuel
- Fixed - Invulnerability not working vs bag of explosives
- Fixed - Attached static weapons disappearing after second save
- Fixed - Hud failing to update after dropping explosives
- Fixed - Explosives dropping all in one stack rather than individually
- Added - Shockwave effects to some explosive weapons

**v0.8.0** [Public alpha release]

- Optimized vehicle service terminal initialization script
- Tweaked lock-on missiles slightly to improve accuracy
- All items attached to a vehicle are now destroyed when the vehicle is blown up
- Adjusted size of all battle zones slightly to account for more player slots
- Bandwidth optimization to load vehicle system to improve responsiveness
- Slowed HMG rate of fire, increased stock damage per round
- Shield generator now correctly swaps textures for vehicles without a custom texture
- Lowered chance of tyre pop on mortar impact and mortar rof reduced
- Eject system is now an emergency parachute (WIP) 
- Optimized HUD loop to improve client fps
- Vehicles with engines off now have lower radar signatures
- Overcharge no longer affects weapons, only module cooldowns
- Reduced overall number of items in workshop to improve fps
- Tweaked eventHandler for karts to prevent wheels getting stuck
- Lowered mass modifiers further to allow for more items on kart/quadbike/suv
- Self destruct and Magnetic Coil no longer tags nearby players as killed by it
- Reduced mine damage to 30%
- Tweaked terminals to now use checkNearbyActions
- Additional checks on save/deploy/clear to determine ownership and prevent griefing
- AttachToRelative function thanks to KillzoneKid
- Tweaks to vehicle name tag function and simulation manager to improve client fps
- Reworked damage system to extend engagement times and reliance on service points
- Magnetic Coil now has less power but a faster cooldown
- Single mouse press (instead of double) to toggle mouse fire on weapons in settings menu
- Getting hit or taking damage now prevents service point being triggered for 5 seconds
- EMP timeout increased to 40 seconds and effect duration on source vehicle increased to 4 seconds
- Fixed - Damage object causing action menu to bug out
- Fixed - Lock ons causing excessive network traffic
- Fixed - Key binds resetting on load vehicle 
- Fixed - Guided missile always exploding at 1000m 
- Fixed - Lock-on using front of vehicle instead of camera direction
- Fixed - Mouse fire mode not defaulting to 'active' on newly attached weapons
- Fixed - Laser not firing due to script error 
- Fixed - Bug causing player invulnerability to toggle on/off in the wrong areas
- Fixed - Railgun should now correctly use indirect/direct fire mode after delay
- Fixed - Lock on missile failing to launch to target and no minimum lock range
- Fixed - Vehicle status monitor setHit spam causing desync/lag
- Fixed - parseZones not correctly finding all markers
- Fixed - Karts and vehicles shifting sideways with stuck wheels on deploy
- Fixed - Bag of explosives should no longer bump source vehicle when detaching
- Fixed - Meta data bug with default vehicles for new players
- Fixed - Railgun, mortar blocking mouse fire for all weapons 
- Fixed - New players unable to get past 'loading screen'
- Fixed - Older saved cars not using updated vehicle binds order on fresh load 
- Fixed - Jittery vehicles (due to excess weight)
- Fixed - Flamethrower should no longer set light to source vehicle when firing ahead
- Fixed - Teleport Supply crate putting vehicles below ground
- Fixed - Cleanup should no longer remove attached objects on vehicles 
- Fixed - Weapon marking system not re-marking for same player with different weapon
- Fixed - Weapons/modules activating while message dialog open
- Temp Fix - Multiple vehicles loading on top of each other when multiple people spawn at same pad
- Removed - Parachute vehicle drop as it causes desync and does not work properly
- Removed - Long concrete wall, for balance purposes 
- Removed - Jammer supply crate in place of radar powerup
- Added - Custom sounds to vehicle service points
- Added - cleanup to remove excess actions from unnecessary items while in battle
- Added - Nuke death camera focus mode
- Added - 3D halo status effect for vehicle power ups (WIP)
- Added - Supply drop crates with custom power ups/money/ammo etc
- Added - New events system to handle random, condition based script execution
- Added - New text notifications to show deploying players, weapon used to kill
- Added - Charge up noise on railgun
- Added - More taunts: batman, sparta, herewego, hax, headshot and horn icon for settings menu 
- Added - Beep sound effect to 'lock detected'
- Added - Lights to temporary vehicle spawn areas so you can see them in preview at night
- Added - More vehicle terminals and support for 12 players
- Added - Support for destroyable attached building objects on vehicles (WIP)
- Added - Key binds for modules now shown on vehicle hud
- Added - !reset to allow for character profile resets
- Added - Reintroduced simulation manager to increase overall fps 
- Added - Unflip vehicle option to vehicle scroll menu (when in zone)
- Added - Status new health bars to vehicle tags
- Added - Vehicle armor ratings to prolong time-to-kill
- Added - New custom cleanup script for abandoned and destroyed vehicles



**v0.7.8 - v0.7.9**, [Closed alpha release]

- Lift Vehicle and settings options now attached to player proximity to owned vehicle
- Vertical Thrusters should no longer be linked, along with most other modules
- 'Key Restricted' warning when trying to use a restricted key for a bind
- Tweaks to hud timeout bars to better show time remaining for multiple modules of the same type 
- You can no longer detach or move objects while in a race zone
- If you get kicked out of a vehicle due to low health the vehicle will now explode
- Flamethrower should now have better hit detection
- Incendiary ammo now has a lower fire duration when tagging vehicles
- Mortar now has a chance of disabling tyres on vehicles nearby the impact
- You can no longer use nitro while wheels are destroyed or vehicle is disabled
- Overall damage and GMG damage lowered slightly
- To prevent afk money farming, you now only earn money if you have moved a distance within the two minute timer
- Tweaked Bag of Explosives damage to make it less powerful
- Fixed - You can no longer save a vehicle you don't own, but you can save an unowned one
- Fixed - Last loaded vehicle is now set via vehicle save (previously only on vehicle load)
- Fixed - Buy menu being generated twice on menu load
- Fixed - Script errors when buying items across different categories
- Fixed - Total cost should now update when just selecting one item in buy menu 
- Fixed - Bug allowing supply boxes to be attached to vehicles 
- Fixed - Easy money from tagging own vehicle with mortar
- Fixed - Emergency Repair Device failing to repair caltropped wheels
- Removed - Repair/reload/refuel area map triggers in favour of a new system 
- Removed - Muzzle effect showing for non-local clients due to excess lag with hmg/gmg/laser fire
- Added - Special vehicle binds (taunt/unflip/toggle lock/detonate explosives) to settings menu
- Added - New nitro pads to some zones (WIP)
- Added - Hold rotate bind for using the camera to rotate objects and lifted vehicles
- Added - !fixdlc can now be used to toggle removing non-dlc headgear on spawn for people without the Karts DLc
- Added - Tyre burst sound effect to caltrops
- Added - Indirect fire mode for weapons (eg shooting backwards)
- Added - Mouse fire toggle button for individual weapons 
- Added - !sendmoney <player name> can now be used to transfer money to other players
- Added - New pink and camouflage paint
- Added - New vehicle taunts: surprise, horn, toot and buzzer


**v0.7.7**, [Public alpha release]

- Swapped Kart DLC driver units for pilots so people without the dlc don't get harrased
- Streamlined vehicle loading so it's running from just one script
- New Higher resolution Vehicle Service Terminal image to prevent it disappearing at different resolutions
- Kart &amp; Quadbike now have slightly lower mass modifiers them to handle heavier parts
- Increased kick-back and reload time for Railgun
- Increased railgun reload time to 20 seconds
- Railgun now only does 50% damage to intersecting vehicles
- Magnetic Coil will no longer activate if the source vehicle is dead or emp'd
- Effective range of Magnetic Coil reduced slightly and reload time increased
- Mortar round now has less variance and a faster speed when locked
- Newly parachuted vehicles no longer show tags
- New checks on save to automatically compile and re-enable simulation on vehicle 
- Lowered overall weapon damage slightly
- Moved spawn location at airfield that was above runway edgelights
- Text added to vehicle service terminal icons
- Laser sound effect should be a bit more noticeable
- Temporary fix for hud failing to update on deploy due to lag (needs testing)
- Deploy menu should now work a bit more reliably
- Improved spawn protection - you are now invulnerable, fire proof and lock proof for 5 seconds after chute detaches
- Reduced quality of all vehicle textures to bring down overall file size (feedback needed here)
- Settings key in a vehicle now bindable to User Action 20
- Last vehicle should now be automatically loaded at a nearby pad when you spawn back at the workshop
- Added filter button to buy menu 
- Added new hud marker for junk piles
- Added Flamethrower (WIP)
- Added cleanup scripts for abandoned and dead objects
- Added simulation toggle system for vehicles not in current zone
- Fixed - Default vehicles now should have a value when killed
- Fixed - Vehicles saved for the first time (with prompt) now properly get their new name
- Fixed - burnIntersects and railgun no longer tag own player
- Fixed - handleKill spamming the server with 'logKill' requests when a vehicle is blown up
- Fixed - Vehicles disappearing in workshop area (stay within 10m of it and nothing should happen)
- Fixed - Key binds for some weapons not working despite being bound correctly (Railgun/Rocket Launcher primarily)


**v0.7.6**, [Make Arma Not War Release]

- Fix for kill message displaying multiple times
- Cloaking device now properly hiding vehicle tag
- Self destruct no longer tags own vehicle allowing easy money
- No money earned for killing newly deployed vehicles
- Some light tweaks to the targetting to improve aiming (still a WIP)
- Mortar should now lock correctly and fire when locked
- Welcome note for new players 
- Added truck to starter vehicles in library
- $500 starting cash so weapons are more accessible
- Tweaked minimum lock range to 175m
- Corrected a bug with destroyed vehicles not being cleared from lockon array
- Having low ammo should no longer prevent you using some items
- Prevent tagging self with proxmity mines, explosives etc
- Magnetic coil now correctly tags victims

















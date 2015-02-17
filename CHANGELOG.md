# [Get Wrecked](http://getwrecked.info) Changelog
## Last Updated: [17-02-2015] ##

Note: Some changes that are deemed spoilers are hidden from this log 

**v0.8** [Public alpha release]

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

















if (!hasInterface) exitWith {};

waitUntil {!isNull player};

player createDiarySubject ["changelog", "Changelog"];
player createDiarySubject ["bindings", "Bindings"];
player createDiarySubject ["issues", "Issues"];


player createDiaryRecord ["issues",
[
"Common issues and fixes:",
"
- Simulated objects bumping vehicles <br /> 
Drop the object on the floor, wait a second then pick it back up <br />
<br />
- Wierd ballistics (projectiles hitting floor/not where you aim) <br />
Check its position on the vehicle, if LOS is obscured the projectile probably wont hit exactly where you aim<br />
<br />
- The vehicle's parachute on deploy breaks immediately and you fall and die<br />
Caused by objects getting in the way of the attach point of the parachute, try to keep the top of your vehicle clear if you are having problems<br />
<br />
- HUD does not show X weapon or X module<br />
Occasionally this does get stuck. If you hop out and back in the vehicle it should fix it.<br />
<br />
- The vehicle repair/rearm/refuel point doesn't work<br />
Try driving away and then coming back. Be sure not to stop on the point and not drive through.<br />
<br />
"
]];


player createDiaryRecord ["bindings",
[
"Available bindings:",
"
<br />
[ Editing ]<br />
<br />
Grab / Drop - User Action 1<br />
Attach / Detach - User Action 2<br />
Rotate CW - User Action 3<br />
Rotate CCW - User Action 4<br />
Tilt Forward - [ Disabled ]<br />
Tilt Backward - [ Disabled ]<br />
<br />
[ Common ]<br />
<br />
Windows Key - Open Vehicle Settings<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.2.3 - v0.2.8",
"
<br/>
- Ammo boxes now increase ammo capacity on vehicle<br/>
- Move actions should only show for current item<br/>
- Fix for smoke effect in multiplayer<br/>
- Changes to mass/weight of items to improve vehicle speed<br/>
- Weapons can now be attached firing a specific direction<br/>
- Repair/Rearm/Refuel points now dotted around the airstrip<br/>
- All points now require you stay within 15m<br/>
- Critical status on hud now triggers at 50% damage<br/>
- ATV's can now have items attached<br />
- 30% drop rate for items on destroyed vehicles<br />
- HUD should now only open for valid vehicles
"
]];

player createDiaryRecord ["changelog",
[
"v0.2.9",
"
<br/>
- [Added] Eject System Module <br/>
- Listed available keybinds on vehicle entry <br />
- Attempting to correct sync effects in MP for nitro/eject <br/>
- Synced firing of multiple mounted weapons <br />
- Limited cursor info target to 10m <br />
- Oil slick effect now sets fire and damages vehicles<br />
- Key bind for oil slick<br />
- Error fix for objects being destroyed that aren't attached
"
]];


player createDiaryRecord ["changelog",
[
"v0.3",
"
<br/>
- [Added] EMP Device<br/>
- HUD effects for EMP Status <br />
- EMP Device now ignores origin vehicle<br />
- Electrical Effects for EMP'd vehicles<br />
- Ability to set vehicle camo using !setcamo<br />
- Additional loot spawn areas
<br/>
"
]];

player createDiaryRecord ["changelog",
[
"v0.3.2 - v0.3.3",
"
<br/>
- setObjectTextureGlobal sync<br />
- Key binds for lift object<br />
- hideObjectGlobal only server side<br />
- MP sync now using BIS_fnc_MP instead of publicVar<br />
- serverReady var resetting to default for JIP<br />
- Refuel point now allows drive-through<br />
- Increased Reload point ammo rate<br />
- Vehicle points now run faster and have smaller trigger areas<br />
- Increased RPG reload time to 4s

<br/>
"
]];


player createDiaryRecord ["changelog",
[
"v0.3.4 - v0.3.5",
"
<br/>
- Vehicle/attached item ownership <br /> 
- Reverted to publicVar sync for setDir and switchMove<br />
- Eject system now working correctly with lowered altitude<br />
- Self destruct mass decreased to 400 and no reload time<br />
- EMP now gradually slows vehicle down<br />
- Nitro boost values tweaked slightly<br />
- Getting in back seat no longer sets ownership to null<br />
- MP Smoke effect for emergency repair<br />
- Eject now auto-triggers for damaged vehicles<br />
- [Fixed] HUD no longer shows for passenger seats
<br/>
"
]];


player createDiaryRecord ["changelog",
[
"v0.3.6",
"
<br/>
- Prototype vehicle saving/loading<br /> 
- Object attachment to dynamically loaded vehicles<br />
- Increased vehicle tag view distance to 150m<br />
- Updating setDir on loaded vehicles to sync in MP<br />
- [Fixed] rounding errors on HUD status<br />
- Ownership checks for object handling<br />
- !list, !save, !load commands for vehicle saving<br />
- !library clear to reset saved vehicles list<br />
- New jpg camos - black, neon, pink, green, blue, red, yellow<br />
- Attach script rewrite to obtain ownership state
"
]];


player createDiaryRecord ["changelog",
[
"v0.3.7",
"
<br/>
- Save area now has HUD marker<br /> 
- Vehicle names now visible when not in a vehicle<br /> 
- Vehicles with owners (even if no name) will show tags<br />
- [Added] out of bounds limit to map<br />
- Vehicles now respawn once abandoned or destroyed<br />
- Objects in loot piles respawn once destroyed<br />
- HUD Effect for out of bounds<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.3.8",
"
<br/>
- Increased amount of loot per pile to min 30 max 50<br />
- [Fixed] Pesky bug causing repair/rearm area markers to vanish<br />
- Chance of salvaging parts from destroyed vehicles increased to 50%<br />
- !save and !load commands can now be used anywhere<br />
- [Added] !load default to spawn an SUV at save points<br />
- Static weapons now have 9999 health to prevent them breaking<br />
- [Fixed] Issue with first-attach of module causing a permission error<br />
- [Added] !list delete <name> to remove individual vehicles<br />
- [Fixed] Out of bounds preventing EMP<br />
- EMP now also affects source vehicle (shorter duration)
"
]];


player createDiaryRecord ["changelog",
[
"v0.3.9",
"
<br/>
- Client will now add move actions to valid objects on the fly<br />
- You can now share vehicles using !list share <name><br />
- Add shared vehicles by using !list add <name><br />
- Attached objects now have red tag text<br />
- [Fixed] Abandoned vehicles dissappearing even if player nearby<br />
- [Fixed] Vehicle points not always triggering correctly
"
]];

player createDiaryRecord ["changelog",
[
"v0.4 - v0.4.2",
"
<br/>
- Vehicle/icon markers should no longer jitter or lag<br />
- Changes to object editing to massively improve performance<br />
- Objects can no longer be placed underground<br />
- Self Destruct system will now always toggle eject system (if present)<br />
- Lift amount tweaked as the action can now be done faster<br />
- [New] High Energy Laser weapon<br />
- You can now flip vehicles using !stuck.<br />
- [Fixed] Respawned vehicles not getting attributes<br />
- Smoke bomb now puts out fires on burning vehicles<br />
- Going faster has a chance of putting out fires
- Increased save/load distance to 15m<br />
- Reduced drop rate on smoke bomb to increase fps<br />
- Spawned loot now has rarity<br />
- Loot spawn number increased slightly<br />
- Respawning loot now has a 50% chance of swapping to something else
"
]];

player createDiaryRecord ["changelog",
[
"v0.4.3",
"
<br/>
- Warning alerts now have a beep<br />
- Oil slick now sets fire to vehicles properly in any shape<br />
- Caltrops now temporarily pop tyres on affected vehicles<br />
- [Fixed] Ammo status on hud incorrect colour<br />
- [New] Iron Curtain device creates temporary invulnerability<br />
- Rocket Launcher now does less damage to vehicles<br />
- Only getting into drivers seat now triggers ownership test<br />
- Tweaked damage values to balance mounted guns
"
]];

player createDiaryRecord ["changelog",
[
"v0.4.4",
"
<br />
- Vehicle actions and module data should now sync properly<br />
- Improved vehicle !load speed by reducing MP call bandwidth<br />
- [New] Death camera follows killer<br />
- [Added] death cam colour corrections<br />
- Ownership check for attaching objects to vehicles<br />
- Reduced rocket damage further to lower trollness<br />
- Increased HMG damage to make them more viable <br />
- Laser now correctly sets fire to all vehicles caught in beam<br />
- All weapons now vary in accuracy by type<br />
- Weapon accuracy also affected by velocity<br />
- Converted server BIS_fnc_MP calls to publicVarServer to improve stability
- [Fixed] Vehicle respawn fireworks<br />
- Attach weapon direction working properly (and now has more target points)
<br/>

"
]];


player createDiaryRecord ["changelog",
[
"v0.4.5",
"
<br />
- Removed 'c' key for emergency repair as it's too easy to spam<br />
- [Added] customizable key binds (full list in briefing tab)<br />
- Caltrops duration increased to 30-45 seconds and linger for upto 3 mins.<br />
- Massively improved attached/detach data process to optimize for MP which should stop ghost weapons appearing on the vehicle<br />
- Changed load.sqf to handle 'null-objects' being sometimes attached to the vehicle on save
<br/>

"
]];


player createDiaryRecord ["changelog",
[
"v0.4.6 - v0.4.7",
"
<br />
- Updated system to handle weapon/module timeouts more efficiently<br />
- Smoke bomb duration increased to 8 seconds<br />
- [Fixed] new player's !list not working correctly<br />
- Performance tweaks to improve load vehicle reliability<br />
- Null object detection on save/load should reduce errors<br />
- You can now use just !load or !load last to load the last loaded vehicle<br />
- Changed vehicle event handlers to improve network performance<br />
- [Added] a few admin-only commands to help test sessions<br />
- [Fixed] bug preventing destroyed vehicles allowing objects to be detached<br />
- [Added] Ctrl+S as a way to save vehicles<br />
- Emergency Eject system now has a 10% failure rate<br />
- HMG, GMG and Nitro Boost now less spammable to reduce network lag<br />
- Reduced playSound3D radius to lower lag<br />
- Removed particle effect on Nitro<br />
- You can no longer activate abilities from a passenger seat<br />
- !Load and !Save should now be able to handle multiple requests<br />
- [Added] an additional save/respawn area to the east<br />
- Optimized player action menu loop<br />
- Better status handling for vehicles (fire, emp etc)<br />
- [Fixed] shield generator preventing attachment use
- [Added] whitelist for mp testing
- Timeout for load/save requests to avoid getting stuck
"
]];

player createDiaryRecord ["changelog",
[
"v0.4.8",
"
<br />
- [Fixed] Caltrops bugging out <br />
- [Fixed] a bug allowing multiple compiles on the same vehicle (causing ghost weapons to appear) <br />
- Shield generator no longer protects against fire <br />
- New preview menu (for loading vehicles) now working <br />
- [Added] next/prev and list filter function to preview menu <br />
- [Added] ability to retrieve last loaded vehicle first in preview <br />
- Empty areas are now 'claimed' by players before load to prevent errors <br />
- Optimized clear pad script <br />
- New explosive/incendiary ammo types for HMG <br />
- Explosive ammo type now replaces standard HMG ammo (was firing twice) <br />
- Removed part of the hud in prep for UI overhaul <br />
- [Added] Ctrl+O as a way to open vehicle preview menu<br />
- [Fixed] Vehicle points not always triggering due to key bind bug <br />
- [Added] User Action 20 is an emergency brake <br />
- New icon set added<br />
- Animated vehicle point activity icons<br />
- Kick player out of vehicle if its busy compiling<br />
- Invulnerability should now work regardless of weapon<br />
- Damage event handlers now triggering properly<br />
- Wired fence now prevents slowing effect of EMP device<br />
- Preview menu should no longer crash with bad vehicle<br />
- Karts are IN!
"
]];

player createDiaryRecord ["changelog",
[
"v0.4.9",
"
<br />
- Fire damage lowered by 50%<br />
- Improved getin/getout handlers for ownership permission checks<br />
- Vehicle markers now show owner (even when vacant)<br />
- Laser now only does burn damage, no projectile damage<br />
- Vehicles being set up now locked (to prevent eager beavers)<br />
- Dropped items now have simulation enabled<br />
- [Added] an additional save/respawn area to the north end of the island<br />
- Last loaded vehicle should now persist through sessions<br />
- !Stuck can no longer be abused<br />
- Save areas cannot be cleared for 10 seconds following a vehicle spawn<br />
- Reload time is now multiplied by the number of weapons of that type (RPG / GMG / MOR only)<br />
- [Added] !clear to chat commands for clearing save pads<br />
- [Added] some more weapon types using weaponholders <br />
- Attach option on objects only visible if valid vehicle nearby<br />
- Hand brake and emp slow effect no longer work if airborne<br />
- EMP Device is now a suitcase<br />
- [Added] Vertical Thruster<br />
- Improved the way ballistics are handled on weapons to improve ranged accuracy<br />
- Removed EMP and Oil Slick key binds, in place of Railgun/Missile binds<br />
- Tactical Laser bind is now on User Action 13<br />
- Tweaked thruster to have less power on heavier vehicles<br />
- [Added] Guided Missile<br />
- Some tweaks to compile script to align guns with their respective markers<br />
- Ammo should now correctly deduct for each weapon of type fired<br />
- Caltrops now have a warning icon above them for the person who deployed them<br />
- [Added] Proximity Mines :)
- Death Camera now has position locked relative to killer<br />
- Vehicle mass modifiers should allow lighter vehicles to add more parts now<br />
- Beep effect on triggered mines
"
]];


player createDiaryRecord ["changelog",
[
"v0.5 - v0.5.1",
"
<br />
- [Added] Bag of Explosives <br />
- Updated clear, save, load, eject and mine icons <br />
- [Added] Lock-on missile launcher and ability to lock-on to valid vehicles <br />
- Smoke now disrupts locking and forces a miss on already locked vehicles <br />
- Mortar can now also use locked targets <br />
- Handle Damage values updated to include HE ammo and Guided/Lock On Missiles<br />
- Tweaked vehicle pads to make them slightly more responsive<br />
- You can now enable disable lock on from the vehicle action menu<br />
- Bags of Explosives now trigger each other and can be dropped en mass
- Explosives now detonate after 15s or can be triggered from the action menu<br />
- Map icons for vehicle points<br />
- Fixed server spawned weapon holders dissapearing when moved<b />
- Pressing windows key now shows current key binds<br />
- Smoke generator now should properly prevent stacked and future fires<br />
- Reduced setVariable load on vehicles to lower bandwidth usage
- Vehicle tags are now only red if someone is in it<br />
- A MaxDeployables limit now prevents mine/caltrop/explosive spam
- Mine and caltrop timeout reduced to 2 mins<br />
- Vehicles that cant move (and have no debuffs) will auto-correct<br />
- Fixed a cheeky bug allowing multiple emergency repairs<BR />
- RPG now does 2.5x more damage<br />
- Fixed bag of explosives action menu and detonate button<br />
- Guided missile now has correctly verted flight controls<br />
- Karts should now not get stuck in the ground after heavy landings<br />
- Lock-on missiles should now hit karts and quadbikes more reliably<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.5.2",
"
- Prototype new aim-with-cursor HUD and left-mouse click to fire<br />
- Locking now follows camera angle and marker should no longer stick to the ground<br />
- Removed target markers in favour of new turret mode to shoot (allows better overall control of weapons)<br />
- Mines will now only trigger on targets that go fast over them!<br />
- Improved death camera to provide an overview shot with player suicide or killer detach<br />
- Killed vehicle handlers now report who the vehicle was destroyed by
- Changed to a ballistics based method of killedBy identification to improve overall accuracy<br/>
- Improved position recording of save function for vehicles far away from origin<br />
- [Added] Cloaking Device (WIP)<br />
- Firing from or turning on engine while cloaked causes it to deactivate<br />
- Shooting at or driving near a cloaked vehicle will also cause it to de-cloak<br />
- Vehicle compile now stores previous fuel/ammo<br />
- Fixed some errors with the HUD causing scalar numbers<br />
- Mortar now has a delay proportionate to the range<br />
- Nitro boost now scales according to the mass of vehicle<br />
- Explosions should now also trigger de-cloak
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.5.3",
"
- Move objects now more fluid (follows camera)<br />
- Tweaked object rotation mechanic so it can be more accurate when using keys<BR />
- Removed lift/raise obj actions as no longer needed<br />
- [Added] Plywood Barrier<br />
- [Added] Magnetic coil<br />
- EMP now disables nearby cloaked vehicles<br />
- Fixed LOS check for attached turreted weapons<br />
- Prototype build snapping <br />
- Mirrored snap points<br />
- Fixed a bug causing turrets to not correctly follow camera target<br />
- Turrets now have a LOS check that should prevent them shooting through source vehicle<br />
- Ammo and fuel levels are now saved and restored when the vehicle is loaded<br />
- Some tweaks to the way load/save is handled to improve performance<BR />
- Prototype script to prevent objects being placed inside a vehicle<br />
- Oil slick now working again<br />
- Fixed a bug with player kill logging on server <br />
- Lowered fire, he hmg and laser damage slightly
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.5.4 - v0.6",
"
- Cloak now consumes three times more ammo, is more noticeable and triggers de-cloak within 15m of other vehicles <br />
- Magnetic coil range reduced to 100m, but minimum power increased <br />
- Added Spectators (WIP)<br />
- Added test dummy to the selection of drivers (Custom texture)<br />
- Reduced server log message spam for killed vehicles <br />
- Vehicle tags should now correctly match vehicle height while airborne<br />
- Player and vehicle tags now fade with range<br />
- Temporary confirm dialog for delete button<br />
- Vehicle status debuffs should now be a bit snappier<br />
- Moved GW to Altis<br />
- New loops for server spawned objects (faster and easier)
- Added in zone check <br />
- Zone boundaries now marked by lines on map <br />
- Zone boundaries now also marked by transparent texture in 3D<br />
- New alert message and kill-timer for out-of-bounds<br />
- Changes to the way things are compiled to allow for more scalability<br />
- New workshop zone<br />
- Death camera now matches current zone<br />
- Added safe zone (no firing/limited movement) to workshop<br />
- Spawn menu at workshop<br />
- Parachute drop effect for vehicle spawning (WIP)<br />
- Driving in water while on fire will extinguish it<br />
- Turning the engine on during deploy will cut the parachute<br />
- Added saltflat as a new zone<br />
- Deployment now randomized and has a nearby vehicle check
<br />
"
]];

player createDiaryRecord ["changelog",
[
"v0.6.1",
"
- Fixed bug causing max-range issue on guided missile <br />
- Improved the preview camera menu so that it will consistently show a loaded vehicle<br />
- Tweaked the save system to correctly wait for vehicle to be moved to temp area <br />
- Fixed a bug preventing clearPad from clearing last loaded vehicle<br />
- Unnamed vehicles now properly get saved as 'Untitled'<br />
- Guided missile now correctly fires in the direction its attached<br />
- Show binds key now displays object name<br />
- Lock on should now immediately cease when disabled<br />
- Added Railgun (WIP) <br />
- New tagging UI for objects (show available stats)<br />
- Objects now have health and can be destroyed<br />
- Muzzle effects for hmg, gmg, railgun<br />
- Disabled turret movement termporarily due to it causing other components to bug out
- You can now lift vehicles in the workshop area via action menu<br />
- Improved snapping (now snaps to vehicle direction)<br />
- New vehicle tags show stats < 5m <br />
- Vehicle tags should now only be visible within reasonable LOS<br />
- Vehicles created in the workshop area now always have max fuel and ammo<br />
- Vehicle tags should now correctly adjust to height above terrain
<br />
"
]];

player createDiaryRecord ["changelog",
[
"v0.6.2",
"
- Fixed bug causing max-range issue on guided missile <br />
- Improved the preview camera menu so that it will consistently show a loaded vehicle<br />
- Tweaked the save system to correctly wait for vehicle to be moved to temp area <br />
- Fixed a bug preventing clearPad from clearing last loaded vehicle<br />
- Unnamed vehicles now properly get saved as 'Untitled'<br />
- Guided missile now correctly fires in the direction its attached<br />
- Show binds key now displays object name<br />
- Lock on should now immediately cease when disabled<br />
- Added Railgun (WIP) <br />
- New tagging UI for objects (show available stats)<br />
- Objects now have health and can be destroyed<br />
- Muzzle effects for hmg, gmg, railgun<br />
- Disabled turret movement termporarily due to it causing other components to bug out
- You can now lift vehicles in the workshop area via action menu<br />
- Improved snapping (now snaps to vehicle direction)<br />
- New vehicle tags show stats < 5m <br />
- Vehicle tags should now only be visible within reasonable LOS<br />
- Vehicles created in the workshop area now always have max fuel and ammo<br />
- Vehicle tags should now correctly adjust to height above terrain<br />
- Vehicle tags now fade away slowly when LOS obscured<br />
- Tweaked deploy script to fix errors in MP<br />
- Attempt to fix spectator camera bugging out<br />
- Proximity mines should now properly detonate<br />
- Oil slick can now be toggled on/off and drains fuel
<br />
"
]];

player createDiaryRecord ["changelog",
[
"v0.6.3",
"
- Massive improvement to ballistics of HMG <br />
- Fixed a bug causing incendiary ammo to not always fire but reduced chance of fire on hit to 75%
- HE Ammo now does a bit more damage, but AP Hmg should still do more direct damage per shot<br />
- Incendiary ammo now has reduced AP damage (HE / Incendiary are meant as side-grades not upgrades)
- Vehicle targetting now has a minimum range of 25m<br />
- Vehicle lock-on improved, minimum 50m, max 2000m<br />
- Lock on missile now follows target and is much more accurate<br />
- Increased tag visibility to 500m (los permitting)<br />
- Increased Railgun charge time to 1.5 - 4 seconds<br />
- FIXED! No more loss of positioning with attached objects when re-saving (static weapons still have small issues with height)<br />
- New customization/settings dialog for vehicles 
- New key-binding system that's specific to each vehicle<br />
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.6.4",
"
- New icons for weapons in settings dialog<br />
- Improved status handler system to cope with larger numbers of requests<br />
- Timeout waiting for key bind now resorts to the previous bind<br />
- Ownership check for vehicle terminals to prevent abuse<br />
- Fixed tag visibility for vehicles with lots of attachments<br />
- Settings dialog can now be accessed inside the vehicle using the windows key<br />
- 3D target markers for current selected key-binding objects<br />
- Stats tracking now working for mileage, time alive<br />
- New paint buckets for setting vehicle textures<br />
- Striped texture for some UI elements<br />
- Improved the hud tagging system to scale better with nearby vehicles<br />
- Preview UI now contains vehicle stats<br />
- Small fix to compile attached system to prevent action menu flickering<br />
- New timer dialog for deploy screen
<br />
"
]];



player createDiaryRecord ["changelog",
[
"v0.6.5",
"
- UI changes to preview, spawn, timer and death camera <br />
- Timer in death camera + early respawn button<br />
- Nitro booster now scales max speed and acceleration with number equipped<br />
- Close settings dialog on unflip<br />
- Prevent key presses/target showing during GW_DEPLOY<br />
- Paint bucket texture sizes<br />
- Tweaked Oil Slick to make it less performance heavy (and more accurate)<br />
- Bounce effect when object attached to vehicle<br />
- (WIP) new HUD UI and alerts system<BR />
- Hitting clear button while waiting for bind, should now cancel wait timer<br />
- New alert UI<br />
- Fix to stats logging to prevent corrupted values <br />
- New vehicle HUD (WIP)
<br />
"
]];

player createDiaryRecord ["changelog",
[
"v0.6.6",
"
- JIP and Texture issues should now be resolved<br />
- Slight change to the way objects are grabbed to prevent instant damage problems<br />
- Fixed an issue with object tagging causing items with ammo or fuel to stop working<br />
- Lock-on is now 10 second reload, 20% ammo <br />
- Railgun changed to 12sec reload, 35% ammo <br />
- Lock-on direction tolerance reduced to 40 degrees <br />
- Ignore num lock input on key bind<br />
- Fixed 'locked' status not being added to target <br />
- Minimum lock range now 300m, max lock range 2500m, minimum 3 second lock time<br />
- Event handlers on vehicles should now be removed properly on death<br />
- You should no longer be able to remotely damage a player by shooting their old vehicle<br />
- Increased number of deploy locations at each zone slightly and decreased check range<br />
- Updated vehicle respawn script to properly cleanup abandoned/dead created vehicles<br />
- Disabled collision between deploy parachutes and vehicle<br />
- You can now tilt objects in all dimensions (WIP)<br />
- Fixed a bug causing some spawn areas in the workshop to not work
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.6.7",
"
- You can now spawn in vehicles using the create menu<br />
- Added custom attributes to vehicles (Modules/Weapons Limit, Radar signature, armor rating etc) to improve balance<br />
- New signage in workshop, we now have sponsors! <Br />
- You can now cancel the save as dialog and it wont save<br />
- Corrected spawn locations to point the player towards the vehicle terminals<br />
- Added deploy last vehicle as an option for ejected players <br />
- Radar signature now increases lock acquire time<br />
- Certain vehicles are now locked at start and require money to unlock permanently<br />
- Dropping smoke while locked will cause locked targets to unlock
- When deploying from a parachute, the vehicle now has 10 second invulnerability, nolock and nofire<br />
- Settings dialog no longer limited to inside vehicle when in zone<br />
- Updated icons for cloak, magnetic coil, vertical thruster<br />
- Attempt to fix object properties not being attached<br />
- Added number of players count to spawn screen list <br />
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.6.8",
"
- Out of zone timeout increased to 15 seconds<br />
- New textures for all character slots, respective of new companies<br />
- Updates (new icons) to new/create vehicle UI<br />
- Radar signature now affects tag visibility range<br />
- Vehicles now have maxModule and maxWeapon limits and different ammo/fuel capacities at default<br />
- Balance now updated on vehicle purchase <br />
- New notifications on HUD that update with status<br />
- Correct currency with commas now showing <br />
- Paint vehicle active now hides settings/lift option on vehicle while active <br />
- Buy item menu (WIP) <br />
- Cost calculation and deduction from overall balance<br />
- Updated particles to only render within range of GW_EFFECTS_RANGE to improve FPS<br />
- New supply boxes<br />
- Boxes automatically requested from purchase orders <br />
- Nearby boxes to purchase point get auto-filled with new items
<br />
"
]];

player createDiaryRecord ["changelog",
[
"v0.6.9",
"
- Tweaks to the buy menu UI (Sponsor Logo + Discounts) <br />
- Generated supply boxes at buy points should now not used untouched empty ones <br />
- Specifying 0 as quantity will now reset item to - in buy menu <br />
- Correctly implemented discounts to item costing across all companies<br />
- Paradrop now performed via server to reduce desync <br />
- Inventory for supply boxes<br />
- Bag of Explosives reloadTime error<br />
- Killing vehicles now earns 30% of their value<br />
- Fixed transaction amount showing while in zone<br />
- Balance added to vehicle HUD<br />
- Buying just one item now just spawns it (rather than a supply box)<br />
- Changed starting vehicle selection to just quadbike/hatchback<br />
- Fixed action menu loop not running <br />
- Fixed setVehicleTexture not applying on load_vehicle <br />
- Opted for parachuteVehicle to run locally to ensure reliability <br />
- Locality check for box filling from buy menu <br />
- Fixed free items sporadically appearing from supply crates (lol) <br />
- New items animation for supply box<br />
- Correct colour helmets for drivers <br />
- Is saved check to Spawn menu to prompt on unsaved vehicles<br />
- You can now select individual items for purchase from the buy menu<br />
- Numerical keys (0-9) can also be used to select quantities for items
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.7 - v0.7.4",
"
- New icon set for buy menu<br />
- Fix to buy menu quantity set<br />
- Mortar should now correctly shoot where you aim<br />
- New low fuel icon on HUD<br />
- Explosive barrels to fuel stations<br />
- New tilt icons, tilt exclusion list for weapons and some dodgy items <br />
- Added limits to tilt object function to prevent general wierdness<br />
- Weapon timeouts now show in HUD<br />
- Laser now shoots the way you'd expect<br />
- Changes to grab object function to function a bit more smoothly in MP<br />
- Muzzle effect to new items in a supply box<br />
- Client\Server\Global Compile tidy-up<BR />
- Added 'Snapping Active' announcement to grabbed items (only when active)<br />
- Increased collision damage to 0.1<br />
- Set fade on HUD elements to prevent flickering<br />
- Updated library to use GW_LIBRARY string to prevent conflicts<br />
- Removed 1/2 second delay causing smoke to not always prevent lock-ons<br />
- New 'locking' status should now warn the vehicle being locked on to<br />
- Improved caltrops method of detecting nearby vehicles<br />
- Force compile vehicle on spawn menu to reduce errors on deploy<br />
- Caltrops and mines now consume ammo <br />
- Massively improved the display handler to prevent excess flickering<br />
- Bag of explosives should now only show once in key binds and can be all dropped with one bind<br />
- New load screen image<br />
- Buy menu now shows discounts via colour changes (orange > 10%, white > 0%, faded = normal)
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.7.5",
"
- Kill tracker should now work correctly<br />
- Fixed people not dying in blown up vehicles<br />
- Fixed engine getting damaged and making the car unusable<br />
- Disabled all object damage as it was detrimental to good gameplay <br />
- Weapon locking now disabled for new spawns <br />
- Decreased lock on tolerance to 20 degrees to further limit its use <br />
- If a vehicle is empty when its destroyed it now only gives 10% of its value, makes eject systems useful!<br />
- Tweaked the range on the self destruct system so its a bit more practical<br />
- Fixed being able to attach more modules than your vehicle is capable of<br />
- Improved the performance of addVehicleStatus and removeVehicleStatus<br />
- Z and Y should now be bound to the correct keys<br />
- New caltrops, buyArea, saveArea, boxAdd icons<br />
- Buy menu colour highlighting depending on current discounts
<br />
"
]];


player createDiaryRecord ["changelog",
[
"v0.7.6",
"
- Fix for kill message displaying multiple times<br />
- Cloaking device now properly hiding vehicle tag<br />
- Self destruct no longer tags own vehicle allowing easy money<br />
- No money earned for killing newly deployed vehicles<br />
- Some light tweaks to the targetting to improve aiming (still a WIP)<br />
- Mortar should now lock correctly and fire when locked<br />
- Welcome note for new players <br />
- Added truck to starter vehicles in library<br />
- $500 starting cash so weapons are more accessible<BR />
- Tweaked minimum lock range to 175m<br />
- Corrected a bug with destroyed vehicles not being cleared from lockon array<br />
- Having low ammo should no longer prevent you using some items<br />
- Prevent tagging self with proxmity mines, explosives etc<br />
- Magnetic coil now correctly tags victims
<br />
"
]];







































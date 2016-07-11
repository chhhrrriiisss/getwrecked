if (!hasInterface) exitWith {};

waitUntil {!isNull player};

player createDiarySubject ["changelog", "Changelog"];
player createDiarySubject ["bindings", "Bindings"];
player createDiarySubject ["issues", "Issues"];


player createDiaryRecord ["issues",
[
"Common issues and fixes:",
"
- An item I attached isn't rotated how I want it<br />
If your vehicle is suspended in the air, this will only update when you drop the vehicle back on the ground<br />
<br />
- Vehicle won't save<br />
Make sure your vehicle is placed on the ground and there are no other vehicles nearby<br />
<br />
- I can't fire a weapon/module or the target is in the wrong place<br />
Ensure you have enough ammo/fuel and that it is keybound correctly. Sometimes hopping out of the vehicle then back in can help<br />
<br />
- My vehicle went flying across the map all of a sudden?<br />
If this happens when you are in a battle zone - then it is not a bug, it's the magnetic coil or some other velocity effect. Make your vehicle heavier by attaching more parts.<br />
<br />
- HUD does not show X weapon or X module<br />
Occasionally this does get stuck. If you hop out and back in the vehicle it should fix it.<br />
<br />
- Weapons and objects not facing the correct direction when you load a vehicle<br />
Try clear the pad and re-load the vehicle, most of the time the save is intact.<br />
<br />
- Vehicle repair/rearm/refuel pads not working<br />
They can be temperamental and slow, but they do work - just give it a second, or drive off then back on the pad. Getting shot at prevents repair pad use for a few seconds.<br />
<br />
<br />
"
]];


player createDiaryRecord ["bindings",
[
"Available bindings:",
"
All global bindings are now configurable in the settings menu of any vehicle.
"
]];

player createDiaryRecord ["changelog",
[
"Changelog:",
"
**v0.8.2 - v0.8.5** [Public alpha release]<br />
<br /><br />
- Added FlamePads to map <br />
- Added 'Loading' text to vehicle preview <br />
- Added 'Crash Test Dummy' texture for dev builds <br />
- Caltrops now more reliable and destroyed after first collision<br />
- Increased global damage scale by x2 (0.04 > 0.08)<br />
- Decreased ammo requirements of some weapons<br />
- Decreased breakage frequency for melee weapons<br />
- Alert UI moved further upwards to reduce screen clutter<br />
- Halo effect now follows ground when vehicle is airborne<br />
- New system that uses server to determine empty setpos locations<br />
- Reduced particle effect drop frequency on verticalThruster to improve FPS<br />
- New method to dynamically spawn zone boundaries (client and local) on deploy to boost server FPS<br />
- Typename comparisons updated to new isEqualType command (faster)<br />
- Changed player proximity action refresh to a new lazy-update method<br />
- New vehicle save name method to avoid profileNameSpace conflicts<br />
- Renaming a vehicle now correctly deletes old named entry (no more cloning!)<br />
- Global keybinds (settings, rotate keys) can now be set in the vehicle settings menu<br />
- Changing keybinds no longer requires vehicle to be saved at the workshop<br />
- Sponsorship money now triggered by server side events check<br />
- Redesigned default vehicle 'Fresh Meat' to make it a bit more noob friendly<br />
- Unit/Vehicle stance info is now hidden from HUD<br />
- New command !boundary which toggles visible zone boundaries on/off (may improve Client FPS)<br />
- Removed a number of buildings in Downtown Kavala to improve FPS in that zone<br />
- Caching on entries in drawIcons to eliminate unnecessary repeat position finding per frame<br />
- Damage now differs between Battle / Race zones<br />
- Magnetic Coil now 50% less power/range in race zones<br />
- Group management added - Use Insert (default) to access group management (friendly fire is still enabled)<br />
- Group global keybind added (open settings menu configure)<br />
- Mines can now be dropped while airborne<br />
- Warning icons for mines and caltrops, now only added for first item in the group<br />
- Snapping now aligns to axis of matching objects (rotation align currently disabled)<br />
<br /><br />
- Fixed Suspended vehicles no longer drop altitude when attaching/detaching objects<br />
- Fixed Death camera sometimes triggering multiple times consecutively<br />
- Fixed Settings menu keybind should now work for vehicles nearby the player<br />
- Fixed HUD not fading in correctly if deploying in first person<br />
- Fixed Incorrect offset on muzzle effect<br />
- Fixed Unsaved vehicle prompt should now correctly show only for edited or non-loaded vehicles<br />
- Fixed Hitting ESC/Enter should now correctly confirm or cancel dialog message boxes<br />
- Fixed You can no longer disassemble static weapons<br />
- Fixed Player going unconscious when hitting supply boxes or vehicles<br />
- Fixed Vehicle spawn protection status being applied twice on deploy<br />
- Fixed 'Beach' zone on Stratis with bad boundary detection<br />
- Fixed occasional missing items on vehicle load<br />
- Fixed 'Slytech' missing texture bug<br />
- Fixed some vehicle items tending not to load under low server fps<br />
- Fixed Items shifting position when saved multiple times <br />
- Fixed Purchasing multiple items should now correctly use nearby supply boxes owned by player<br />
<br /><br />
* Known issues *<br />
- Occasional param errors due to changes in 1.54 turn off -showscripterrors to remove these<br />
- Race Mode is WIP, largely incomplete and only working in a demonstrative capacity<br />
- Attaching items to suspended vehicles often doesn't show the correct rotation until the vehicle is moved<br />
- Vehicles that are suspended have their direction always set to 0<br />
- Low FPS while using snapping tools<br />
- Key Binds dont save correctly if you close the settings menu too quickly after setting a bind<br />

"
]];

























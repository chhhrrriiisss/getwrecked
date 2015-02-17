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
- Keybinds don't save<br />
Keybinds are only saved when you save the vehicle in the workshop - editing them in zone will not persist<br />
<br />
- I can't fire a weapon/module<br />
Ensure you have enough ammo/fuel and that it is keybound correctly. Sometimes hopping out of the vehicle then back in can help<br />
<br />
- My vehicle went flying across the map all of a sudden?<br />
If this happens when you are in a battle zone - then it is not a bug, it's the magnetic coil - make your vehicle heavier or use an emergency parachute<br />
<br />
- Simulated objects bumping vehicles <br /> 
Drop the object on the floor, wait a second then pick it back up <br />
<br />
- HUD does not show X weapon or X module<br />
Occasionally this does get stuck. If you hop out and back in the vehicle it should fix it.<br />
<br />
- Weapons and objects not facing the correct direction when you load a vehicle<br />
This is caused by lag and the object (especially if its a railgun/rpg) should eventually update, it just takes a while<br />
<br />
- Vehicle repair/rearm/refuel pads not working<br />
They can be temperamental and slow, but they do work - just give it a second, or drive off then back on the pad.<br />
<br />
- I'm getting shot at by an invisible vehicle<br />
This is a rare issue that relates to the way simulation is toggled on and off between zones. The invisible vehicle should respawn to the workshop to fix this.<br />
<br />
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
Hold Rotate - User Action 5<br />

<br />
[ Common ]<br />
<br />
Open Vehicle Settings - User Action 20<br />
"
]];

player createDiaryRecord ["changelog",
[
"Changelog:",
"
Please go to getwrecked.info/changelog for a complete list of changes.
"
]];

























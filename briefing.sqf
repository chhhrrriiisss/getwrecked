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
- I can't fire a weapon/module or the target is in the wrong place<br />
Ensure you have enough ammo/fuel and that it is keybound correctly. Sometimes hopping out of the vehicle then back in can help<br />
<br />
- My vehicle went flying across the map all of a sudden?<br />
If this happens when you are in a battle zone - then it is not a bug, it's the magnetic coil or some other velocity effect make your vehicle heavier by attaching more parts.<br />
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
<br />
[ Editing ]<br />
<br />
Grab / Drop - User Action 1<br />
Attach / Detach - User Action 2<br />
Rotate CW - User Action 3<br />
Rotate CCW - User Action 4<br />

Hold Rotate* - User Action 5<br /> 

* This is currently only available on suspended vehicles.

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
Please go to getwrecked.info/changelog for a complete list of changes and information.

Follow @getwreckeda3 for the latest updates.

"
]];

























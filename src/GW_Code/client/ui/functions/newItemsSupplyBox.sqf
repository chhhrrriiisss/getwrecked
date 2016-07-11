//
//      Name: newItemsSupplyBox
//      Desc: Visual effect when adding new items to a supply box
//      Return: None
//

private ['_height', '_pos', '_icon', '_arrow1', '_arrow2'];

// Check we're not already animating something
_exit = if (isNil "GW_NEW_ITEMS_ACTIVE") then {	GW_NEW_ITEMS_ACTIVE = _this; false } else {
	if (!isNil "GW_NEW_ITEMS_ACTIVE" && GW_NEW_ITEMS_ACTIVE == _this) exitWith { true };
	false
};

if (_exit) exitWith {};

// Small dust effect
[
	[
		_this
	],
	"muzzleEffect"
] call bis_fnc_mp;

GW_NEW_ITEMS_ACTIVE = _this;

_height = ([_this] call getBoundingBox) select 2;
_pos = _this modelToWorld [0,0,(_height)];
_icon = format['%1%2', MISSION_ROOT, "client\images\icons\hud\arrowDown.paa"];

_arrow1 = "UserTexture1m_F" createVehicleLocal _pos;
_arrow2 = "UserTexture1m_F" createVehicleLocal _pos;
_arrow1 setPos _pos;
_arrow2 setPos _pos;
_arrow2 setDir 180;
_arrow1 setObjectTexture [0,_icon];
_arrow2 setObjectTexture [0,_icon];

// Rotates object in a loop for a duration of time
_rotateIcon = {

	_time = time + 5;
	_dir = getDir _this;

	waitUntil {

		_dir = _dir + (	if (_dir > 360) then [{-360},{3}]	);
		_this setDir _dir;
		time > _time
	};

	deleteVehicle _this;	

	GW_NEW_ITEMS_ACTIVE = nil;
};	

_arrow1 spawn _rotateIcon;
_arrow2 spawn _rotateIcon;
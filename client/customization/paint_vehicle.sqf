//
//      Name: paintVehicle
//      Desc: Provides functionality for vehicles to be painted with a texture, triggers setVehicleTexture on complete
//      Return: None
//

// Make sure there isn't an existing paint job running
if (isNil "GW_PAINT_ACTIVE") then { GW_PAINT_ACTIVE = false; };
if (GW_PAINT_ACTIVE) exitWith {};
GW_PAINT_ACTIVE = true;

_color = [_this,0, "", [""]] call BIS_fnc_param;
_unit = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _unit || _color == "") exitWith {};
if (!(_color in GW_TEXTURES_LIST)) exitWith {};

// 15 Second timeout before auto-cancelling paint
_timeout = time + 15;
_selected = false;

// Add the actions to the player
removeAllActions _unit;
_unit setVariable ['paintTarget', nil];
GW_PAINT_CANCEL = false;

// Paint vehicle action
_paintAction = _unit addAction[paintVehicleFormat, {

	_unit = _this select 0;
	_nearby = (ASLtoATL getPosASL _unit) nearEntities [["Car"], 10];

	if ([(_nearby select 0), _unit, false] call checkOwner) then {
		_unit setVariable ['paintTarget', (_nearby select 0)];
	} else {
		systemChat 'You dont own this vehicle.';
	};

}, [], 0, false, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && !GW_LIFT_ACTIVE && (!isNil { [_target, 9] call validNearby }) )"];		

// Cancel action
_cancelAction = _unit addAction['Cancel', {

	if (!GW_PAINT_CANCEL) then { GW_PAINT_CANCEL = true; };

}, [], 0, true, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && !GW_LIFT_ACTIVE && isNil { _unit getVariable ['paintTarget', nil] } ) && !GW_PAINT_CANCEL"];		

// Time left loop
while {time < _timeout && alive _unit && GW_CURRENTZONE == "workshopZone" && (isNil { _unit getVariable ['paintTarget', nil] }) && !GW_PAINT_CANCEL} do {

	_str = format["SELECT VEHICLE (%1s)", ceil (_timeout - time)];
	[_str, 0.25, warningIcon, nil, "flash"] spawn createAlert;     
	Sleep 0.5;

};

// Wipe player actions
_unit removeAction _paintAction;
_unit removeAction _cancelAction;
_unit spawn setPlayerActions;

_target = _unit getVariable 'paintTarget';

// Check we're all good to paint
if (isNil "_target") exitWith { GW_PAINT_ACTIVE = false; };
if (!alive _target) exitWith { GW_PAINT_ACTIVE = false; };
if (GW_PAINT_CANCEL) exitWith{ GW_PAINT_ACTIVE = false; };

Sleep 0.25;

// Spray paint sound effect
[		
	[
		_target,
		"paint",
		30
	],
	"playSoundAll",
	true,
	false
] call BIS_fnc_MP;	  

// Apply Vehicle Texture in MP
[[_target,_color],"setVehicleTexture",true,false] call BIS_fnc_MP;

['VEHICLE PAINTED!', 2, successIcon, nil, "slideDown"] spawn createAlert; 

GW_PAINT_ACTIVE = false;

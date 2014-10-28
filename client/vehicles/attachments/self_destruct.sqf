//
//      Name: selfDestruct
//      Desc: Does what it says on the tin (but also automatically triggers the eject system)
//      Return: None
//

private ["_vehicle"];

_vehicle = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith {};
if (!local _vehicle || !alive _vehicle) exitWith {};

_timeout = 2;
_modules = _vehicle getVariable ["tactical", []];
if (count _modules == 0) exitWith {};

// Is there an eject system on this vehicle?
_eject = false;
{   
	if (( _x select 0) == 'PAR') exitWith { 
		[_vehicle, player] call ejectSystem;
   		systemChat "Emergency eject activated.";
	}; 

	false
	
} count _modules > 0;

for "_i" from _timeout to 0 step -1 do {
	['SELF DESTRUCT', 1.5, warningIcon, colorRed, 'slideDown'] spawn createAlert;
	Sleep 0.3;
};

_pos = (ASLtoATL getPosATL _vehicle);

// Prevent invulnerability from stopping it
_vehicle setVariable ["status", [], true];
_nearby = _pos nearEntities [["car"], 30];

{
	if (_x != _vehicle) then { 
		[_x] call markAsKilledBy; 
		_tPos =  (ASLtoATL getPosASL _x);
		_tPos set[2, 0.5];
		_bomb = createVehicle ["Bo_GBU12_LGB", _tPos, [], 0, "CAN_COLLIDE"];
		_x setDammage 0.9;
	};

	false
	
} count _nearby > 0;

// Just in case
_vehicle setDammage 1;



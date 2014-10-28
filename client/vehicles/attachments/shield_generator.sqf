//
//      Name: shieldGenerator
//      Desc: Makes the vehicle temporarily immune to most damage (excludes fire)
//      Return: None
//

private ["_obj", "_oPos", "_vehicle"];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _vehicle) exitWith {};

_oPos = (ASLtoATL getPosASL _obj);

playSound3D ["a3\sounds_f\sfx\explosion3.wss", _obj, false, _oPos, 2, 1, 100];

// Red bubble effect
[
	[
		_vehicle,
		10
	],
	"shieldEffect"
] call BIS_fnc_MP;

// If we're not already invulnerable
_status = _vehicle getVariable ["status", []];	
if ( !("invulnerable" in _status) ) then {

	[       
		[
			_vehicle,
			['invulnerable'],
			10
		],
		"addVehicleStatus",
		_vehicle,
		false 
	] call BIS_fnc_MP;  


	_currentPaint = _vehicle getVariable ["paint", ''];		
	if (_currentPaint == '') exitWith {};

	// Swap the paint temporarily if we have a custom texture on
	[_vehicle, _currentPaint] spawn {
		[[(_this select 0),'Shield'],"setVehicleTexture",true,false] call BIS_fnc_MP;
		Sleep 10;
		[[(_this select 0), (_this select 1)],"setVehicleTexture",true,false] call BIS_fnc_MP;
	};

};

true
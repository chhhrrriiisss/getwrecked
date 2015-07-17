//
//      Name: shieldGenerator
//      Desc: Makes the vehicle temporarily immune to most damage (excludes fire)
//      Return: None
//

private ["_obj", "_oPos", "_vehicle"];
params ['_obj', '_vehicle'];

if (isNull _obj || isNull _vehicle) exitWith { false };
if (!alive _obj || !alive _vehicle) exitWith { false };

_oPos = (ASLtoATL getPosASL _obj);

playSound3D ["a3\sounds_f\sfx\explosion3.wss", _obj, false, _oPos, 2, 1, 100];

// Red bubble effect
[
	[
		_vehicle,
		10
	],
	"shieldEffect"
] call bis_fnc_mp;

// If we're not already invulnerable
_status = _vehicle getVariable ["status", []];	
if ( !("invulnerable" in _status) ) then {

	[       
		[
			_vehicle,
			"['invulnerable']",
			10
		],
		"addVehicleStatus",
		_vehicle,
		false 
	] call bis_fnc_mp;  

	// Swap vehicle texture temporarily
	[_vehicle, 'client\images\vehicle_textures\special\shield.jpg', 10, { ("invulnerable" in ( (vehicle player) getVariable ['status', []])) } ] spawn swapVehicleTexture;

};

true
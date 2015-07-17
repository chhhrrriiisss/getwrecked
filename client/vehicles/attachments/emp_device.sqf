//
//      Name: empDevice
//      Desc: Fires a burst in a radius that disables nearby vehicles
//      Return: None
//

private ["_obj", "_vehicle"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_vehicle = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _vehicle) exitWith {};

_pos = (ASLtoATL getPosASL _vehicle);
_vehs = _pos nearEntities [["Car", "Tank"], 40];

[
	[
		_obj,
		0.7
	],
	"empCircle"
] call bis_fnc_mp;

playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_3.wss", _obj, false, _pos, 2, 1, 100];	

{
	_isVehicle = _x getVariable ['isVehicle', false];

	// Check if its an valid vehicle
	if (_isVehicle) then {		

		// If its the source vehicle
		if (_x == _vehicle) then {			

			[_vehicle, ['emp'], 7] call addVehicleStatus;

		} else {

			[       
                [
                    _x,
                    "['emp']",
                    10
                ],
                "addVehicleStatus",
                _x,
                false 
        	] call bis_fnc_mp;  

		};

		_status = _x getVariable ["status", []];

		// If its cloaked, de-cloak it too
		_arr = [];
		if ('cloak' in _status) then { _arr pushBack 'cloak'; };
		if ('invulnerable' in _status) then { _arr pushBack 'invulnerable'; };
		
		if ( !(_arr isEqualTo []) ) then {

			[       
				[
					_x,
					str _arr
				],
				"removeVehicleStatus",
				_x,
				false 
			] call bis_fnc_mp;  

		};	

	};

	false
	
} count _vehs > 0;



_isAI = _vehicle getVariable ['isAI', false];
if (!_isAI) then { 

	// Small static effect for epicness
	_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);
	_layerStatic cutRsc ["RscStatic", "PLAIN" , 2];

	["EMP ACTIVATED ", 1, empIcon, colorWhite, "warning"] spawn createAlert; 
};

true



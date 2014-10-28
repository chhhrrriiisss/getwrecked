//
//      Name: checkMark
//      Desc: Finds and returns an array of object data from the specified array
//      Return: Array (All found values)
//

private ['_t'];

_t = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _t) exitWith {};

_isVehicle = _t getVariable ["isVehicle", false];

// Its a valid vehicle
if (_isVehicle) then {

	_killedBy = _t getVariable ["killedBy", "Nobody"];
	_status = _t getVariable ["status", []];

	// Disable cloak
	if ('cloak' in _status) then {

		[       
			[
				_t,
				['cloak']
			],
			"removeVehicleStatus",
			_t,
			false 
		] call BIS_fnc_MP;  

	};				

	// Tag that sucker
	if ( ( _killedBy == "Nobody") || (_killedBy != GW_PLAYERNAME) ) then {
		[_t] call markAsKilledBy;
	};

};
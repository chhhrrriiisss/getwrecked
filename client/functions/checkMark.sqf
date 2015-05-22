//
//      Name: checkMark
//      Desc: Finds and returns an array of object data from the specified array
//      Return: Array (All found values)
//

private ['_t', '_m'];

_t = _this select 0;
_m =  _this select 1;

if (isNull _t) exitWith {};

_isVehicle = _t getVariable ["isVehicle", false];

// Its a valid vehicle
if (_isVehicle) then {

	_killedBy = _t getVariable ["killedBy", nil ];
	_killedBy = if (isNil "_killedBy") then { ["Nobody", ""] } else { 
		if (typename _killedBy == "STRING") exitWith { (call compile _killedBy) };
		_killedBy
	};
	
	_status = _t getVariable ["status", []];

	// Disable cloak
	if ('cloak' in _status) then {

		[       
			[
				_t,
				"['cloak']"
			],
			"removeVehicleStatus",
			_t,
			false 
		] call gw_fnc_mp;  

	};				

	// Tag that sucker
	if ( ( (_killedBy select 0) == "Nobody") || !((_killedBy select 0) isEqualTo name player && (_killedBy select 1) isEqualTo _m) ) then {
		[_t, _m] call markAsKilledBy;
	};

};
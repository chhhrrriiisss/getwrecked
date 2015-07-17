private ['_vehicle'];

_vehicle = _this;
_isAI = _vehicle getVariable ['isAI', false];
if (_isAI) exitWith {};
_isAI = _vehicle setVariable ['isAI', true, true];

createVehicleCrew _vehicle;
// _driverGroup = createGroup civilian;
// _ai = _driverGroup createUnit ["C_man_pilot_F", [0,0,0], [], 0, "NONE"];

// _ai allowDamage false;

// _name = _vehicle getVariable ['name', 'blarg'];

// systemchat format['moving ai into %1', _name];

// _ai assignAsDriver _vehicle;
// _ai moveInDriver _vehicle;
// [_ai] orderGetIn true;

systemChat format ['Created AI pilot for %1', _vehicle];

// if (true) exitWith {};

// [_vehicle, _ai] spawn {
	
// 	_v = (_this select 0);
// 	_ai = (_this select 1);

_currentZone = "";
_currentPos = (ASLtoATL getPosASL _vehicle);
_currentTarget = _vehicle;
_ai = driver _vehicle;
_vehicle lockDriver true;
_ai allowFleeing 0;
_ai allowDamage false;
_ai disableAI "FSM";
_ai disableAI "AUTOTARGET";
_vehicle setVariable ['GW_Owner', (name _ai), true];

// Determine current zone
{
	_z = format['%1Zone', (_x select 0)];
	_inZone = [_currentPos, _z] call checkInZone;
	if (_inZone) exitWith { _currentZone = _z; false };
	false
} count GW_VALID_ZONES;

for "_i" from 0 to 1 step 0 do {	

	_targets = [_currentZone, true] call findAllInZone;
	
	{
		if (isPlayer (driver _x) && (alive _x) && _x != _vehicle) exitWith {
			_currentTarget = _x;
			false
		};
		false
	} count _targets;

	_sleepTime = if (!isNil "_currentTarget") then {
		_dist = _ai distance _currentTarget;
		_location = if (_dist < 100) then {
			_dirTo = [_ai, _currentTarget] call dirTo;
			([_ai, (_dist / 2), _dirTo] call relPos)

		} else {
			(_currentTarget modelToWorld [0, [((velocity _currentTarget) distance [0,0,0]) * 3, -100, 100] call limitToRange, 0])
		};

		_ai doMove _location;
		systemChat format ['Moving to %1', _currentTarget];

		_dirTo = [_vehicle, _currentTarget] call dirTo;
		_vehDir = getDir _vehicle;

		{
			_tag = _x getVariable ['GW_Tag', ''];
			if (_tag == "HMG") then {

				_objDir = [(getDir _x) - (_vehDir)] call normalizeAngle;
				_dif = [_objDir - _dirTo] call flattenAngle;
				if (_dif < 40) then {

					_tagData = ['HMG'] call getTagData;
					_reloadTime = _tagData select 0;

					for "_i" from 0 to 8 step 1 do {

						[_x, _currentTarget modelToWorld [0,0,1], _vehicle] call fireHmg;

						[			
							[
								_currentTarget,
								"motor",
								0.1,
								nil,
								"B_127x99_Ball"
							],
							"handleDamageVehicle",
							_currentTarget,
							false
						] call bis_fnc_mp;	

						Sleep (_reloadTime / 2);
					};
					
					systemchat 'firing!';
				};
				false
			};
		} count (attachedObjects _vehicle);

		// [
		// 	["FLM", { systemchat 'flames!'; }],
		// 	["RPG", { systemchat 'rpgs!!'; }],
		// 	["LSR", { systemchat 'lsers!!'; }],
		// 	["MIS", { systemchat 'missiles!'; }],
		// 	["HMG", { systemchat 'hmgs!'; }]
		// ];

		([(velocity _currentTarget) distance [0,0,0], 1, 15] call limitToRange)

	} else {
		10
	};


	_isAI = _vehicle getVariable ['isAI', false];
	if ((!alive _vehicle) || (!alive _ai) || !_isAI || (_ai != (driver _vehicle))) exitWith {};

	Sleep _sleepTime;


};

// Cleanup
deleteGroup (group _ai); 
_ai setDammage 1;

//deleteVehicle _ai;
// };
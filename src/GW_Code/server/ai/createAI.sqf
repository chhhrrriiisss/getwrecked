private ['_vehicle', '_location', '_skill', '_aiToCreate', '_group', '_ai'];

_exitCode = {
	_msg = _this;
	diag_log _msg;
	systemChat _msg;	
};

if (((count GW_AI_ACTIVE) -1) >= GW_AI_MAX) exitWith { 'Cant create AI - Max Limit reached.' call _exitCode; };

_location = [_this, 0, [], [[]]] call filterParam;
_aiToCreate = [_this, 1, (GW_AI_LIBRARY call BIS_fnc_selectRandom), ["", []] ] call filterParam;
_skill = [_this,2, ([(random 1), 0.1, 1] call limitToRange), [0]] call filterParam;

// Find the AI to spawn from data list
if (count _location == 0) exitWith { 'Bad spawn location specified' call _exitCode; };
if (typename _aiToCreate == "STRING") then {
	{
		_name = (_x select 0) select 1;
		if (_name == _aiToCreate) exitWith { _aiToCreate = _x; };
	} foreach GW_AI_LIBRARY;
};
if (typename _aiToCreate == "STRING") exitWith { 'No AI with that name found.' call _exitCode; };

// Load the vehicle and wait for object creation
GW_LOADEDVEHICLE = nil;					
[objNull, _location, (_aiToCreate select 0), true] spawn loadVehicle;

_timeout = time + 5;
waitUntil {
	((time > _timeout) || (!isNil "GW_LOADEDVEHICLE"))
};
if (time > _timeout || isNil "GW_LOADEDVEHICLE") exitWith { 'Error creating AI, load vehicle timeout.' call _exitCode; };

// Mark vehicle as AI and create crew
_vehicle = GW_LOADEDVEHICLE;
_isAI = _vehicle setVariable ['isAI', true, true];
createVehicleCrew _vehicle;

// Set AI attributes and skill
_vehicle lock true;
_ai = driver _vehicle;

// Set AI's name to last name to avoid remote name calls not finding it
_lastName = ([name _ai," "] call BIS_fnc_splitString) select 1;
_ai setName _lastName;
_ai allowDamage false;

_vehicle setVariable ['GW_Owner', (name _ai), true];
_vehicle setVariable ['GW_Skill', _skill];
_vehicle setVariable ['GW_WantedValue', (_aiToCreate select 1)];

// Set default target 
_currentTarget = _vehicle call findAITarget;
_vehicle setVariable ['GW_Target', _currentTarget];
if (!isNull _currentTarget) then { 
	_dirTo = [_vehicle, _currentTarget] call dirTo;
	_vehicle setDir _dirTo;
};

// Module trigger configuration
_moduleConfig = [];

// Delete module triggers we dont need for this vehicle
for "_i" from (count GW_AI_MODULE_DEFAULTS)-1 to 0 step -1 do {
	_module = GW_AI_MODULE_DEFAULTS select _i;
	_tag = _module select 0;
	_num = [_tag, _vehicle] call hasType;
	if (_num > 0) then { 
		// Decrease reload time for more modules of same type
		_moduleToAdd = +_module;
		_moduleToAdd set [1, ((_moduleToAdd select 1) / _num)];
		_moduleConfig pushBack _module;
	};
};
_vehicle setVariable ['GW_Modules', _moduleConfig];

_vehicle allowCrewInImmobile true;
[_vehicle, ['nanoarmor'], 9999] call addVehicleStatus;
_group = group _ai;
_group allowFleeing 0;
_group setCombatMode "RED";

{
	_x setskill ["courage",_skill];
	_x setskill ["aimingAccuracy",_skill];
	_x setskill ["aimingShake",_skill];
	_x setskill ["aimingSpeed",_skill];
	_x setskill ["endurance",_skill];
	_x setskill ["spotDistance",_skill];
	_x setskill ["spotTime",_skill];
	_x setskill ["reloadSpeed",_skill];
	_x setskill ["courage",_skill];
	_x setskill ["general",_skill];
	_x setskill ["commanding",_skill];
	_x setCombatMode "RED";
	_x setSkill _skill;
	_x setUnitAbility 100;
	_x allowDamage false;
	_x disableAI "FSM"; ///
	_x disableAI "AIMINGERROR";
	_x disableAI "AUTOTARGET";
	false
} count crew _vehicle;

_vehicle setVariable ['GW_Crew', _group];

// Always restore ammo when firing
if (isNil { _vehicle getVariable "GW_firedEH"}) then { 	_vehicle setVariable ['GW_firedEH', _vehicle addEventHandler['fired', {	(_this select 0) setVehicleAmmo 1; }] ]; };

// Hide all attached objects locally so we can aim efficiently
{ _x hideObject true; } foreach (attachedObjects _vehicle);

// Add AI to active loop
GW_AI_ACTIVE pushback _vehicle;


//
//      Name: cleanup
//      Desc: Custom cleanup function for Get Wrecked 
//		Author: Sli
//      Return: None
//

GW_CLEANUP_ACTIVE = false;

// Items to check / Timeout for item
cleanUpCommands = [

	// Supply boxes and unattended parts
	[{ 
		_a = [];
		{ 
			_ignore = _x getVariable ['GW_CU_IGNORE', false];
			if (isNull (attachedTo _x) && !_ignore) then { 
				if (_x call isSupplyBox) then {
					_inv = _x getVariable ['GW_Inventory', []];
					if (count _inv > 0) exitWith {};				
					_a pushBack _x; 
				} else {
					_a pushBack _x; 
				};
			};
			false
		} count (nearestObjects [(getmarkerpos "workshopZone_camera"), [], 300]);
		_a
	}, 240],

	// Empty and unclaimed vehicles
	[{ 
		_a = [];
		_allVehicles = (allMissionObjects "Car");
		_allVehicles append (allMissionObjects "Tank");
		_workshop = (getmarkerpos "workshopZone_camera");
		{ 
			_minDist = if ((_x distance _workshop) < 300) then { 75 } else { 10 };
			_vS = (ASLtoATL getPosASL _x) nearEntities [["Man"], _minDist];
			_crew = false;
			{ if (alive _X) exitWith { _crew = true; }; false } count (crew _x);
			if (_vS isEqualTo [] && !_crew) then { 

				_a pushBack _x; 

			} else { _x setVariable ["GW_CU", nil]; };	

			false
		} count _allVehicles;
		_a
	}, 60],

	// Wildlife cleanup
	[{ 
		_a = [];
		_agentTypes = [
			"Rabbit_F",
			"Snake_random_F",
			"ButterFly_random",
			"Bird",
			"Cicada",
			"DragonFly",
			"HoneyBee",
			"HouseFly",
			"Insect",
			"Kestrel_Random_F",
			"Mosquito",
			"SeaGull",
			"Tuna_F",
			"Turtle_F",
			"CatShark_F"
		];

		{
			if (_agentTypes find (typeOf agent _x) >= 0) then {
				_a pushBack (agent _x);
			};
			false
		} count agents;

		_a

	}, 10],
	
	[{ (allMissionObjects "#destructioneffects") }, 10],
	[{ (allMissionObjects "#smokesource") }, 10],
	[{ (allMissionObjects "Default") }, 10],
	[{ (allMissionObjects "EmptyDetector") }, 10],
	[{ (allMissionObjects "CraterLong") }, 10],
	[{ (allMissionObjects "Ruins") }, 10],
	[{ (allDead) }, 60]
];

checkDeadTimeout = compileFinal '	
	if (typename (_this select 0) != "OBJECT") exitWith { false };
	_cT = (_this select 0) getVariable ["GW_CU", nil];
	if (isNil "_cT") exitWith {	(_this select 0) setVariable ["GW_CU", time]; };
	if (time > (_cT + (_this select 1))) exitWIth { true };
	false
';

executeCleanUp = {
	
	_manualMode = if (!isNil { _this select 0 }) then { true } else { false };

	{
		_arr = call (_x select 0);
		_timeout = _x select 1;

		{
			_ignore = _x getVariable ['GW_CU_IGNORE', false];
			if ( ([_x, _timeout] call checkDeadTimeout) && !_ignore || _manualMode) then {

				// Flag it so that if delete doesn't work we just ignore it next time
				_x setVariable ['GW_CU_IGNORE', true];
				{ _x setVariable ['GW_CU_IGNORE', true]; } foreach (attachedObjects _x);

				diag_log format['Deleting %1 at %2', typeof _x, time];
				{ deleteVehicle _x; } foreach (attachedObjects _x);
				deleteVehicle _x; 				
			};
		} count _arr > 0;	

	} count cleanUpCommands;

	if (!_manualMode) exitWith { true };

	_source = owner (_this select 0);

	_str = "Cleanup script successfully run.";
	systemchat _str;
	pubVar_systemChat = _str;	
	_source publicVariableClient "pubVar_systemChat";
	systemchat format['Cleanup script executed manually at %1', time];

	true

};

// _rate = GW_CLEANUP_RATE call {
// 	if (_this == 0) exitWith { [0,0,0] }; // Off	
// 	if (_this == 5) exitWith { [60, 45, 30] }; // V.High
// 	if (_this == 4) exitWith { [3*60, 2*60, 60] }; // High		
// 	if (_this == 2) exitWith { [6*60, 5*60, 4*60] }; // Med
// 	if (_this == 1) exitWith { [10*60, 8*60, 6*60] }; // Low
// 	[3*60, 2*60, 1*60, 30] // Default (3)
// };

// GW_CLEANUP_RATE_LOW = _rate select 0; // < 50%
// GW_CLEANUP_RATE_MED = _rate select 1; // >= 50%
// GW_CLEANUP_RATE_HIGH = _rate select 2; // >= 75%
// GW_CLEANUP_TIMEOUT = time;


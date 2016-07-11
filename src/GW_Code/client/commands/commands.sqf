GW_COMMANDS_LIST = [
	
	[
		"spectate",
		{
			[] execVM 'testspectatorcamera.sqf';
		}
	],

	[
		"boundary",
		{

			if (GW_BOUNDARIES_ENABLED) then {

				{
					[(_x select 0)] call removeZoneBoundary;
				} foreach GW_ZONE_BOUNDARIES;
				GW_BOUNDARIES_ENABLED = false;
				systemchat 'Zone boundaries disabled. Use !boundary to re-enable.';

			} else {

				GW_BOUNDARIES_ENABLED = true;
				['workshopZone'] call buildZoneBoundary;
				[GW_CURRENTZONE] call buildZoneBoundary;		
				systemchat 'Zone boundaries enabled.';		

			};

		}
	],

	[
		
		"changebalance",
		{

			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			if (isNil "_argument" || _argument == '' || _argument == ' ') exitWith {				
				systemChat 'No target player.';				
			};

			_global = if (_argument in ['All', 'ALL', 'all']) then { true } else { false };
			_unit = if (!_global) then { ([_argument] call findUnit) } else { objNull };

			if (isNull _unit && !_global) exitWith { systemCHat 'Player not found.'; };			

			[_unit, _global] spawn {

				_result = ['ENTER AMOUNT', '0', 'INPUT'] call createMessage;

				if (_result isEqualType "") then {

					if (count toArray _result > 0) then {

						_amount = parseNumber(_result);
						_target = if ( (_this select 1) ) then { true } else { (_this select 0) };

						[		
							_amount,
							"changeBalance",
							_target,
							false
						] call bis_fnc_mp;	 

					};

				};	

			};		
					
		}
	],

	[
		
		"compile",
		{

			params ['_argument'];	

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			if (count toArray _argument > 0) exitWith {

				_defaultPath = 'global\functions\';
				_fnc = [];
				{
					if ((_x select 0) == _argument) exitWith {
						_fnc = _x;
					};
				} foreach GW_globalFunctions;	

				if (count _fnc == 0) then {
					_defaultPath = 'client\functions\';
					{
						if ((_x select 0) == _argument) exitWith {
							_fnc = _x;
						};
					} foreach GW_clientFunctions;	
				};

				// Function not found, abort
				if (count _fnc == 0) exitWith {};

				[[_fnc], _defaultPath, TRUE] call functionCompiler;
				systemchat format['%1 recompiled successfully.', (_fnc select 0)];
			};

			call compile preprocessFile "global\compile.sqf";

			if (GW_Client || GW_JIP) then {
				call compile preprocessFile "client\compile.sqf";  
				call compile preprocessFile 'client\ui\compile.sqf';
			};

			if (GW_Server) then {
				call compile preprocessFile "server\compile.sqf";  
			};

			systemChat 'Re-compile complete.';

		}
	],

	[
		
		"help",
		{

			params ['_argument'];	

			_hintsEnabled = profileNamespace getVariable ['GW_HINTS', true];

			if (_hintsEnabled) then {

				_string = _this select 0;
				_result = [format['HIDE ALL HINTS %1?', _string], '', 'CONFIRM'] call createMessage;
				if !(_result isEqualType true) exitWith {};

				if (_result) then {
					profileNamespace setVariable ['GW_HINTS', false];
					GW_HINTS_ENABLED = false;
					systemchat 'Hints disabled - use !help again to toggle on.';
				};

			} else {

				profileNamespace setVariable ['GW_HINTS', true];
				GW_HINTS_ENABLED = true;
				systemchat 'Hints enabled - use !help again to toggle off.';

			};
					
		}
	],

	[
		
		"supply",
		{

			params ['_argument'];	

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			_pos = (vehicle player) modelToWorldVisual [0, 40, 0];

			[
				[_pos, true, _argument],
				'createSupplyDrop',
				false,
				false
			] call bis_fnc_mp;	

			systemChat 'Supply drop inbound.';	
					
		}
	],
	
	[
		
		"reset",
		{

			_argument = [_this, 0, "ALL", [""]] call filterParam;
			if (count toArray _argument == 0) exitWith { 


				systemchat 'Use: !reset <money | unlocks | library | races | binds | all>'

			};

			_argument = toUpper(_argument);

			0 = [_argument] spawn {

				_string = _this select 0;
				_result = [format['RESET %1?', _string], '', 'CONFIRM'] call createMessage;

				if !(_result isEqualType true) exitWith {};
				if (!_result) exitWith {};

				_string call {

					if (_this == "ALL") exitWith {
						profileNamespace setVariable [GW_BALANCE_LOCATION, GW_INIT_BALANCE];
						profileNamespace setVariable [GW_UNLOCKED_ITEMS_LOCATION, nil]; 
						profileNamespace SetVariable [GW_LIBRARY_LOCATION, nil];
						profileNamespace setVariable ['GW_FIXDLC', nil];	
						profileNamespace setVariable ['GW_HINTS_ENABLED', nil];	
						profileNamespace setVariable [GW_BINDS_LOCATION, nil];
						profileNamespace setVariable [GW_BINDS_VERSION_LOCATION, nil];
						saveProfileNamespace;
						systemChat 'Profile reset successfully.';
					};

					if (_this == "HINTS") exitWith {
						profileNamespace setVariable ['GW_HINTS_ENABLED', nil];	
						systemChat 'Money reset successfully.';			
					};

					if (_this == "MONEY") exitWith {
						profileNamespace setVariable [GW_BALANCE_LOCATION, nil];		
						systemChat 'Money reset successfully.';			
					};

					if (_this == "UNLOCKS") exitWith {
						profileNamespace setVariable [GW_UNLOCKED_ITEMS_LOCATION, nil]; 
						systemChat 'Unlocks reset successfully.';					
					};

					if (_this == "LIBRARY") exitWith {
						profileNamespace SetVariable [GW_LIBRARY_LOCATION, nil];	
						systemChat 'Library reset successfully.';				
					};

					if (_this == "RACES") exitWith {
						profileNamespace SetVariable [GW_RACES_LOCATION, nil];	
						profileNamespace setVariable ['GW_RACE_VERSION', nil];
						systemChat 'Races library reset successfully.';				
					};

					if (_this == "BINDS") exitWith {
						profileNamespace setVariable [GW_BINDS_LOCATION, nil];
						profileNamespace setVariable [GW_BINDS_VERSION_LOCATION, nil];
						systemChat 'Global keybinds reset successfully.';				
					};


					true	
				};

				saveProfileNamespace;
				
			};		
					
		}
	],

	[
		
		"sendmoney",
		{

			params ['_argument'];

			if (isNil "_argument" || _argument == '' || _argument == ' ') exitWith {				
				systemChat 'Please enter target name.';				
			};

			_unit = [_argument] call findUnit;

			if (isNull _unit) exitWith { systemCHat 'Target not found.'; };		
			//if (_unit == player) exitWith { systemChat 'You cant send money to yourself.' };	

			[_unit, _argument] spawn {

				_result = ['ENTER AMOUNT', '0', 'INPUT'] call createMessage;

				if (_result isEqualType "") then {

					if (count toArray _result > 0) then {

						_amount = parseNumber(_result);
						_accepted = -_amount call changeBalance;						

						if (_accepted) then {

							[		
								_amount,
								"changeBalance",
								(_this select 0),
								false
							] call bis_fnc_mp;	 

							_string = format['%1 received $%2 from %3.', toUpper(_this select 1), ([_amount] call numberToCurrency), name player];
							systemChat _string;	
							pubVar_systemChat = _string;
							publicVariable "pubVar_systemChat";

						} else {
							systemchat 'You do not have enough money.';
						};

					};

				} else {
					systemChat 'Invalid amount.';
				};

			};		
					
		}
	],

	[
		
		"inv",
		{

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			_status = GW_CURRENTVEHICLE getVariable ['status', []];
			if ('invulnerable' in _status) then {
				[GW_CURRENTVEHICLE, ['invulnerable']] call removeVehicleStatus;
				systemchat 'Invulnerability disabled.';
			} else {
				[GW_CURRENTVEHICLE, ['invulnerable'], 99999] call addVehicleStatus;
				systemchat 'Invulnerability enabled.';
			};

							
		}
	],
	

	[
		
		"collision",
		{

			if (player == (vehicle player)) exitWith {
				systemCHat 'You need to be in a vehicle to use this.';
			};

			_v = (vehicle player);

			_hasCollision = _v getVariable ['GW_COLLISION', false];

			if (_hasCollision) then {
				_v setVariable ['GW_COLLISION', false];
				systemChat 'Collision disabled';
			} else {
				_v execVM 'testcollision.sqf';	
				systemChat format['Collision active on [ %1 ]', _v getVariable ['name', 'Untitled Vehicle']];
			};		

							
		}
	],
	

	[
		
		"library",
		{

			params ['_argument'];

			if (isNil "_argument" || _argument == '' || _argument == ' ') exitWith {
				[] spawn listVehicles;					
			};

			if (_argument == 'clear') exitWith {		
				['clear'] spawn listFunctions;		
			};		

			_delete = ['delete', _argument] call inString;

			if (_delete) exitWith {

				0 = [] spawn {

					_result = ['VEHICLE TO DELETE', '', 'INPUT'] call createMessage;

					if (_result isEqualType "") then {

						if (count toArray _result > 0) then {		

							['delete', _result] spawn listFunctions;	

						};

					};

				};				
				
			};
					
		}
	],

	[

		"accept",
		{

			if (isNil "GW_SHARED_ARRAY") exitWith {
				systemchat 'No shared vehicles available';
			};

			if (count GW_SHARED_ARRAY == 0) exitWith {
				systemchat 'No shared vehicles available';
			};

			params ['_argument'];

			_len = count toArray(_argument);
			_target = nil;
			if (_len == 0) then { _target = (GW_SHARED_ARRAY select (count GW_SHARED_ARRAY - 1)); };
			if (isNil "_target") then {
				{
					_name = _x select 1;
					if ((toUpper _name) isEqualTo (toUpper _argument)) exitWith { _target = _x; GW_SHARED_ARRAY deleteAt _foreachindex; };	
				} foreach GW_SHARED_ARRAY;
			};

			if (isNil "_target") exitWith { systemchat 'No vehicle found with that name'; };

			_success = [(_target select 1), _target] call registerVehicle;

			if (_success) then {
				systemchat format['%1 added to library.', (_target select 1)];
			} else {
				systemchat format['Error adding %1 to library.', (_target select 1)];
			};
		}
	],
	
	[
		
		"copy",
		{

			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			_len = count toArray(_argument);
			if (_len == 0) exitWith {
				systemchat 'Please specify vehicle to copy.';
			};

			[
				[_argument, name player],
				'shareVehicle',
				true,
				false
			] call bis_fnc_mp;	

		}
	],

	[
		
		"load",
		{

			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			_len = count toArray(_argument);
			if (_len == 0 && isNil "GW_LASTLOAD") exitWith {
				systemchat 'Please specify vehicle to load.';
			};

			if (_len == 0) then {
				_argument = GW_LASTLOAD; 
			};

			[GW_CURRENTVEHICLE modelToWorldVisual [0, 30, 0], _argument] spawn requestVehicle;

		}
	],

	[
		
		"loadai",
		{

			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			_len = count toArray(_argument);
			if (_len == 0 && isNil "GW_LASTLOAD") exitWith {
				systemchat 'Please specify vehicle to load.';
			};

			[		
				[
					(GW_CURRENTVEHICLE modelToWorldVisual [0, 200, 0]),
					_argument,
					1
				],
				"createAI",
				false,
				false
			] call bis_fnc_mp;

			// [(GW_CURRENTVEHICLE modelToWorldVisual [0, 200, 0]), _argument, 1] execVM 'server\ai\createAI.sqf';
			
		}
	],

	[
		
		"clearai",
		{

			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			[
				[
					[],
					{
						{
							_x setdammage 1;
						} foreach GW_AI_ACTIVE;
					}
				], 
				"BIS_fnc_spawn",
				false,
				false
			] call bis_fnc_mp;

			// [(GW_CURRENTVEHICLE modelToWorldVisual [0, 200, 0]), _argument, 1] execVM 'server\ai\createAI.sqf';
			
		}
	],

	[
		
		"spawn",
		{

			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			_len = count toArray(_argument);
			if (_len == 0) then {
				_argument = lastSpawn;
			};

			_data = [_argument, GW_LOOT_LIST] call getData;

			if (!isNil "_data") then {

				_type = _data select 0;
				_relPos = player modelToWorldVisual [0, 2, 0];		
				[_relPos, _type] call createObject;

				lastSpawn = _type;

			} else {

				systemChat format['Couldnt find %1.', _argument];
			};		
		}
	],

	[
		
		"cleanup",
		{

			if ( !(serverCommandAvailable "#kick") ) exitWith { systemChat 'You need to be an admin to use that.'; };

			[		
				[
					player
				],
				"executeCleanUp",
				false,
				false
			] call bis_fnc_mp;
		}
	],

	[
		
		"race",
		{

			if ( !(serverCommandAvailable "#kick") ) exitWith { systemChat 'You need to be an admin to use that.'; };	

			[] execVM 'client\functions\generateRace.sqf';
		}
	],

	[
		
		"warp",
		{

			if ( !(serverCommandAvailable "#kick") ) exitWith { systemChat 'You need to be an admin to use that.'; };	

			[] spawn
			{
				closedialog 0;
				sleep 0.5;
				TitleText [format["Click on the map to teleport."], "PLAIN DOWN"];
				openMap [true, false];
				onMapSingleClick "[_pos select 0, _pos select 1, 8] spawn {

					_pos = [_this select 0, _this select 1,_this select 2];

					(vehicle player) setpos [_pos select 0, _pos select 1, 0];				
					openMap [false, false];
					TitleText [format[''], 'PLAIN DOWN'];
					onMapSingleClick '';

				}; true";
			};		
		}
	],

	[
		
		"tp",
		{
			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith { systemChat 'You need to be an admin to use that.'; };	

			_target = [_argument] call findUnit;

			if (!isNil "_target") then {
				(vehicle player) setPos ((vehicle _target) modelToWorld [15, 0, 1]);
			} else {
				systemChat 'Player not found';					
			};	
		}
	],

	[
		
		"grab",
		{
			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith { systemChat 'You need to be an admin to use that.'; };	

			_target = [_argument] call findUnit;

			if (!isNil "_target") then {
				(vehicle _target) setPos ((vehicle player) modelToWorld [0, 15, 1]);
			} else {
				systemChat 'Player not found';					
			};	
		}
	],

	[
		
		"kill",
		{
			params ['_argument'];

			if ( !(serverCommandAvailable "#kick") ) exitWith { systemChat 'You need to be an admin to use that.'; };

			_target = [_argument] call findUnit;

			if (!isNil "_target") then {
				_pos = ASLtoATL getPosASL (vehicle _target);
				_bomb = createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "CAN_COLLIDE"];						
				_target setDammage 1;

			} else {
				systemChat 'Player not found';
			};		
		}
	],

	[
		
		"fixdlc",
		{
			params ['_argument'];

			_fixdlc = profileNamespace getVariable ['GW_FIXDLC', false];

			if (_fixdlc) then {
				profileNamespace setVariable ['GW_FIXDLC', false];
				systemchat 'DLC fix disabled. ';
				removeHeadgear player;
				player addHeadgear "H_RacingHelmet_1_black_F";
			} else {
				profileNamespace setVariable ['GW_FIXDLC', true];
				systemchat 'DLC fix enabled. Use !fixdlc to disable.';
				removeHeadgear player;
				player addHeadgear "H_PilotHelmetHeli_B";
			};				
		}
	]
];        
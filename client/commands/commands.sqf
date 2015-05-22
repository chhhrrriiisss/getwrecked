GW_COMMANDS_LIST = [

	[
		
		"changebalance",
		{

			_argument = _this select 0;

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

				if (typename _result == "STRING") then {

					if (count toArray _result > 0) then {

						_amount = parseNumber(_result);
						_target = if ( (_this select 1) ) then { true } else { (_this select 0) };

						[		
							_amount,
							"changeBalance",
							_target,
							false
						] call gw_fnc_mp;	 

					};

				};	

			};		
					
		}
	],

	[
		
		"supply",
		{

			_argument = _this select 0;	

			if ( !(serverCommandAvailable "#kick") ) exitWith {
				systemChat 'You need to be an admin to use that.';
			};

			_pos = (vehicle player) modelToWorldVisual [0, 40, 0];

			[
				[_pos, true, _argument],
				'createSupplyDrop',
				false,
				false
			] call gw_fnc_mp;	

			systemChat 'Supply drop inbound.';	
					
		}
	],
	
	[
		
		"reset",
		{

			_argument = _this select 0;			

			_argument = if (isNil "_argument" || _argument == '' || _argument == ' ') then { 'all' } else { _argument };
			_argument = toUpper(_argument);

			0 = [_argument] spawn {

				_result = [format['RESET %1?', (_this select 0)], '', 'CONFIRM'] call createMessage;

				if (typename _result != "BOOL") exitWith {};
				if (!_result) exitWith {};

				(_this select 0) call {

					if (_this == "ALL") exitWith {
						profileNamespace setVariable ['GW_BALANCE', GW_INIT_BALANCE];
						profileNamespace setVariable ['GW_UNLOCKED_ITEMS', nil]; 
						profileNamespace SetVariable ['GW_LIBRARY', nil];
						profileNamespace setVariable ['GW_FIXDLC', nil];	
						systemChat 'Profile reset successfully.';
					};

					if (_this == "MONEY") exitWith {
						profileNamespace setVariable ['GW_BALANCE', nil];		
						systemChat 'Money reset successfully.';			
					};

					if (_this == "UNLOCKS") exitWith {
						profileNamespace setVariable ['GW_UNLOCKED_ITEMS', nil]; 
						systemChat 'Unlocks reset successfully.';					
					};

					if (_this == "LIBRARY") exitWith {
						profileNamespace SetVariable ['GW_LIBRARY', nil];	
						systemChat 'Library reset successfully.';				
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

			_argument = _this select 0;

			if (isNil "_argument" || _argument == '' || _argument == ' ') exitWith {				
				systemChat 'Please enter target name.';				
			};

			_unit = [_argument] call findUnit;

			if (isNull _unit) exitWith { systemCHat 'Target not found.'; };		
			//if (_unit == player) exitWith { systemChat 'You cant send money to yourself.' };	

			[_unit, _argument] spawn {

				_result = ['ENTER AMOUNT', '0', 'INPUT'] call createMessage;

				if (typename _result == "STRING") then {

					if (count toArray _result > 0) then {

						_amount = parseNumber(_result);
						_accepted = -_amount call changeBalance;						

						if (_accepted) then {

							[		
								_amount,
								"changeBalance",
								(_this select 0),
								false
							] call gw_fnc_mp;	 

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
		
		"list",
		{

			_argument = _this select 0;

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

					if (typename _result == "STRING") then {

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

			_argument = _this select 0;

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

			_argument = _this select 0;

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
			] call gw_fnc_mp;	

		}
	],

	[
		
		"load",
		{

			_argument = _this select 0;

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
		
		"spawn",
		{

			_argument = _this select 0;

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
			] call gw_fnc_mp;
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
			_argument = _this select 0;

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
			_argument = _this select 0;

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
			_argument = _this select 0;

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
			_argument = _this select 0;

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
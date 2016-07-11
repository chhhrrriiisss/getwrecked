// Supply box custom effects
GW_SUPPLY_TYPES = [

	[		
		"care",
		0.45,
		randomSign,
		{	
			_crate = _this;
			_vehicle = (vehicle player);
			_vehicle setVariable ['fuel', (_vehicle getVariable ['maxFuel', 1]), true];				
			_vehicle setFuel 1;
			_vehicle setVariable ['ammo', (_vehicle getVariable ['maxAmmo', 1]), true];			
			_vehicle setDammage 0;

			['SERVICE PACKAGE!', 1, successIcon, nil, "slideDown"] spawn createAlert; 		
		}
	],

	[		
		"money",
		0.45,
		randomSign,
		{	
			_crate = _this;
			_amount = ((random 5000) + 5000);
			_amount call changeBalance;
			[		
				[
					(vehicle player),
					"money",
					40
				],
				"playSoundAll",
				true,
				false
			] call bis_fnc_mp;	 

			[ format['RECEIVED $%1!', ([_amount] call numberToCurrency)], 2, successIcon, nil, "slideDown"] spawn createAlert; 
		}
	],

	[		
		"pink",
		0.9,
		randomSign,
		{	
			_crate = _this;
			_vehicle = (vehicle player);
			// Spray paint sound effect
			[		
				[
					_vehicle,
					"paint",
					100
				],
				"playSoundAll",
				true,
				false
			] call bis_fnc_mp;	 

			[[_vehicle,'Pink'],"setVehicleTexture",true,false] call bis_fnc_mp;
		}
	],

	[		
		"tp",
		0.45,
		randomSign,
		{	
			_crate = _this;			
			
			if (GW_CURRENTZONE == "globalZone") exitWith {};

			_vehicle = (vehicle player);
			_vehicle setVariable ['status', [], true];			

			_pos = (ASLtoATL getPosASL _vehicle);
			_newPos = GW_CURRENTZONE call findLocationInZone;

			playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _vehicle, false, (_pos), 2, 1, 150];
			playSound3D ["a3\sounds_f\sfx\earthquake1.wss", _vehicle, false, _pos, 10, 1, 150];

			[
				[
					_vehicle,
					3
				],
				"magnetEffect"
			] call bis_fnc_mp;

			_vehicle setPos _newPos;
			
		}
	],

	[		
		"tpto",
		0.7,
		randomSign,
		{	
			_crate = _this;			
			_vehicle = (vehicle player);
			_vehicle setVariable ['status', [], true];		

			_vehiclesInZone = [GW_CURRENTZONE, { (_this == (driver (vehicle _this))) }, true] call findAllInZone;

			_newPos = (getPos _vehicle);

			{
				if (_x != _vehicle) exitWith {
					_newPos = _x modelToWorldVisual [0, -40 + (random 10), 0];
				};

			} count _vehiclesInZone > 0;

			_pos = (ASLtoATL getPosASL _vehicle);
		
			playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _vehicle, false, (_pos), 2, 1, 150];
			playSound3D ["a3\sounds_f\sfx\earthquake1.wss", _vehicle, false, _pos, 10, 1, 150];

			[
				[
				_vehicle,
				3
				],
				"magnetEffect"
			] call bis_fnc_mp;

			if ((_newPos select 2) < 0) then { _newPos set [2, 0]; };
			_vehicle setPos _newPos;
			
		}
	],


	// [		
	// 	"emp",
	// 	0.7,
	// 	randomSign,
	// 	{	
	// 		_crate = _this;
	// 		_vehiclesInZone = [GW_CURRENTZONE, { (_this == (driver (vehicle _this))) }, true] call findAllInZone;

	// 		{
	// 			[       
	// 				[
	// 					_x,
	// 					"['emp']",
	// 					10
	// 				],
	// 				"addVehicleStatus",
	// 				_x,
	// 				false 
	// 			] call bis_fnc_mp; 	

	// 			false

	// 		} count _vehiclesInZone > 0;		

	// 	}
	// ],

	// [		
	// 	"damage", // not working right now
	// 	1.1,
	// 	damageSign,
	// 	{	
	// 		_crate = _this;
	// 		(vehicle player) setVariable ['status', [], true];

	// 		[
	// 			[
	// 				(vehicle player),
	// 				15,
	// 				[0.812,0.208,0.22,0.05]
	// 			],
	// 			"shieldEffect"
	// 		] call bis_fnc_mp;

	// 		[(vehicle player), ['extradamage'], 30] call addVehicleStatus;
	// 		['EXTRA DAMAGE', 30, damageSupplyIcon, { ("extradamage" in ((vehicle player) getVariable ['status', []])) }] spawn createNotification;
	// 	}
	// ],

	// [		
	// 	"speed",
	// 	0.5,
	// 	speedSign,
	// 	{	
	// 		_crate = _this;
	// 		_condition = { ("overcharge" in ((vehicle player) getVariable ['status', []])) };
	// 		_maxTime = 45;
	// 		_vehicle = (vehicle player);
	// 		_vehicle setVariable ['status', [], true];

	// 		[_vehicle, ['overcharge'], _maxTime] call addVehicleStatus;
	// 		[_vehicle, _maxTime, 'client\images\power_halo.paa', _condition, true, [0,0,0.5], false] spawn createHalo;
	// 		[_vehicle, 'client\images\vehicle_textures\fire\fire.jpg', _maxTime, _condition] spawn swapVehicleTexture;
	// 		['OVERCHARGE', _maxTime, speedSupplyIcon] spawn createNotification;
	// 	}
	// ],

	[		
		"armor",
		0.5,
		armorSign,
		{	
			_crate = _this;
			_condition = { ("nanoarmor" in ((vehicle player) getVariable ['status', []])) };
			_maxTime = 60;
			_vehicle = (vehicle player);
			_vehicle setVariable ['status', [], true];
			
			[_vehicle, ['nanoarmor'], _maxTime] call addVehicleStatus;
			[_vehicle, _maxTime, 'client\images\power_halo.paa', _condition, true, [0,0,0.5], false] spawn createHalo;
			[_vehicle, 'client\images\vehicle_textures\special\armor.jpg', _maxTime, _condition] spawn swapVehicleTexture;
			['MAXIMUM ARMOR', _maxTime, armorSupplyIcon, _condition] spawn createPowerup;
		}
	],

	[		
		"hsm",
		0.5,
		hsmSign,
		{	
			_crate = _this;
			_condition = { ("hsm" in ((vehicle player) getVariable ['status', []])) };
			_maxTime = 120;
			_vehicle = (vehicle player);
			_vehicle setVariable ['status', [], true];
			
			[_vehicle, ['hsm'], _maxTime] call addVehicleStatus;			

			['HUNTER SEEKER MISSILE', _maxTime, hsmSupplyIcon, _condition, 59, { 

				player say3D "beep_light";
				
				[GW_CURRENTVEHICLE, ['hsm']] call removeVehicleStatus;	

				// Launch hunter seeker server side
				[       
					[
						GW_CURRENTVEHICLE,
						GW_CURRENTZONE
					],
					"createHunterSeeker",
					false,
					false 
				] call bis_fnc_mp; 

				true 

			}] spawn createPowerup;
		}
	],

	[		
		"ems",
		0.5,
		empSign,
		{	
			_crate = _this;
			_condition = { ("ems" in ((vehicle player) getVariable ['status', []])) };
			_maxTime = 120;
			_vehicle = (vehicle player);
			_vehicle setVariable ['status', [], true];
			
			[_vehicle, ['ems'], _maxTime] call addVehicleStatus;			

			['EMP STRIKE', _maxTime, empSupplyIcon, _condition, 59, { 

				player say3D "beep_light";

				[GW_CURRENTVEHICLE, ['ems']] call removeVehicleStatus;	

				_vehiclesInZone = [GW_CURRENTZONE, { true }, true] call findAllInZone;

				{	

					if ((vehicle _x) == GW_CURRENTVEHICLE) then {} else {

						[       
							[
								(vehicle _x),
								"['emp']",
								10
							],
							"addVehicleStatus",
							(vehicle _x),
							false 
						] call bis_fnc_mp; 	

					};

					false

				} count _vehiclesInZone > 0;		
			

				true 

			}] spawn createPowerup;

		}
	],

	// {	
	// 		_crate = _this;
	// 		_vehiclesInZone = [GW_CURRENTZONE, { (_this == (driver (vehicle _this))) }, true] call findAllInZone;

	// 		{
	// 			[       
	// 				[
	// 					_x,
	// 					"['emp']",
	// 					10
	// 				],
	// 				"addVehicleStatus",
	// 				_x,
	// 				false 
	// 			] call bis_fnc_mp; 	

	// 			false

	// 		} count _vehiclesInZone > 0;		

	// 	}

	// [		
	// 	"radar",
	// 	0.5,
	// 	jammerSign,
	// 	{	
	// 		_crate = _this;
	// 		_condition = { ("radar" in ((vehicle player) getVariable ['status', []])) };
	// 		_maxTime = 90;
	// 		_vehicle = (vehicle player);
	// 		_vehicle setVariable ['status', [], true];

	// 		playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss", _vehicle, false, (ASLtoATL getposASL _vehicle), 2, 1, 150];
			
	// 		[_vehicle, ['radar'], _maxTime] call addVehicleStatus;
	// 		['RADAR ACTIVE', _maxTime, radarSupplyIcon, _condition] spawn createNotification;	

	// 	}
	// ],

	[		
		"explosive",
		0.85,
		randomSign,
		{	
			_crate = _this;
			_vehicle = (vehicle player);
			_pos = (getpos _vehicle);
			playSound3D ["a3\sounds_f\weapons\mines\electron_trigger_1.wss", _vehicle, false, _pos, 2, 1, 150]; 		
			createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "CAN_COLLIDE"];
		}
	],


	[		
		"nuke",
		0.95,
		nukeSign,
		{	

			_crate = _this;
			_vehicle = (vehicle player);
			_vehiclesInZone = [GW_CURRENTZONE, { (_this == (driver (vehicle _this))) }, true] call findAllInZone;

			{
				[		
					[
						_crate
					],
					"nukeEffect",
					_x,
					false
				] call bis_fnc_mp;				

				false

			} count _vehiclesInZone > 0;

			// Simulate fallout
			GW_CURRENTZONE spawn {

				for "_i" from 0 to (random 20) do {

					_vehiclesInZone = [_this, { (_this == (driver (vehicle _this))) }, true] call findAllInZone;

					{
						if (alive _x) then {
							_dmg = getDammage _x;
							_x setDammage (_dmg + (random 0.05));
							_x call updateVehicleDamage;
						};

					} count _vehiclesInZone > 0;

					Sleep (0.5 + random 1);

				};

			};

		}
	]	

];
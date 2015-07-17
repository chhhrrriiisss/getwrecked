//
//      Name: createSupplyDrop
//      Desc: Spawns a supply box (ammo, fuel, repair, random) at the designated location (optionally parachute in)
//      Return: None
//

private ['_pos', '_para', '_source', '_part', '_spawnedItems'];

#define PALLETZ (1.47119/2)
#define PALLETY (1.52834/2)
#define PALLETX (0.191184/2)
#define GAP 0.11

_pos = [_this,0, [0,0,0], [[]]] call filterParam;
_para = [_this,1,false,[false]] call filterParam;
_type = [_this,2,"",[""]] call filterParam;

if (_pos distance [0,0,0] < 100) exitWith {};
if (GW_SUPPLY_ACTIVE >= GW_SUPPLY_MAX) exitWith {};

_spawnedItems = [];

if (_para) then {
	_pos set [2, (random 250) + 70];
};

// Position config for the supply box
_supplyBoxFormat = [

	[ [0, 0, 0], [0, 0, 0],  "" ], // middle
	[ [0, (- PALLETY - 0.1), 0], [0,0,180], "" ], // left 
	[ [0, (PALLETY + 0.1) , 0], [0,0,0],  "" ], // right
	[ [(- PALLETY - GAP), 0, 0], [0,0,-90],  "" ], // front
	[ [(PALLETY + GAP), 0, 0], [0,0,90],  "" ], // back
	[ [0, 0, (PALLETZ + GAP)], [90, 0, 0],  "" ], // top
	// [ [0, 0, -(PALLETZ - GAP)], [90, 0, 0],  "" ], // bottom
	[ [0, (- PALLETY - 0.22), 0.5 + (PALLETZ / 3)], [0,0,0], "icon" ], // tx a 
	[ [0, (PALLETY + 0.22) , 0.5 + (PALLETZ / 3)], [0,0,180], "icon" ] // tx b	

];

// Find a type of loot of the rarity specified
findBoxType = {
	
	private ['_reqValue', '_rnd', '_chance', '_return'];

	_reqValue = _this;

	_rnd = round ( random (count GW_SUPPLY_TYPES - 1) );

	_box = (GW_SUPPLY_TYPES select _rnd);
	_chance = _box select 1;
	_return = [_rnd, _box select 2];

	if (_chance > _reqValue) then {

		// Increase value slightly so guaranteed to find something eventually
		_reqValue = _reqValue + 0.01;
		_return = _reqValue call findBoxType;

	};

	_return

};

// Cleanup Function for supply boxes
supplyBoxCleanup = {

	_explode = [_this,1, true, [false]] call filterParam;

	GW_SUPPLY_ACTIVE = GW_SUPPLY_ACTIVE - 1;
	GW_SUPPLY_ACTIVE = if (GW_SUPPLY_ACTIVE < 0) then { 0 } else { GW_SUPPLY_ACTIVE };
	_parts = (_this select 0) getVariable ['GW_Parts', []];

	[
		[
			(_this select 0),
			0.5
		],
		"dustCircle"
	] call bis_fnc_mp;


	_parts spawn { 
		Sleep 10;
		{ deleteVehicle _x; } count _this > 0;
	};	
	
	{ if (typeOf _x == "UserTexture1m_f") then { deleteVehicle _x; }; _x removeEventHandler ["EpeContactStart", 0]; _x removeEventHandler ["hit", 0]; } count _parts > 0;

	true
};

// Get a random type of supply box
_supplyContents = if (count toArray _type == 0) then { (((random 100) / 100) call findBoxType) } else {
	
	// Loop through and find matching type
	_arr = [];
	{ if ((_x select 0) == _type) exitWith {	_arr = [_foreachindex, (_x select 2)];	}; } Foreach GW_SUPPLY_TYPES;
	_arr
};

// Abort if nothing found
if (_supplyContents isEqualTo []) exitWith {};

// 15% chance of mystery icon
_rnd = random 100;
if (_rnd > 85 && (count toArray _type == 0) && (_supplyContents select 0) != ((count GW_SUPPLY_TYPES) -1)) then {
	_supplyContents set[1, randomSign];
};

{

	_p = (_pos vectorAdd (_x select 0));

	_class = (_x select 2) call {
		if (_this == "") exitWith { "Land_Pallet_vertical_F" };
		if (_this == "icon") exitWith { "UserTexture1m_F" };
		if (_this == "tx") exitWith { "UserTexture10m_F" };

		_this
	};

	_part = createVehicle [_class, (_pos vectorAdd (_x select 0)), [], 0, 'CAN_COLLIDE'];

	// If it's a smoke
	if ( (_x select 2) == "smoke") then {		
		_part attachTo [(_spawnedItems select 0)];
	};

	// If it's a icon
	if ( (_x select 2) == "icon") then {		
		_part setObjectTextureGlobal [0, (_supplyContents select 1)];
		_part attachTo [(_spawnedItems select 0)];
		[_part, (_x select 1) ] call setPitchBankYaw;
	};

	// If it's not the source block or texture
	if (_forEachIndex > 0 && (_x select 2) == "") then {

		_source = (_spawnedItems select 0);
		_pitchBank = (_x select 1);	
		_srcPitchBank = _source call BIS_fnc_getPitchBank;

		_tarDir = [((_pitchBank select 2) - (getDir _source))] call normalizeAngle;
		_tarPitch = [((_pitchBank select 0) - (_srcPitchBank select 0))] call normalizeAngle;
		_tarBank = [((_pitchBank select 1) - (_srcPitchBank select 1))] call normalizeAngle;

		_part attachTo [(_spawnedItems select 0)];
		[_part, [_tarPitch,_tarBank,_tarDir]] call setPitchBankYaw;

		pubVar_setDir = [_part, getDir _part];
		publicVariable "pubVar_setDir";  
	} else {
		_part enableSimulationGlobal false;
	};

	_spawnedItems pushback _part;

} Foreach _supplyBoxFormat;

// Add event handlers to source block
_source = (_spawnedItems select 0);

GW_SUPPLY_ACTIVE = GW_SUPPLY_ACTIVE + 1;

_source setDir (random 360);

{

	if (typeOf _x != "UserTexture1m_F") then {

		_x setVariable ['GW_Parts', _spawnedItems];
		_x setVariable ['GW_SupplyType', (_supplyContents select 0)];

		_x addEventHandler['Explosion', {
			[(_this select 0), true] call supplyBoxCleanup;
		}];

		_x addEventHandler['EpeContactStart', {		
			
			_isVehicle = (_this select 1) getVariable ["isVehicle", false];
			_type = (_this select 0) getVariable ['GW_SupplyType', nil];	

			if (_isVehicle && !isNil "_type") then {

				_parts = (_this select 0) getVariable ['GW_Parts', []];							
				(_this select 0) setVariable ['GW_SupplyType', nil];

				[(_this select 0), false] call supplyBoxCleanup;				
				
				_vel = velocity (_this select 1);
				_dir = getDir (_this select 1);
				_speed = (_this select 4) / 12;

				[[(_this select 1),[(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),(_vel select 2)]],"setVelocityLocal",(_this select 1),false ] call bis_fnc_mp;  

				[		
					[(_this select 0), _type],
					"supplyDropEffect",
					(_this select 1),
					false
				] call bis_fnc_mp;				
				
			};

		}];

	};

	false
} count _spawnedItems > 0;

_para = createVehicle ["I_parachute_02_F", [0,0,0], [], 0, "FLY"];
_para addEventHandler['handleDamage', { false }];
_para attachTo [_source, [0,0,1]];
_para setVectorUp [0,0,1];

// Tidy up and particle effects
0 = [_source, _para] spawn { 
	
	Sleep 0.5;
	(_this select 0) enableSimulationGlobal true;
	
	params ['_s', '_ps'];

	_timeout = time + 20;
	waitUntil {
		(  (((getPos _s) select 2) < 10) || time > _timeout)
	};

	detach _ps;
	playSound3D ["a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss", _s, false, (getPos _s), 2, 1, 60];      

	_ps spawn { 
		Sleep 30;
		deleteVehicle _this;
	};

	_timeout = time + 20;
	waitUntil {
		(  (((getPos _s) select 2) < 0.5) || time > _timeout)
	};	
	
	playSound3D ["a3\sounds_f\sfx\vehicle_drag_end.wss", _s, false, getPos _s, 2, 1, 60];

	[
		[
			_s,
			0.5
		],
		"dustCircle"
	] call bis_fnc_mp;

	[
		[
			_s,
			45,
			[0.992,0.463,0.141,1],
			1,
			5
		],
		"smokeEffect"
	] call bis_fnc_mp;

	_p = getPos _s;
	_p set [2,0];
	_normal = surfaceNormal _p;
	_s setVectorUp _normal;
	_s setPos _p;

	Sleep 0.5;

	{ if (typeOf _x != "UserTexture1m_F") then { detach _x; }; false } count (attachedObjects _s) > 0;

	

};

// Timeout cleanup script
0 = _source spawn {	
	Sleep GW_SUPPLY_CLEANUP;
	if (alive _this) exitWith {
		[_this, true] call supplyBoxCleanup;
	};
};

if (true) exitWith {};


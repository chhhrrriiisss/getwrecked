/*

	Object Setup

*/

if (!isServer) exitWith {};

#define ABANDON_DELAY 3
#define DEAD_DELAY .5

#define VARIANCE_X 15
#define VARIANCE_Y 15

// Find a type of loot of the rarity specified
findLoot = {

	private ['_value', '_loot', '_lootValue', '_return'];

	_value = _this select 0;

	_rnd = round ( random (count GW_LOOT_LIST - 1) );
	_loot = (GW_LOOT_LIST select _rnd);
	_lootValue = _loot select 8;
	_return = _loot select 0;

	// Ignore weapon holder weapons as they dont spawn correctly
	if (_lootValue > _value || (_loot select 0) in GW_HOLDERARRAY) then {

		// Increase value slightly so guaranteed to find something eventually
		_value = _value + 0.005;
		_return = [_value] call findLoot;

	};

	_return

};

// Generate loot in random positions
populateLoot = {

	private ['_pos'];

	_pos = _this select 0;

	_rndAmount = (random 15) + 15;

	for "_i" from 0 to _rndAmount step 1 do {

		_rndX = (random VARIANCE_X) - (VARIANCE_X/2);	
		_rndY = (random VARIANCE_Y) - (VARIANCE_Y/2);
		
		// Get a random direction
		_rndDir = random 360;

		// Get a random position
		_rndPos = [(_pos select 0) + _rndX, (_pos select 1) + _rndY, _pos select 2];

		// Create the loot object
		_o = [_rndPos, _rndDir, '', 0, "CAN_COLLIDE", false] call createObject; 	

		_o setVariable ['GW_CU_IGNORE', true];

	};
};

setupLoot = {	

	for "_i" from 0 to 100 step 1 do {

		_str = format['%1_%2', 'loot_spawn', _i];
		_pos = getMarkerPos _str;

		if (_pos distance [0,0,0] <= 0) then {} else {
			[_pos] spawn populateLoot;
		};

	};	

	true

};

[] call setupLoot;

true
//
//      Name: iniObjects
//      Desc: Creates a random amount of objects in scrap piles on server init
//      Return: None
//


if (!isServer) exitWith {};

#define ABANDON_DELAY 3
#define DEAD_DELAY .5

#define VARIANCE_X 15
#define VARIANCE_Y 15

// Find a type of loot of the rarity specified
findLoot = {

	private ['_value', '_loot', '_lootValue', '_class'];
	params ['_value'];

	_rnd = round ( random (count GW_LOOT_LIST - 1) );
	_loot = (GW_LOOT_LIST select _rnd);
	_lootValue = _loot select 8;
	_class = _loot select 0;

	// Ignore weapon holder weapons as they dont spawn correctly
	if (_lootValue > _value || _class in GW_HOLDERARRAY) then {

		// Increase value slightly so guaranteed to find something eventually
		_value = _value + 0.005;
		_class = [_value] call findLoot;

	};

	_class

};

// Generate loot in random positions
populateLoot = {

	params ['_pos'];

	_rndAmount = (random 15) + 15;

	for "_i" from 0 to _rndAmount step 1 do {

		_rndX = (random VARIANCE_X) - (VARIANCE_X/2);	
		_rndY = (random VARIANCE_Y) - (VARIANCE_Y/2);
		
		// Get a random direction
		_rndDir = random 360;

		// Get a random position
		_rndPos = [(_pos select 0) + _rndX, (_pos select 1) + _rndY, _pos select 2];

		// Create the loot object
		_o = [_rndPos, '',  _rndDir, 0, "CAN_COLLIDE", false] call createObject; 	

		_o setVariable ['GW_CU_IGNORE', true];

	};
};

setupLoot = {	
	
	for "_i" from 0 to (count allMapMarkers) step 1 do {	
		
		_point = getMarkerPos (format['%1_%2', 'lootSpawn', _i]);
		_invalid = _point isEqualTo [0,0,0];

		if (!_invalid) then { [_point] spawn populateLoot;	};

	};

	true

};

[] call setupLoot;

true
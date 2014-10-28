/*

	Object Setup

*/

if (!isServer) exitWith {};

#define ABANDON_DELAY 3
#define DEAD_DELAY .5

#define VARIANCE_X 15
#define VARIANCE_Y 15

spawnedList = [];

addToList = {

	_val = _this select 0;

	spawnedList = spawnedList + [_val];

};

// Find a type of loot of the rarity specified
findLoot = {

	_value = _this select 0;

	_rnd = round ( random (count GW_LOOT_LIST - 1) );

	_loot = (GW_LOOT_LIST select _rnd);
	_lootValue = _loot select 8;

	_return = _loot select 0;

	if (_lootValue > _value) then {

		// Increase value slightly so guaranteed to find something eventually
		_value = _value + 0.005;
		_return = [_value] call findLoot;

	};

	[_lootValue] spawn addToList;
	_return

};

// Generate loot in random positions
populateLoot = {

	_pos = _this select 0;

	_rndAmount = (random 20) + 20;

	for [{_i=0},{_i<=_rndAmount},{_i=_i+1}] do {

		//_rnd = round ( random (count GW_LOOT_LIST - 1) );

		_rndX = (random VARIANCE_X) - (VARIANCE_X/2);	
		_rndY = (random VARIANCE_Y) - (VARIANCE_Y/2);

		// Get a random direction
		_rndDir = random 360;

		// Get a random position
		_rndPos = [(_pos select 0) + _rndX, (_pos select 1) + _rndY, _pos select 2];

		// Create the loot object
		[_rndPos, _rndDir, '', 0, "CAN_COLLIDE", true] spawn createObject; 

		// Create a respawn handler for it
		//[_obj, ABANDON_DELAY, DEAD_DELAY] execVM 'server\object_respawn.sqf';
		

	};
};

setupLoot = {	

	for "_i" from 0 to 300 step 1 do {

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
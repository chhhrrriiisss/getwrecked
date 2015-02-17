/*
	
	createObject


*/

private ['_pos', '_dir', '_type', '_cycle', '_collide', '_handlers'];

_pos = _this select 0;
_dir = _this select 1;
_type = _this select 2;
_cycle = _this select 3; // Chance of new loot spawning    
_collide = _this select 4;
_handlers = _this select 5;

_isHolder = if (_type in GW_HOLDERARRAY) then { true } else { false };

if (isNil "_type") then { // If not specified, create a random
    _type = '';
};

if (isNil "_cycle") then { // Dont cycle it
    _cycle = 0;
};

if (isNil "_collide") then {
	_collide = "NONE";
};

_rnd = random 100;

if ( (_rnd < _cycle) || _type == '') then {
    _rndValue = random 100;
    _type = [ (_rndValue / 100) ] call findLoot;
};

_newObj = nil;

// It's a weapon holder object
if (_isHolder) then {

	_holder = nil;
	_holder = createVehicle ["groundWeaponHolder", _pos, [], 0, 'CAN_COLLIDE']; // So it doesnt collide when spawned in]
	
	if ( isClass (configFile >> "CFGWeapons" >> _type)) then {
		_holder addWeaponCargoGlobal [_type, 1];
	} else {
		_holder addMagazineCargoGlobal [_type, 1];	
	};

	_holder setVariable ["type", _type, true];
	removeAllActions _holder;
	_newObj = _holder;

};


if (!_isHolder) then {
	
   	_newObj = createVehicle [_type, _pos, [], 0, _collide]; // So it doesnt collide when spawned in]   

   	clearMagazineCargo _newObj;
	clearWeaponCargo _newObj;
	clearItemCargoGlobal _newObj;	
	
};

if (isServer) then { 

	_newObj enableSimulationGlobal false; 

} else {
	
	[		
		[
			_newObj,
			false
		],
		"setObjectSimulation",
		false,
		false 
	] call BIS_fnc_MP;
};


_newObj setDir _dir;
if (_handlers) then { 
	[_newObj] call setObjectHandlers; 
};
	
if (!isServer) exitWith {
	_newObj
};

[_newObj] spawn setObjectData;


_newObj




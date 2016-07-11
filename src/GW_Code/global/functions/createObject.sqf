//
//      Name: createObject
//      Desc: Create a get wrecked item and apply object data
//      Return: None
//

private ['_pos', '_dir', '_type', '_cycle', '_collide', '_handlers', '_data'];

_pos = [_this, 0, [0,0,0], [[]]] call filterParam;
_type = [_this, 1, '', ['']] call filterParam;
_dir = if (isNil "_dir") then { 0 } else { (_this select 2) };

_cycle = [_this, 3, 0, [0]] call filterParam;
_collide = [_this, 4, "NONE", [""]] call filterParam;
_handlers = [_this, 5, true, [false]] call filterParam;

_isHolder = if (_type in GW_HOLDERARRAY) then { true } else { false };

_rnd = random 100;

if ( (_rnd < _cycle) || _type == '') then {  _rndValue = random 100;  _type = [ (_rndValue / 100) ] call findLoot; };

_newObj = nil;

// It's a weapon holder object
if (_isHolder) then {

	_holder = createVehicle ["groundWeaponHolder", _pos, [], 0, 'CAN_COLLIDE']; // So it doesnt collide when spawned in]	
	if ( isClass (configFile >> "CFGWeapons" >> _type )) then { _holder addWeaponCargoGlobal [_type, 1]; } else { _holder addMagazineCargoGlobal [_type, 1]; };
	_holder setVariable ['GW_Tag', _type, true];
	removeAllActions _holder;
	_newObj = _holder;
};

if (!_isHolder) then {
	_newObj = createVehicle [_type, _pos, [], 0, _collide];
	if (_dir isEqualType []) then { [_newObj, _dir] call setPitchBankYaw; } else { _newObj setDir _dir; };
};


if (isServer) then { 
	[_newObj] call setupObject;
} else {
	
	[		
		[
			_newObj
		],
		"setupObject",
		false,
		false 
	] call bis_fnc_mp;
};

if (_handlers) then { 

	// Remote trigger event handlers for this object
	if (!isServer) then {

		[		
			[
				_newObj
			],
			"setObjectHandlers",
			false,
			false 
		] call bis_fnc_mp;

	};

	// Add local handlers wherever it is local
	[		
		[
			_newObj
		],
		"setObjectHandlers",
		_newObj,
		false 
	] call bis_fnc_mp;
};

_newObj




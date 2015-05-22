//
//      Name: handleGetIn
//      Desc: Handler for jumping in vehicles
//      Return: None
//

private ['_vehicle', '_position', '_unit'];

_vehicle = [_this,0,objNull, [objNull]] call filterParam;
_position = [_this,1,"", [""]] call filterParam;
_unit = [_this,2,objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith {};
if (isNull _unit) exitWith {};

// If we're a passenger and driver is vacant, move to slowly
if ( _position != "driver" ) then {
	_unit action ["eject", _vehicle];
	_unit action ["getInDriver", _vehicle];
};

// Still compiling? get out quick man!
if (GW_WAITCOMPILE) exitWith {
	_unit action ["eject", _vehicle];
};	

_null = [_vehicle] call compileAttached;

// Set ourselves as the owner
_playerName = if (isNull player) then { "" } else { (name player) };
_vehicle setVariable ["GW_Owner", _playerName, true];

// Are we missing handlers? Add them!
_hasHandlers = _vehicle getVariable ['hasHandlers', false];
if (!_hasHandlers) then { [_vehicle] call setVehicleHandlers; };

_attached = attachedObjects _vehicle;

if (count _attached <= 0) exitWith {};

{
    _x setVariable ["GW_Owner", _playerName, true];    
	_hasActions = _x getVariable ["hasActions", false];	
	_hasHandlers = _x getVariable ["hasHandlers", false];	
	_hasData = if (isNil { _x getVariable "GW_Data" }) then { false } else { true };
	_isObject = _x call isObject; 

	if (_isObject && !_hasData) then { [_x] call setObjectProperties; };

	if (!_hasHandlers) then {
		if (_isObject) then {
			[_x] call setObjectHandlers;
		};		
	};	
	false
} count (attachedObjects _vehicle) > 0;	

_meleeEnabled = _vehicle getVariable ['GW_MELEE', false];
_hasMelee = _vehicle call hasMelee;
if (_hasMelee && !_meleeEnabled) then {
	_vehicle call meleeAttached;
};

// Set prevVeh reference on player (for stats tracking)
_name = _vehicle getVariable ['name', nil];
if (!isNil "_name") then { _unit setVariable ['GW_prevVeh', _name]; };
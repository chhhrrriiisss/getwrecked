//
//      Name: validNearby
//      Desc: Checks in specified radius for valid GW vehicles, optionally check it's also in scope (visible)
//      Return: Bool (Found)
//

private ['_source', '_range', '_scope', '_found'];

_source =  [_this, 0, objNull, [objNull]] call filterParam;
_range = [_this, 1, 15, [0]] call filterParam;
_scope = [_this, 2, 90, [0]] call filterParam;

_found = nil;

if (isNull _source) exitWith { nil };

_pos = (ASLtoATL (getPosASL _source));
_nearby = _pos nearEntities [["Car"], _range];

if (count _nearby == 0) exitWith { nil };

{
	_isVehicle = _x getVariable ["isVehicle", false];
	_isOwner = [_x, player, false] call checkOwner;
	if (_isVehicle && _isOwner) exitWith {	_found = _x; };
	false
} count _nearby > 0;

if (isNil "_found") exitWith { nil };
if (_scope <= 0 && !isNil "_found") exitWith { _found };

// Check it's visible to the player's camera (optional)
_inScope = [player, _found, _scope] call checkScope;
if (!_inScope) exitWith { nil };
	
_found
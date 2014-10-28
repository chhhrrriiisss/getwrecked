//
//      Name: checkOwner
//      Desc: Determines if the object is owner by the player (and takes ownership if requested)
//      Return: Bool 
//

private ['_obj', '_unit', '_makeOwner', '_owner'];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_unit = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _unit) exitWith { false };

// Optionally take ownership if it's unowned
_makeOwner = [_this,2, true, [false]] call BIS_fnc_param;

_owner = _obj getVariable ['owner', ''];

// No owner, take ownership
if (_owner == '' && _makeOwner) exitWith { 
	_obj setVariable ['owner', (name _unit), true];	
	true
};

// No owner, dont take ownership	
if (_owner == '' && !_makeOwner) exitWith { true }; 

// Has owner, not ours	
if (_owner != (name _unit)) exitWith { false }; 

// Has owner, ours
if (_owner == (name _unit)) exitWith { true }; 

// Default, not the owner
false 


//
//      Name: checkNearbyOwnership
//      Desc: Checks for any objects not owned by the player in vicinity
//      Return: Bool (Do we own everything?)
//

private ['_t', '_r', '_p'];
	
_t = [_this,0,objNull,[[], objNull]] call filterParam;
_r = [_this,1,1,[0]] call filterParam;

_p = if (typename _t == "OBJECT") then { (ASLtoATL visiblePositionASL _t) } else { _t };

_objs = nearestObjects [_p, [], _r];
if (count _objs == 0) exitWith { true };

_ownedByAnother = false;
_ownedByMe = false;

{
	_currentOwner = if (isNull attachedTo _x) then {
		// Ignore supply boxes so the pads can be cleared
		if (_x call isSupplyBox) exitWith { '' };
		(_x getVariable ['GW_Owner', ''])
	} else {
		if (isPlayer (attachedTo _x)) exitWith { (name (attachedTo _x)) };
		((attachedTo _x) getVariable ['GW_Owner', ''])
	};

	if (count toArray _currentOwner == 0) then {} else {
		if (_currentOwner != name player) then { _ownedByAnother = true; };
		if (_currentOwner == name player) then { _ownedByMe = true; };
	};

	false
} count _objs > 0;

// No owners anywhere or we are the only owner
if ( (!_ownedByAnother && !_ownedByMe) || (!_ownedByAnother && _ownedByMe) ) exitWith { true };

// Someone else owns something and we dont
if (_ownedByAnother && !_ownedByMe) exitWith { false };

// Default, no owners
true

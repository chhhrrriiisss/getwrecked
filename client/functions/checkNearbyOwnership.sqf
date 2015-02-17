//
//      Name: checkNearbyOwnership
//      Desc: Checks for any objects not owned by the player in vicinity
//      Return: Bool (Do we own everything?)
//

private ['_t', '_r', '_p'];
	
_t = [_this,0,objNull,[[], objNull]] call BIS_fnc_param;
_r = [_this,1,1,[0]] call BIS_fnc_param;

_p = if (typename _t == "OBJECT") then { (ASLtoATL getPosASL _t) } else { _t };

_objs = nearestObjects [_p, [], _r];
if (count _objs == 0) exitWith { true };


_ownedByAnother = false;
_ownedByMe = false;

{
	_isOwner = _x getVariable ['owner', ''];

	if (count toArray _isOwner == 0) then {} else {

		if (_isOwner != GW_PLAYERNAME) then {
			_ownedByAnother = true;
		};

		if (_isOwner == GW_PLAYERNAME) then {
			_ownedByMe = true;
		};
	};

	false
} count _objs > 0;

// No owners anywhere or we are the only owner
if ( (!_ownedByAnother && !_ownedByMe) || (!_ownedByAnother && _ownedByMe) ) exitWith { true };

// Someone else owns something and we dont
if (_ownedByAnother && !_ownedByMe) exitWith { false };

// Default, no owners
true

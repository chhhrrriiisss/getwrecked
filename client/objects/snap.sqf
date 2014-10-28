//
//      Name: snapObj
//      Desc: Determines if the object should be snapped to points returned from findSnapPoint
//      Return: None
//

private ['_origPos', '_origObj', '_origDir'];

_origPos = _this select 0;
_origObj = _this select 1;
_origDir = getDir _origObj;

_final = [_origPos, _origObj] call findSnapPoint;

_snappedPos = false;
_snappedDir = false;

if (isNull attachedTo _origObj) then {

	_finalPos = _final select 0;
	_finalDir = _final select 1;

	// If the direction is not already there, set it
	if (_origDir != _finalDir) then {
		_origObj setDir _finalDir;
		_snappedDir = true;
	};

	// If the distance from the snapped point is to great, set it
	if ( (_origPos distance _finalPos) > 0) then {
		_origObj setPosASL _finalPos;
		_snappedPos = true;
	};

	// If there was no point snap, go to normal position
	if (!_snappedPos) then {	
		_origObj setPosASL _origPos;
	};

};

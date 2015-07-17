//
//      Name: snapObj
//      Desc: Determines if the object should be snapped to points returned from findSnapPoint
//      Return: None
//

private ['_origPos', '_origObj', '_origDir', '_unit'];
params ['_origObj', '_unit'];

_origPos = _origObj modelToWorldVisual [0,0,0];
_origDir = [ (getDir _origObj - getDir _unit)] call normalizeAngle;

_result = [_origPos, _origObj] call findSnapPoint;


_snappedPos = false;
_snappedDir = false;

if (isNull (attachedTo _origObj)) exitWith {};

_resultPos = _result select 0;
_resultDir = _result select 1;

// If the direction is not already there, set it
if (_origDir != _resultDir) then {
	systemchat format['snap to direction: %1', _resultDir];
	_origObj setDir ([ (getDir _unit) - _resultDir] call normalizeAngle);
	_snappedDir = true;
};

// // If the distance from the snapped point is to great, set it
// if ( (GW_EDITING_TARGET distance _resultPos) > 0) then {
// 	GW_EDITING_TARGET = _unit worldToModelVisual (ASLtoATL _resultPos);
// 	_snappedPos = true;
// };

// // If there was no pointsnap, go to normal position
// if (!_snappedPos) then {	
// 	_origObj setPosASL _origPos;
// };

//
//      Name: findSnapPoint
//      Desc: Determines if an object should be snapped to another nearby of the same type (position and also direction)
//      Return: Array [Resulting Position, Resulting Direction]
//

private ['_currentPos', '_currentObj', '_currentDir', '_resultPos', '_resultDir'];

_currentPos = [_this,0, [], [[]]] call filterParam;
_currentObj = [_this,1, objNull, [objNull]] call filterParam;

// if (count _currentPos == 0 || isNull _currentObj ) exitWith { [[0,0,0] ,0] };

_currentDir = getDir _currentObj;
_resultPos = _currentPos;
_resultDir = _currentDir;

// Any valid vehicles nearby?
_nearby = (ASLtoATL _currentPos) nearEntities [["Car", "Tank"], 8];
if (count _nearby <= 0) exitWith { [_resultPos, _resultDir] };

_isVehicle = false;
_currentVehicle = nil;
{
	_isVehicle = _x getVariable ["isVehicle", false];
	if (_isVehicle) exitWith { _currentVehicle = _x; };
	false
} count _nearby > 0;

if (!_isVehicle || isNil "_currentVehicle") exitWith { [_resultPos, _resultDir] };

// Any valid objects of the same type nearby?
_type = typeOf _currentObj;
_validObjects = [];
{
	// Same type and something attached to it
	if (typeOf _x == _type) then {
		_validObjects pushBack _x;
	};	
} Foreach (attachedObjects _currentVehicle);

// Ok, lets get generating some points
_validPoints = [];
{

	if (!isNil "_x") then {

		_oPos = getPosASL _x;	
		_oDir = getDir _x;

		_dimensions = [_x] call getBoundingBox;		
		_length = _dimensions select 0;
		_width = _dimensions select 1;
		_height = _dimensions select 2;

		// Above & Below
		_pointAbove = [(_oPos select 0), (_oPos select 1) , (_oPos select 2) + _height];
		_pointBelow = [(_oPos select 0), (_oPos select 1) , (_oPos select 2) - _height];

		// Left & Right
		_pointLeft = [_oPos, _width, _oDir] call relPos;
		_pointRight = [_oPos, -_width, _oDir] call relPos;

		// Ahead & Behind
		_aDir = [_oDir + 90] call normalizeAngle;
		_pointAhead = [_oPos, _length, _aDir] call relPos;
		_pointBehind = [_oPos, -_length, _aDir] call relPos;

		// Mirror Point (opposite side of vehicle)
		_mDist = (_oPos) distance (getPosASL _currentVehicle);
		_dirTo = [_currentVehicle, _x] call dirTo;
		_vehDir = getDir _currentVehicle;
		_dif = [(_vehDir - _dirTo)] call normalizeAngle;
		_actual = [ ((_vehDir) - (_dif * -1)) ] call normalizeAngle;
		_mirror = [_currentVehicle, _mDist, _actual] call relPos;
		_pointMirror = [_mirror select 0, _mirror select 1, _oPos select 2];

		// Add the points to the array
		_validPoints pushBack [_pointAbove, _x, 'normal'];
		_validPoints pushBack [_pointBelow, _x, 'normal'];

		_validPoints pushBack [_pointLeft, _x, 'normal'];
		_validPoints pushBack [_pointRight, _x, 'normal'];

		_validPoints pushBack [_pointAhead, _x, 'normal'];
		_validPoints pushBack [_pointBehind, _x, 'normal'];

		_validPoints pushBack [_pointMirror, _x, 'mirror'];

	};

} Foreach _validObjects;

// Loop through valid points to find ones that match
_foundSnap = false;
{
	_tolerance = 0.5;
	_point = _x select 0;
	_obj = _x select 1;	
	_pointType = _x select 2; // Mirror, above, behind etc
	_dist = _point distance _currentPos;

	if (_dist < _tolerance && !isNull attachedTo _obj) exitWith {
		_foundSnap = true;
		_resultPos = _point;
		_dir = getDir _obj;	

		// Try and match up direction for non-mirror points
		if (_pointType == 'mirror') then {} else {

			if (_currentDir != _dir) then {		
				_diff = [ abs (_dir - _currentDir) ] call normalizeAngle;	
				if ( _diff < 10 ) then { _resultDir = _dir;	};
				if ( _diff > 170) then { _resultDir = [_dir] call flipDir;	};
			};
		};		
	};

} ForEach _validPoints;

_foundSnap = false;

// If there was no snap point, try snap vehicle direction instead
if (!_foundSnap) then {

	_frontDir = (getDir _currentVehicle);
	_sideDir = [(_frontDir + 90)] call normalizeAngle;
	_forwardCornerDir = [(_frontDir + 45)] call normalizeAngle;
	_rearCornerDir = [(_frontDir - 45)] call normalizeAngle;

	if (_currentDir != _frontDir || _currentDir != _sideDir || _currentDir != _rearCornerDir || _currentDir != _forwardCornerDir) then {

		// Which side are we on?
		_dirTo = [_currentVehicle, _currentObj] call dirTo;
		_dif = [_frontDir - _dirTo] call flattenAngle;

		_side = if (_dif < 0) then { "right" } else { "left" };
		_dirTo = abs (_dif);

		// Front of vehicle
		if (_dirTo > 157.5 || _dirTo < 22.5) exitWith {
			_resultDir = _frontDir;	
		};

		// Corner of Vehicle
		if (_dirTo >= 35  && _dirTo <= 55) exitWith {
			_resultDir = if (_side == 'right') then { _forwardCornerDir } else { _rearCornerDir };
		};		

		if (_dirTo >= 125  && _dirTo <= 145) exitWith {
			_resultDir = if (_side == 'right') then { _rearCornerDir } else { _forwardCornerDir };
		};

		// Side of Vehicle
		if (_dirTo <= 157.5 || _dirTo >= 22.5) exitWith {
			_resultDir = _sideDir;
		};
	
	};

};

[_resultPos, _resultDir]
//
//      Name: grabObj
//      Desc: Pick up an item and carry it with the player
//      Return: Bool
//

private ['_obj', '_unit', '_type'];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_unit = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _unit) exitWith {};

// We're now officially editing
GW_EDITING = true;

// If the object isn't local, let's take ownership to improve performance
if (!local _obj) then {

	[
		[_obj, _unit],
		'setObjectOwner',
		false,
		false
	] call bis_fnc_mp;	

	_timeout = time + 2;
	waitUntil {(local _obj || time > _timeout)};

};
	
// Used by some actions to target the current object we're editing
_unit setVariable ['GW_EditingObject', _obj];

// If a snapping state hasnt been set, default to false
if (isNil { _unit getVariable 'snapping' }) then {	_unit setVariable ['snapping', false]; };

// Used to dynamically change the loop period depending if snapping is active
_moveInterval = 0.005;
_snappingInterval = 0.05;

GW_EDITING_TARGET = if (isNull attachedTo _obj) then {
	_d = _obj distance _unit;
	[0, _d, 0]
} else {
	_unit worldToModelVisual (_obj modelToWorldVisual [0,0,0]);
};

GW_EDITING_TARGET set [2, ([(GW_EDITING_TARGET select 2), 0, 10] call limitToRange)];

_obj setVariable ['GW_relDirection', (getDir _obj)];

GW_EDITING_DIRECTION = _obj call BIS_fnc_getPitchBank;
_objVector = ([_obj, _unit] call getVectorDirAndUpRelative);
_obj attachTo [_unit, GW_EDITING_TARGET];

// Wait for the object to be attached to the player
_timeout = time + 3;
waitUntil {
	_attached = if (!isNull attachedTo _obj) then { if ((attachedTo _obj) isEqualTo _unit) exitWith { true }; false } else { false };
	(_attached || (time > _timeout))
};

// Restore object orientation post-attach
_objVector set [1, [0,0,1]];
[_obj, _objVector] call setVectorDirAndUpTo;

_distance = [ (positionCameraToWorld [0,0,0] distance (getpOS _OBJ)), 1, 8] call limitToRange;
_objHeight = ([_obj] call getBoundingBox) select 2;

for "_i" from 0 to 1 step 0 do {

	if (!alive _unit || !alive _obj || !GW_EDITING || _unit != GW_CURRENTVEHICLE) exitWith {};

	_attachPosition = positionCameraToWorld [0,0,_distance];

	// Make sure position doesn't go below ground
	_attachPosition set [2, [(_attachPosition select 2), 0, 10] call limitToRange ];

	ATTACH_POS = [_attachPosition, _objHeight];

	_snapping = _unit getVariable ['snapping', false];	

	if (true) then {

		if (!_snapping) exitWith {};   

		_targetVehicle = ([_unit, 12, 180] call validNearby);
		if (isNil "_targetVehicle") exitWith {};

		_class = typeOf _obj;
		_currentPosition = +_attachPosition;
		_currentPosition = (AGLtoASL _attachPosition);

		//
		//		Offset points for all nearby objects
		//	

		_offsetSnapped = false;

		{
			
			// Ignore weapon holders/static turrets for now...
			if (typeOf _x == _class && !(_x call isHolder) && !(_x isKindOf "StaticWeapon")) then {

				_box = [_x] call getBoundingBox;
				_largestValue = _box call getMax;
				_pos = AGLtoASL (_X modelToWorld [0,0,0]);

				{
					_newPoint = _pos vectorAdd _x;

					if ((_newPoint distance _currentPosition) < (_largestValue / 2)) exitWith {
						_offsetSnapped = true;
						_attachPosition = ASLtoAGL [_newPoint select 0, _newPoint select 1, _newPoint select 2];
					};

					false
				} count [
					[0,0,(_box select 2)], // Up
					[0,0,(_box select 2) * -1], // Down
					[0,(_box select 1),0], // Left
					[0,(_box select 1) * -1,0], // Right
					[(_box select 0),0,0], // Front
					[(_box select 0) * -1,0,0] // Back
				];

			};

			false
		} count (attachedObjects _targetVehicle);	


		// 
		//		Snap to same X,Y,Z of matching coordinates
		//

		_pointsToCheck = (attachedObjects _targetVehicle);		

		_closestX = [9999, (_currentPosition select 0)];
		_closestY = [9999, (_currentPosition select 1)];
		_closestZ = [9999, (_currentPosition select 2)];

		
		_axisSnapped = false;

		{
			_c = "";
			_snapToAll = false;
			_vP = if (_x isEqualType objNull) then { _c = typeOf _x; (getPosWorld _x) } else { _snapToAll = true; _c = _class; _x };

			{
				_index = _x select 0;
				_tolerance = _x select 1;
				_dif = abs ((_vP select _index) - (_currentPosition select _index));
			
				// Only snap similar classes within tolerance
				if (_dif < _tolerance && _dif < ((_x select 2) select 0) && _class == _c) then {

					_axisSnapped = true;	
					(_x select 2) set [0, _dif];
					(_x select 2) set [1, (_vP select _index)];
				};

				false
			} count [
				[0, 0.5, _closestX, 'X'],
				[1, 0.5, _closestY, 'Y'],
				[2, 1, _closestZ, 'Z']
			];

			false
		} count _pointsToCheck;

		if (_axisSnapped && !_offsetSnapped) then {			

			_attachPosition = ASLtoAGL [_closestX select 1, _closestY select 1, _closestZ select 1];

		} else {
			hint '';
		};


		//
		//		Snap to same rotation of nearby objects
		//




		//
		//		Snap to same rotation of nearby vehicle
		//

		if (true) exitWIth {};

		_relDir = _obj getVariable ['GW_relDirection', 0];
		[_obj, _relDir] call setDirTo;

		_frontDir = (getDir _targetVehicle);
		_sideDir = [(_frontDir + 90)] call normalizeAngle;
		_forwardCornerDir = [(_frontDir + 45)] call normalizeAngle;
		_rearCornerDir = [(_frontDir - 45)] call normalizeAngle;
		_resultDir = 0;

		_currentDir = [_relDir - (getDir _unit)] call normalizeAngle;

		if (_currentDir != _frontDir || _currentDir != _sideDir || _currentDir != _rearCornerDir || _currentDir != _forwardCornerDir) then {

			// Which side are we on?
			_dirTo = [_targetVehicle, _obj] call dirTo;
			_dif = [_frontDir - _dirTo] call flattenAngle;

			_side = if (_dif < 0) then { "right" } else { "left" };
			_dirTo = abs (_dif);

			// Front of vehicle
			if (_dirTo > 157.5 || _dirTo < 22.5) exitWith {	_resultDir = _frontDir;	};			
			if (_dirTo >= 35  && _dirTo <= 55) exitWith { _resultDir = if (_side == 'right') then { _forwardCornerDir } else { _rearCornerDir };  }; // Corner of Vehicle
			if (_dirTo >= 125  && _dirTo <= 145) exitWith {	_resultDir = if (_side == 'right') then { _rearCornerDir } else { _forwardCornerDir };	}; // Rear corner			
			if (_dirTo <= 157.5 || _dirTo >= 22.5) exitWith { _resultDir = _sideDir; }; // Side of Vehicle

		};

		_actualDir = ([_resultDir - (getDir player)] call normalizeAngle);
		_obj setVariable ['GW_relDirection', _resultDir];
		[_obj, _resultDir] call setDirTo;	


	};

	_obj attachTo [_unit, _unit worldToModel _attachPosition];
	_relDir = _obj getVariable ['GW_relDirection', 0];
	[_obj, _relDir] call setDirTo;


		// if (_wasSnapped) then {
		// 	_obj attachTo [_unit, (_unit worldToModel GW_EDITING_TARGET)];	
		// };




	// Use the camera height as a tool to manipulate the object height
	// _cameraOffset = if (cameraView == "External") then { 1.5 } else { 1.25 };
	// _cameraHeight = [ (((positionCameraToWorld [0,0,4]) select 2) * _cameraOffset) * 1, 0, 10] call limitToRange;

	// Get the objects current location
	// _objPos = _unit worldToModelVisual (_obj modelToWorldVisual [0,0,0]);
	// _objAlt = (_objPos select 2);
	// _height = _objAlt;

	// Adjust object if we're looking above or below it
	// _height = [_cameraHeight, 0, 10] call limitToRange;
	
	// _distance = _unit distance _obj;


	// GW_EDITING_TARGET = (AGLtoASL positionCameraToWorld [0,0,_distance]);

	//GW_EDITING_TARGET = [([(_objPos select 0), 2] call roundTo),([(_objPos select 1), 2] call roundTo), ([_height, 2] call roundTo)];

	// Set the object position and direction (if changed)
	// _relDir = _obj getVariable ['GW_relDirection', 0];

	// _obj attachTo [_unit, (_unit worldToModel (getPos _obj))];	

	// [_obj, _relDir] call setDirTo;

	// Snapping options
	// _snapping = false;

	//if (true) then {

	// 	_targetVehicle = ([_unit, 12, 180] call validNearby);
	// 	if (isNil "_targetVehicle") exitWith {};

		// 
		//  Height snapping		
		//

		// _class = typeOf _obj;
		// _objPos = ATLtoASL (_unit worldToModel (getPos _obj));
		// _objHeight = _objPos select 2;	

		// _validHeights = [];
		// {
		// 	if (typeOf _x == _class) then { 
		// 		_height = (_x modelToWorldVisual [0,0,0]) select 2;
		// 		if ((_validHeights find _height) >= 0) exitWith {};
		// 		_validHeights pushBack ([_height, 2] call roundTo); 
		// 	};
		// 	false
		// } count (attachedObjects _targetVehicle) > 0; 

		// _tolerance = 0.2;
		// {
		// 	if (abs (_x - _objHeight) < _tolerance) exitWith {
		// 		GW_EDITING_TARGET set [2, _x];
		// 		_obj attachTo [_unit, GW_EDITING_TARGET];	
		// 	};
		// 	false
		// } count _validHeights > 0;	


		// 
		//  Angle snapping
		//

	// 	_frontDir = (getDir _targetVehicle);
	// 	_sideDir = [(_frontDir + 90)] call normalizeAngle;
	// 	_forwardCornerDir = [(_frontDir + 45)] call normalizeAngle;
	// 	_rearCornerDir = [(_frontDir - 45)] call normalizeAngle;
	// 	_resultDir = 0;

	// 	_currentDir = [_relDir - (getDir _unit)] call normalizeAngle;

	// 	if (_currentDir != _frontDir || _currentDir != _sideDir || _currentDir != _rearCornerDir || _currentDir != _forwardCornerDir) then {

	// 		// Which side are we on?
	// 		_dirTo = [_targetVehicle, _obj] call dirTo;
	// 		_dif = [_frontDir - _dirTo] call flattenAngle;

	// 		_side = if (_dif < 0) then { "right" } else { "left" };
	// 		_dirTo = abs (_dif);

	// 		// Front of vehicle
	// 		if (_dirTo > 157.5 || _dirTo < 22.5) exitWith {	_resultDir = _frontDir;	};			
	// 		if (_dirTo >= 35  && _dirTo <= 55) exitWith { _resultDir = if (_side == 'right') then { _forwardCornerDir } else { _rearCornerDir };  }; // Corner of Vehicle
	// 		if (_dirTo >= 125  && _dirTo <= 145) exitWith {	_resultDir = if (_side == 'right') then { _rearCornerDir } else { _forwardCornerDir };	}; // Rear corner			
	// 		if (_dirTo <= 157.5 || _dirTo >= 22.5) exitWith { _resultDir = _sideDir; }; // Side of Vehicle

	// 	};

	// 	_actualDir = ([_resultDir - (getDir player)] call normalizeAngle);
	// 	_obj setVariable ['GW_relDirection', _resultDir];
	// 	[_obj, _resultDir] call setDirTo;	

					
	// };

	if (_obj call isWeapon) then { _obj call renderFOV; };	

	// Dynamically adjust the sleep time to reduce errors during snapping
	_interval = if (_snapping) then { _snappingInterval } else { _moveInterval };	
	Sleep _interval;

};

if (!alive _obj) then {
	removeAllActions _unit;
	_unit spawn setPlayerActions;
};

if (!isNull attachedTo _obj) then {
	if ((attachedTo _obj) isEqualTo _unit) then {
		detach _obj;
	};
};

GW_EDITING = false;
_unit setVariable ['GW_EditingObject', nil];

true
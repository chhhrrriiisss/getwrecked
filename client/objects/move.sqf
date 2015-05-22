//
//      Name: moveObj
//      Desc: Adds various interaction options to an object that allows it to be manipulated
//      Return: Bool (Success)
//

private ["_obj", "_unit","_id"];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_unit = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _unit) exitWith { false };

// Check we own this object
_isOwner = [_obj, _unit, true] call checkOwner;
if (!_isOwner) exitWith { false };

// Check we're not already editing
if ( GW_EDITING ) exitWith { false };
GW_EDITING = true;

// Grab that sucker!
[_obj, _unit] spawn grabObj;

// Add all the actions that are available for this object
removeAllActions _unit;
_unit spawn setPlayerActions;

// Drop Object
_unit addAction[dropObjectFormat, {

	_unit = [_this,0, objNull, [objNull]] call filterParam;
	_obj = _unit getVariable ['GW_EditingObject', nil];
	if (isNil "_obj" || isNull _unit) exitWith {};

	[_unit, _obj] call dropObj;

}, _obj, 0, false, false, "", "(vehicle player) == player"];

// Supply boxes can only be moved and dropped
_isSupply = _obj call isSupplyBox;
if (_isSupply) exitWith {};

// Notify if snapping is already enabled
if (_unit getVariable ['snapping', false]) then {
	["SNAPPING ACTIVE!", 1, snappingIcon, nil, 'default'] spawn createAlert;   
};

// Disable Snapping 
_unit addAction[nosnapObjectFormat, {

	(_this select 0) setVariable ['snapping', false];
	["SNAPPING DISABLED!", 0.5, nosnappingIcon, nil, 'default'] spawn createAlert;   
	
}, _obj, 3, false, false, "", "( (vehicle player) == player && (_target getVariable 'snapping') && GW_EDITING )"]; 

// Enable Snapping 
_unit addAction[snapObjectFormat, {

	(_this select 0) setVariable ['snapping', true];
	["SNAPPING ENABLED!", 1, snappingIcon, nil, 'default'] spawn createAlert;   
	
}, _obj, 4, false, false, "", "( (vehicle player) == player && !(_target getVariable 'snapping') && GW_EDITING )"]; 

// Tilt Object Forward & Backward (Applies to only some objects)
// Currently disabled due to bugginess
// if ( !((typeOf _obj) in GW_TILT_EXCLUSIONS) ) then {

// 	_unit addAction[tiltForwardObjectFormat, {

// 		_unit = _this select 0;
// 		_obj = _unit getVariable ['GW_editingObject', nil];
// 		if (isNil "_obj" || isNull _unit) exitWith {};

// 		[_obj, [-10, 0]] call tiltObj;
		
// 	}, _obj, 4, false, false, "", "( (vehicle player) == player)"]; 

// 	_unit addAction[tiltBackwardObjectFormat, {

// 		_unit = _this select 0;
// 		_obj = _unit getVariable ['GW_editingObject', nil];
// 		if (isNil "_obj" || isNull _unit) exitWith {};

// 		[_obj, [10, 0]] call tiltObj;
		
// 	}, _obj, 4, false, false, "", "( (vehicle player) == player)"]; 

// };

// Rotate Object CW
_unit addAction[rotateCWObjectFormat, {

	_unit = [_this,0, objNull, [objNull]] call filterParam;
	_obj = _unit getVariable ['GW_EditingObject', nil];
	if (isNil "_obj" || isNull _unit) exitWith {};

	[_obj, 22.5] call rotateObj;


}, _obj, 1, false, false, "", "(vehicle player) == player"];

// Rotate Object CCW
_unit addAction[rotateCCWObjectFormat, {

	_unit = [_this,0, objNull, [objNull]] call filterParam;
	_obj = _unit getVariable ['GW_EditingObject', nil];
	if (isNil "_obj" || isNull _unit) exitWith {};

	[_obj, -22.5] call rotateObj;

}, _obj, 2, false, false, "", "(vehicle player) == player"];

// Attach object to a nearby vehicle
_unit addAction[attachObjectFormat, {

	_unit = [_this,0, objNull, [objNull]] call filterParam;
	_obj = _unit getVariable ['GW_EditingObject', nil];
	if (isNil "_obj" || isNull _unit) exitWith {};

	[_unit, _obj] spawn attachObj; 

}, _obj, 5, false, false, "", "( (vehicle player) == player && (!isNil { [_target, 12, 180] call validNearby }) )"]; 

true


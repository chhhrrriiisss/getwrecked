//
//      Name: Object Actions
//      Desc: Contains various functionality for applying action menus to specific object types
//      Return: None
//

// Actions for supply boxes
setSupplyAction = {
	
	private ['_obj'];

	_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
	if (isNull _obj) exitWith {};

	removeAllActions _obj;
	
	// Custom move effect for supply boxes
	_obj addAction[moveObjectFormat, {

		_obj = _this select 0;
		_unit = _this select 1;
	
		[_obj, _unit] spawn moveObj;

		removeAllActions _obj;	

	}, [], 0, false, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && (player distance _target < 5) && [_target, player, false] call checkOwner && !GW_LIFT_ACTIVE)"];		

	// Open the box inventory
	_obj addAction[openBoxFormat, {

		_obj = _this select 0;
		_unit = _this select 1;

		_isOwner = [_obj, _unit, true] call checkOwner;
		if (!_isOwner) exitWith { systemChat 'You dont own this object' };	

		_obj setVariable ["name", format["%1's Supply Box", GW_PLAYERNAME], true];	

		[_obj, _unit] spawn inventoryMenu;

	}, [], 0, false, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && (player distance _target < 5) && [_target, player, false] call checkOwner && !GW_LIFT_ACTIVE && !GW_PAINT_ACTIVE )"];		
	
	_obj setVariable ["hasActions", true];

	// Give it an object tag
	[_obj] spawn setTagAction;

	true
};

// Actions for paint buckets
setPaintAction = {

	private ['_obj'];

	_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
	if (isNull _obj) exitWith {};

	removeAllActions _obj;

	_obj addAction['Apply paint to vehicle', {

		_o = _this select 0;
		_unit = _this select 1;
		_color = _o getVariable ["color", ''];

		// If the colour is actually defined (which, it really should be...)
		if ((count toArray _color > 0)) then {
			[_color, _unit] spawn paintVehicle;
		};		

	}, [], 0, false, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && (player distance _target < 5) && !GW_LIFT_ACTIVE)"];	
	
	_obj setVariable ["hasActions", true];

	[_obj] spawn setTagAction;

	true
};

// Actions for 90% of attachable objects
setMoveAction = {	

	private ['_obj'];

	_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
	if (isNull _obj) exitWith {};

	removeAllActions _obj;
	
	_obj addAction[moveObjectFormat, {

		_obj = _this select 0;
		_unit = _this select 1;

		[_obj, _unit] spawn moveObj;

		removeAllActions _obj;	

	}, [], 0, false, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && (player distance _target < 5) && [_target, player, false] call checkOwner && !GW_LIFT_ACTIVE)"];		

	_obj setVariable ["hasActions", true];

	[_obj] spawn setTagAction;

	true
};

// Actions for objects that are already attached to a vehicle
setDetachAction = {

	_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
	if (isNull _obj) exitWith {};

	removeAllActions _obj;

	// Add detach action
	_obj addAction[detachObjectFormat, 
	{
		_obj = _this select 0;
		_unit = _this select 1;

		[_obj, _unit] spawn detachObj;

		removeAllActions _obj;
		
	}, [], 0, false, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && (player distance _target < 5) && [_target, player, false] call checkOwner && !GW_LIFT_ACTIVE)"];

	_obj setVariable ["hasActions", true];

	// Give it an object tag
	[_obj] spawn setTagAction;

	true

};

// Visible tagging (name and object info in HUD)
setTagAction = {
	[_this select 0] call tagObj;
};


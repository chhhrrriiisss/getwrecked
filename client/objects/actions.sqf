//
//      Name: Object Actions
//      Desc: Contains various functionality for applying action menus to specific object types
//      Return: None
//

// Actions for supply boxes
setTerminalActions = {
	
	private ['_obj', '_var'];

	_obj = [_this,0, objNull, [objNull]] call filterParam;
	_var = _this select 1;

	removeAllActions _obj;

	if (isNull _obj || isNil "_var") exitWith {};

	// Store terminal target so we can re-add it later	
	_obj addEventHandler['handleDamage', { false }];

	// Server doesn't need action menus
	if (isDedicated) exitWith {};

	_obj setVariable ["hasActions", true];

	// If it's a vehicle terminal
	if (typeOf _obj == "SignAd_Sponsor_ARMEX_F" && typename _var == "STRING") exitWith {

		_obj setVariable ['company', _var];

		// Action
		_obj addAction[buyMenuFormat, { 	
		[(_this select 0)] spawn buyMenu;
		}, _var, 0, false, false, "", "( !GW_EDITING && ((player distance _target) < 8) )"];

	};

	// If it's a vehicle terminal
	if (typeOf _obj == "Land_spp_Transformer_F" || (typeOf _obj == "SignAd_Sponsor_ARMEX_F" && typename _var == "OBJECT") ) exitWith {

		_obj setVariable ['GW_Target', _var];		

		// New Vehicle
		_obj addAction[createVehFormat, { 
			[(_this select 3)] spawn newMenu;
		}, _var, 9, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

		// Save Vehicle
		_obj addAction[savePadFormat, {
			[''] spawn saveVehicle;
		}, _var, 8, false, false, "", "( !GW_EDITING && ((player distance _target) < 12)  )"];

		// Deploy/Spawn
		_obj addAction[spawnInFormat, { 
			[(_this select 3), (_this select 1)] spawn spawnMenu;
		}, _var,7, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

		// Load Vehicle
		_obj addAction[loadPadFormat, {
			[(_this select 3)] spawn previewMenu;
		}, _var, 6, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];

		// Clear pad
		_obj addAction[clearPadFormat, {
			[(_this select 3)] spawn clearPad;
		}, _var, 5, false, false, "", "( !GW_EDITING && ((player distance _target) < 12) )"];
	};

	true
};

// Actions for supply boxes
setSupplyAction = {
	
	private ['_obj'];

	_obj = [_this,0, objNull, [objNull]] call filterParam;
	if (isNull _obj) exitWith {};

	removeAllActions _obj;
	
	// Custom move effect for supply boxes
	_obj addAction[moveObjectFormat, {

		_obj = _this select 0;
		_unit = _this select 1;
	
		[_obj, _unit] spawn moveObj;

		removeAllActions _obj;	

	}, [], 0, false, false, "", "( ( (vehicle player) == player ) && !GW_EDITING && (player distance _target < 7) && [_target, player, false] call checkOwner && !GW_LIFT_ACTIVE)"];		

	// Open the box inventory
	_obj addAction[openBoxFormat, {

		_obj = _this select 0;
		_unit = _this select 1;

		_isOwner = [_obj, _unit, true] call checkOwner;
		if (!_isOwner) exitWith { systemChat 'You dont own this object' };	

		_obj setVariable ["name", format["%1's Supply Box", name player], true];	

		[_obj, _unit] spawn inventoryMenu;

	}, [], 0, false, false, "", "( (!GW_INVEHICLE) && !GW_EDITING && (player distance _target < 7) && [_target, player, false] call checkOwner && !GW_LIFT_ACTIVE && !GW_PAINT_ACTIVE )"];		
	
	_obj setVariable ["hasActions", true];

	// Give it an object tag
	[_obj] spawn setTagAction;

	true
};

// Actions for paint buckets
setPaintAction = {

	private ['_obj'];

	_obj = [_this,0, objNull, [objNull]] call filterParam;
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

	}, [], 0, false, false, "", "(!GW_INVEHICLE && !GW_EDITING && (player distance _target < 8) && !GW_LIFT_ACTIVE)"];	
	
	_obj setVariable ["hasActions", true];

	[_obj] spawn setTagAction;

	true
};

// Actions for 90% of attachable objects
setMoveAction = {	

	private ['_obj'];

	_obj = [_this,0, objNull, [objNull]] call filterParam;
	if (isNull _obj) exitWith {};

	removeAllActions _obj;
	
	_obj addAction[moveObjectFormat, {

		_obj = _this select 0;
		_unit = _this select 1;

		[_obj, _unit] spawn moveObj;

		removeAllActions _obj;	

	}, [], 0, false, false, "", "(!GW_INVEHICLE && !GW_EDITING && (player distance _target < 8) && ([_target, player, false] call checkOwner) && !GW_LIFT_ACTIVE && GW_CURRENTZONE == 'workshopZone' )"];		

	_obj setVariable ["hasActions", true];

	[_obj] spawn setTagAction;

	true
};

// Actions for objects that are already attached to a vehicle
setDetachAction = {

	_obj = [_this,0, objNull, [objNull]] call filterParam;
	if (isNull _obj) exitWith {};

	removeAllActions _obj;

	// Add detach action
	_obj addAction[detachObjectFormat, 
	{
		_obj = _this select 0;
		_unit = _this select 1;

		[_obj, _unit] spawn detachObj;

		removeAllActions _obj;
		
	}, [], 0, false, false, "", "(!GW_INVEHICLE && !GW_EDITING && (player distance _target < 8) && ([_target, player, false] call checkOwner) && !GW_LIFT_ACTIVE && GW_CURRENTZONE == 'workshopZone' )"];

	_obj setVariable ["hasActions", true];

	// Give it an object tag
	[_obj] spawn setTagAction;

	true

};

// Visible tagging (name and object info in HUD)
setTagAction = {
	[_this select 0] call tagObj;
};


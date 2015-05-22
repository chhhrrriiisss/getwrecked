//
//      Name: Vehicle Functions
//      Desc: Various functions required by vehicle scripts
//		Return: None
//

calcWeapons = {

	private ["_o", "_v"];

	_o = _this select 0;
	_v = _this select 1;


	// Add the weapon target to the weapons array
	_type = _w select 0;

	if (_type in GW_LOCKONWEAPONS) then {
		_v setVariable["lockOns", true];	
	};

	_vehWeapons = _v getVariable "weapons";
	_vehWeapons = _vehWeapons + [_w];
	_v setVariable["weapons", _vehWeapons];		

	true

};

calcTactical = {

	private ["_o", "_v"];

	_o = _this select 0;
	_v = _this select 1;
	_t = _this select 2;

	_type = _t select 0;
	_obj = _t select 1;
	_desc = format['%1', _t select 2];
	_vehTactical = (_v getVariable "tactical");
	_id = 9999;

	// Check if a module of this type already exists
	_exists = [_type, _v] call hasType;

	_vehTactical = _vehTactical + [ [_type, _obj, _id] ];
	_v setVariable["tactical", _vehTactical];		

};

calcSpecial = {

	_o = _this select 0;
	_v = _this select 1;
	_t = _this select 2;

	_vehSpecial = (_v getVariable "special");

	// Check if a module of this type already exists
	_exists = if (_t in _vehSpecial) then { true } else { false };
		
	if (!_exists) then {

		_vehSpecial = _vehSpecial + [_t];
		_v setVariable ["special", _vehSpecial];
	};

};

// Apply all defaults to the vehicle
setDefaultData = {

	private ["_v", "_data", "_armor", "_defaultAmmo", '_defaultFuel', '_armorValue'];

	_v = _this select 0;

	_mass = getMass _v;
	if (isNil "_mass") then { _mass = 5000; };

	_data = [typeOf _v, GW_VEHICLE_LIST] call getData;
	if (isNil "_data") exitWith { false };
	_attr = _data select 2;

	_armor = [_attr, 6, 1, [0]] call filterParam;
	_armorValue = getNumber(configFile >> "CfgVehicles" >> (typeOf _v) >> "armor");
	_armorValue = if (isNil "_armorValue") then { GW_GAM } else { ((_armorValue / GW_GAM) * _armor) };
	
	{
		_v setVariable _x;
	} count [	    
	    ['GW_Armor', _armorValue, true],
	    ['GW_Signature', ([_attr, 7, "Low"] call filterParam), true],
	    ['GW_Health', 100, true],
	    ['fuel', 0, false],
	    ['ammo', 1, false],
	    ['maxAmmo', ([_attr, 3, 0] call filterParam), false],
	    ['maxFuel', ([_attr, 4, 0] call filterParam), false],
	    ['maxWeapons', ([_attr, 1,9999] call filterParam), false],
	    ['maxModules', ([_attr, 2, 9999] call filterParam), false],
	    ['weapons', [], false],
	    ['tactical', [], false],
	    ['special', [], false],
	    ['mass', _mass, false],
	    ['maxMass', ([(_attr select 0), 1, 99999] call filterParam), false],
	    ['massModifier', ([(_attr select 0), 0, 1] call filterParam), false],
	    ['lockOns', false, false]

	] > 0;
	
	removeAllActions _v;
	
	true
};

// Sets actions for a compile vehicle
setVehicleActions = {
	
	_vehicle = _this select 0;

	if (!hasInterface) exitWith {};

	_vehicle setVariable ['hasActions', true];

	// Lock ons
	if (_vehicle getVariable ["lockOns", false]) then {

		_vehicle addAction["<t color='#ff1100' style='0'>Disable Auto-Lock</t>", {

			[(_this select 0), false] call toggleLockOn;

		}, [], 0, false, false, "", " (_target getVariable 'lockOns') && player in _target && (player == (driver _target))"];	

		_vehicle addAction["<t color='#ff1100' style='0'>Enable Auto-Lock</t>", {

			[(_this select 0), true] call toggleLockOn;			

		}, [], 0, false, false, "", " !(_target getVariable 'lockOns') && player in _target && (player == (driver _target))"];	

	};

	// Turn off oil slick
	_vehicle addAction ["<t color='#ff1100' style='0'>Deactivate Oil</t>", {

		_v = (_this select 0);
		GW_OIL_ACTIVE = nil;

	}, [], 0, false, false, "", "( (player in _target) && (player == (driver _target)) && (!isNil 'GW_OIL_ACTIVE' ) )"];

	// Detonate explosives
	_vehicle addAction ["<t color='#ff1100' style='0'>Detonate Explosives</t>", {

		[(_this select 0)] call detonateTargets;

	}, [], 0, false, false, "", "( (player in _target) && (player == (driver _target)) && (count (_target getVariable ['GW_detonateTargets', []]) > 0) )"];

	// Activate Teleport
	_vehicle addAction ["<t color='#ff1100' style='0'>Activate Teleport</t>", {

		[(_this select 0)] call activateTeleport;

	}, [], 0, false, false, "", "( (player in _target) && (player == (driver _target)) && (count (_target getVariable ['GW_teleportTargets', []]) > 0) )"];

	// Deactivate Cloak
	cloakObjectFormat = "<t color='#ff1100' style='0'>Deactivate Cloak</t>";

	_vehicle addAction [cloakObjectFormat, {

		[       
			[
				(_this select 0),
				"['cloak']"
			],
			"removeVehicleStatus",
			false,
			false 
		] call gw_fnc_mp;  

	}, [], 0, false, false, "", "( (player in _target) && (player == (driver _target)) && ( 'cloak' in (_target getVariable ['status', []]) ) )"];

	// Open the settings menu
	_vehicle addAction[settingsVehicleFormat, {

		[(_this select 0), player] spawn settingsMenu;

	}, [], 0, false, false, "", "( !GW_EDITING && ((player distance _target) < 8) && (player in _target) && (GW_CURRENTZONE != 'workshopZone') && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE))"];		

	// Open the settings menu
	_vehicle addAction[unflipVehicleFormat, {

		[(_this select 0), true, true] spawn flipVehicle;

	}, [], 0, false, false, "", "( GW_CURRENTZONE != 'workshopZone' && !(canMove _target) )"];		

	// Horn override (and used for firing with mouse)
	_vehicle addAction ["", {}, "", 0, false, true, "DefaultAction"];

};
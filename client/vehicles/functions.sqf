//
//      Name: Vehicle Functions
//      Desc: Various functions required by vehicle scripts
//		Return: None
//

calcMass = {

	private ["_o", "_v", "_d"];

	_o = _this select 0;
	_v = _this select 1;

	_vMass = (getMass _v);

	_d = [(typeof _v), GW_VEHICLE_LIST] call getData;
	_modifier = if (!isNil "_d") then { (((_d select 2) select 0) select 0) } else { 1 };
	_oMass = ( _o getVariable ["mass", 0] );	
	_oMass = _oMass * _modifier;
	_newMass = _vMass + _oMass;

	_v setMass _newMass;

	true
};

calcAmmo = {

	private ["_o", "_v"];

	_o = _this select 0;
	_v = _this select 1;

	_ammo = (_o getVariable ["ammo", 0]);
	_type = (_o getVariable ["ammo", 0]);

	if (_ammo > 0) then { _v setVariable["maxAmmo", (_v getVariable "maxAmmo") + _ammo]; };

	true
};

calcFuel = {

	private ["_o", "_v"];

	_o = _this select 0;
	_v = _this select 1;

	_fuel = _o getVariable ["fuel", 0];

	if (_fuel > 0) then { _v setVariable["maxFuel", (_v getVariable "maxFuel") + _fuel]; };

	true
};

calcWeapons = {

	private ["_o", "_v"];

	_o = _this select 0;
	_v = _this select 1;
	_w = _this select 2;

	// Calculate the relative angle of the weapon
	_vehDir =  getDir _v;
	_wepDir = getDir _o;

	if (typeOf _o == 'groundWeaponHolder') then {
		_wepDir = _wepDir + 90;
	};

	_dif = [_wepDir - _vehDir] call normalizeAngle;
	_o setVariable ['defaultDirection', _dif];

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

	if (_exists < 0) then {

		_id = _v addAction[_desc, { 

			_type = (_this select 3) select 0; 
			_obj = (_this select 3) select 1; 
			_id = (_this select 3) select 2; 
			_veh = _this select 0; 

			[_type, _veh] spawn useAttached;

		}, [_type, _obj, _id], 0, false, false, "", format["( player in _target && (driver _target) == player && ((['%1', _target] call hasType) > 0) )", _type]]; // Only show action if the type exists on the vehicle
	};

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

	private ["_v"];

	_v = _this select 0;
	_defaultData = _v getVariable ["GW_defaults",[]];

	if (count _defaultData <= 0) exitWith { false };

	{
		if ((_x select 0) == 'mass') then {
			_v setMass (_x select 1);
		} else {

			if (_x select 2) then {
				_v setVariable [_x select 0, _x select 1, true];
			} else {
				_v setVariable [_x select 0, _x select 1];
			};
		};
		false
	} count _defaultData > 0;
	
	removeAllActions _v;
	
	true
};

// Sets actions for a compile vehicle
setVehicleActions = {
	
	_vehicle = _this select 0;

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
		] call BIS_fnc_MP;  

	}, [], 0, false, false, "", "( (player in _target) && (player == (driver _target)) && ( 'cloak' in (_target getVariable ['status', []]) ) )"];

	// Open the settings menu
	_vehicle addAction[settingsVehicleFormat, {

		[(_this select 0), player] spawn settingsMenu;

	}, [], 0, false, false, "", "( !GW_EDITING && player in _target && !GW_LIFT_ACTIVE && !(GW_PAINT_ACTIVE))"];		

	// Open the settings menu
	_vehicle addAction[unflipVehicleFormat, {

		[(_this select 0), true, true] spawn flipVehicle;

	}, [], 0, false, false, "", "( GW_CURRENTZONE != 'workshopZone' && !(canMove _target) )"];		

	// Horn override (and used for firing with mouse)
	_vehicle addAction ["", {}, "", 0, false, true, "DefaultAction"];

};
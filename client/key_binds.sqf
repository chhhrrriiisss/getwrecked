GW_RESTRICTED_KEYS = [
	1, // esc
	69 // Num Lock Spam
];

initBinds = {	
	
	fireKeyDown = '';

	GW_KEYDOWN = nil;

	waituntil {!(isNull (findDisplay 46))};

	// Main HUD
	if (!isNil "GW_KD_EH") then { (findDisplay 46) displayRemoveEventHandler ["KeyDown", GW_KD_EH];	GW_KD_EH = nil;	};
	GW_KD_EH = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call checkBinds; false"];

	if (!isNil "GW_KU_EH") then { (findDisplay 46) displayRemoveEventHandler ["KeyUp", GW_KU_EH];	GW_KU_EH = nil;	};
	GW_KU_EH = (findDisplay 46) displayAddEventHandler ["KeyUp", "_this call resetBinds; false"];

	if (!isNil "GW_MD_EH") then { (findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", GW_MD_EH];	GW_MD_EH = nil;	};
	GW_MD_EH = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call setMouseDown; false;"];

	if (!isNil "GW_MU_EH") then { (findDisplay 46) displayRemoveEventHandler ["MouseButtonUp", GW_MU_EH];	GW_MU_EH = nil;	};
	GW_MU_EH = (findDisplay 46) displayAddEventHandler ["MouseButtonUp", "_this call setMouseUp; false;"];

	setMouseDown = {			
		if ((_this select 1) == 0) then {  

			GW_LMBDOWN = true; 
			
			if (GW_SETTINGS_ACTIVE && !isNil "GW_MOUSEX" && !isNil "GW_MOUSEY" && GW_MOUSEX > 0.4 ) then {
				disableSerialization;
				_list = ((findDisplay 92000) displayCtrl 92001);
				_index = lnbcurselrow _list;
				if (_index in reservedIndexes) exitWith {};
				[_list, _index, true] spawn setBind;
			};
			
		};
		
	};

	setMouseUp = {		
		if ((_this select 1) == 0) then {  GW_LMBDOWN = false; };	
		
	};

};

resetBinds = {
	
	if (showBinds) then {
		showBinds = false;
	};

	if (fireKeyDown != '') then {
		fireKeyDown = '';
	};

	if (keyDown) then {
		keyDown = false;
	};

	GW_HOLD_ROTATE = false;
	GW_KEYDOWN = nil;
};

checkBinds = {
	
	User1 = actionKeys "User1"; // Grab/drop
	User2 = actionKeys "User2"; // Attach / detach
	User3 = actionKeys "User3"; // Rotate CW 
	User4 = actionKeys "User4"; // Rotate CCW
	User5 = actionKeys "User5"; // Hold Rotate
	// User6 = actionKeys "User6"; // Tilt Forward
	// User7 = actionKeys "User7"; // Tilt Backward



	User20 = actionKeys "User20"; // Settings

	_key = _this select 1; // The key that was pressed
	_shift = _this select 2; 
	_ctrl = _this select 3; 
	_alt = _this select 4; 

	if (GW_SHOOTER_ACTIVE) exitWIth { false };

	// Conditionals
	_vehicle = (vehicle player);
	_inVehicle = !(player == (_vehicle));
	_isDriver = (player == (driver (_vehicle)));	

	// Toggle Debug
	if (_ctrl && _alt && _shift && _key == 32) exitWith {
		GW_DEBUG = if (GW_DEBUG) then { false } else { true };
	};

	if (GW_TIMER_ACTIVE) exitWith {};

	if (GW_BUY_ACTIVE) then {
		if (_key in [2,3,4,5,6,7,8,9,10,11]) exitWith {		
			[_key] call setQuantityUsingKey;
		};
	};

	if (_key == 28 && GW_DIALOG_ACTIVE) exitWith {
		[] call confirmCurrentDialog;
	};	

	// Windows key
	if (_key in User20 && (_inVehicle && _isDriver) ) then {

		if (!GW_SETTINGS_ACTIVE) then {
			[_vehicle, player] spawn settingsMenu;
		};

		if (GW_SETTINGS_ACTIVE) then {
			systemChat 'Use ESC to close the settings menu.';
		};
	};

	if ( (_key in GW_RESTRICTED_KEYS) && GW_KEYBIND_ACTIVE) exitWith { systemChat 'That key is restricted.'; };

	GW_KEYDOWN = _key;

	if (GW_SETTINGS_ACTIVE || GW_DEPLOY_ACTIVE || GW_SPAWN_ACTIVE || GW_DIALOG_ACTIVE) exitWith {};	

	// Save
	if (_ctrl && _key == 31) exitWith {
		[''] spawn saveVehicle;
	};

	// Preview
	if (_ctrl && _key == 24) exitWith {
		[] spawn previewMenu;
	};

	if (!_inVehicle && GW_CURRENTZONE == "workshopZone") then {
		if (_key in User5) then { GW_HOLD_ROTATE = true; };		
	};

	// Editor Keys
	if ( GW_EDITING && !_inVehicle ) then {

		_object = player getVariable ["editingObject", nil];
		if (isNil "_object") exitWith {};
		
		if (_key in User1) then { [player, _object] spawn dropObj; }; 
		if (_key in User2) then { [player, _object] spawn attachObj; }; 
		if (_key in User3) then { [_object, 4.5] spawn rotateObj; };
		if (_key in User4) then { [_object, -4.5] spawn rotateObj; };	
		if (_key in User6) then { [_object, [-5, 0]] spawn tiltObj; }; 
		if (_key in User7) then { [_object, [5, 0]] spawn tiltObj; }; 
	};

	// Outside Editor Keys
	if ( !GW_EDITING && !_inVehicle ) then {

		_object = cursorTarget;
		if (isNil "_object") exitWith {};

		_useable = _object getVariable ["isObject", false];
		if ( !_useable ) exitWith {};
		
		if (_key in User1) then { [_object, player] spawn moveObj; }; 
		
	};


	if (GW_CURRENTZONE == "workshopZone") exitWith {};

	if (_inVehicle && _isDriver && GW_CHUTE_ACTIVE) then {

		_pitchBank = GW_CHUTE call BIS_fnc_getPitchBank;
		_pitchBank set[2, (getDir GW_CHUTE)];
		_pitchAmount = 1;
		_bankAmount = 0.3;

		// S
		if (_key == 17) then {
			_pitchBank set [0, ([(_pitchBank select 0) - _pitchAmount, -3, 3] call limitToRange)];
		};

		// S
		if (_key == 31) then {
			_pitchBank set [0, ([(_pitchBank select 0) + _pitchAmount, -3, 3] call limitToRange)];
		};

		// A
		if (_key == 30) then {		
			_pitchBank set [1, ([(_pitchBank select 1) - _bankAmount, -15, 15] call limitToRange)];
		};

		// D
		if (_key == 32) then {
			_pitchBank set [1, ([(_pitchBank select 1) + _bankAmount, -15, 15] call limitToRange)];
		};

		//systemchat str _pitchBank;
		[GW_CHUTE, _pitchBank] call setPitchBankYaw;

	};


	// In Vehicle Keys
	if (_inVehicle && _isDriver) then { 

		_status = _vehicle getVariable ["status", []];
		_canShoot = if (!GW_WAITFIRE && !('cloak' in _status)) then { true } else { false };
		_canUse = if (!GW_WAITUSE && !('cloak' in _status)) then { true } else { false };

		['Can Use', true] call logDebug;

		{	

			if (count _x == 0) then {} else {

				{
				
					_tag = _x select 0;

					_isWeaponBind = if (_tag in GW_WEAPONSARRAY) then { true } else { false };
					_isModuleBind = if (_tag in GW_TACTICALARRAY) then { true } else { false };
					_isVehicleBind = if (!_isWeaponBind && !_isModuleBind) then { true } else { false };

					_obj = objNull;
					_bind = if (_isVehicleBind) then { (_x select 1) } else { _obj = (_x select 1); (_obj getVariable ["GW_KeyBind", ["-1", "1"]]) };			
					

					// Make sure we're working with a properly formatted array bind
					if (typename _bind == "ARRAY") then {} else {						
						_k = if (typename _bind != "STRING") then { (str _bind) } else { _bind };
						_bind = [_k, "1"];
						if (!_isVehicleBind) then { _obj setVariable ["GW_KeyBind", _bind, true]; };	
					};

					// Get the keycode we are working with
					_keyCode = if ((typename (_bind select 0)) != "SCALAR") then { (parseNumber (_bind select 0)) } else { (_bind select 0) };
						
					_exitEarly = false;	

					if (_keyCode >= 0 && _keyCode == _key) then {	
						// Vehicle binds
						if (_isVehicleBind) exitWith {							

							if (_tag == "HORN") exitWith { [_vehicle, ['horn'], 1] call addVehicleStatus; [_vehicle] spawn tauntVehicle; };
							if (_tag == "UNFL") exitWith { [_vehicle, false, false] spawn flipVehicle; };				
							if (_tag == "EPLD") exitWith { [_vehicle] call detonateTargets; playSound "beep"; };
							if (_tag == "LOCK" && {	_exists = false; {	if (([_x, _vehicle] call hasType) > 0) exitWith { _exists = true; };false } count GW_LOCKONWEAPONS > 0;	_exists	}) exitWith { [_vehicle] call toggleLockOn; playSound "beep"; };
							if (_tag == "OILS" && ((['OIL', _vehicle] call hasType) > 0) ) exitWith { GW_OIL_ACTIVE = nil; playSound "beep"; };
							if (_tag == "DCLK" && ((['CLK', _vehicle] call hasType) > 0) ) exitWith { [_vehicle, ['cloak']] call removeVehicleStatus; playSound "beep"; };
							if (_tag == "PARC" && ((['PAR', _vehicle] call hasType) > 0) ) exitWith { if (GW_CHUTE_ACTIVE) then { GW_CHUTE_ACTIVE = false; playSound "beep"; };  };

						};

						// Weapon binds
						if (_canShoot && _isWeaponBind) exitWith {					

							_indirect = true;
							{	if ((_x select 0) == _obj) exitWith { _indirect = false; }; false } count GW_AVAIL_WEAPONS > 0;
							[_tag, _vehicle, _obj, _indirect] spawn fireAttached;			
						};

						// Module Binds
						if (_canUse && _isModuleBind) exitWith {

							// If its a bag of explosives, just drop one bag
							if (_tag == "EPL") then { _exit = true; };							
							[_tag, _vehicle, _obj] spawn useAttached;
						};	

					};

					if (_exitEarly) exitWith { false };

					false

				} count _x > 0;

			};
		
			false

		} count [

			(_vehicle getVariable ["weapons", []]),
			(_vehicle getVariable ["tactical", []]),
			(_vehicle getVariable ["GW_Binds", []])

		] > 0;		

	};	

	true

};

GW_RESTRICTED_KEYS = [
	1, // esc
	69 // Num Lock Spam
];


resetBinds = {
	
	_key = _this select 1; // The key that was pressed

	if (showBinds) then {
		showBinds = false;
	};

	if (fireKeyDown != "") then {
		fireKeyDown = "";
	};

	if (keyDown) then {
		keyDown = false;
	};

	GW_HOLD_ROTATE = false;
	GW_KEYDOWN = nil;

	// _groupsKey = ["GROUPS"] call getGlobalBind;
	_infoKey = ["INFO"] call getGlobalBind;

	// if (_key == _infoKey) then {
	// 	hint 'This feature is not yet implemented.';
	// 	// [] execVM "client\ui\dialogs\createHint.sqf";
	// };
};

checkBinds = {
	
	// [_this, "key"] call triggerLazyUpdate;

	_key = _this select 1; // The key that was pressed
	_shift = _this select 2; 
	_ctrl = _this select 3; 
	_alt = _this select 4; 

	_grabKey = ["GRAB"] call getGlobalBind;
	_attachKey = ["ATTACH"] call getGlobalBind;
	_rotateCWKey = ["ROTATECW"] call getGlobalBind;
	_rotateCCWKey = ["ROTATECCW"] call getGlobalBind;
	_holdRotateKey = ["HOLD"] call getGlobalBind;
	_settingsKey = ["SETTINGS"] call getGlobalBind;	

	['Current key:', (format["%1 [%2]", [_this select 1] call codeToKey, _this select 1]) ] call logDebug;

	// Tilde key for cancelling hints
	if (_key == 41) exitWith { hint ''; };

	// Toggle Debug ctrl+shift+alt+numpadenter
	if (_ctrl && _alt && _shift && _key == 184) exitWith {
		GW_DEBUG = if (GW_DEBUG) then { false } else { true };
	};

	if (GW_TIMER_ACTIVE || GW_TITLE_ACTIVE) exitWith {};

	if (GW_BUY_ACTIVE) then {
		if (_key in [2,3,4,5,6,7,8,9,10,11]) exitWith {		
			[_key] call setQuantityUsingKey;
		};
	};

	if (_key == 28 && GW_DIALOG_ACTIVE) exitWith {
		[] call confirmCurrentDialog;
	};	

	if (_key == _settingsKey && !GW_INVEHICLE) then {

		if (GW_SETTINGS_ACTIVE) exitWith {	systemChat "Use ESC to close the settings menu."; };

		_nearby = ([player, 15, 180] call validNearby);
		if (isNil "_nearby") exitWith {};

		[_nearby, player] spawn settingsMenu;

	};
	
	if (_key == _settingsKey && (GW_INVEHICLE && GW_ISDRIVER) ) then {

		if (GW_SETTINGS_ACTIVE) exitWith { systemChat "Use ESC to close the settings menu."; };	
		[GW_CURRENTVEHICLE, player] spawn settingsMenu;		
	};

	if ( (_key in GW_RESTRICTED_KEYS) && GW_KEYBIND_ACTIVE) exitWith { systemChat "That key is restricted."; };

	GW_KEYDOWN = _key;

	if (GW_SETTINGS_ACTIVE || GW_DEPLOY_ACTIVE || GW_SPAWN_ACTIVE || GW_DIALOG_ACTIVE || GW_LOBBY_ACTIVE) exitWith {};	

	if (!GW_INVEHICLE && GW_CURRENTZONE == "workshopZone") then {

		// Save
		if (_ctrl && _key == 31) exitWith {
			[""] spawn saveVehicle;
		};

		// Preview
		if (_ctrl && _key == 24) exitWith {
			[] spawn previewMenu;
		};
	
		if (_key == _holdRotateKey) then { GW_HOLD_ROTATE = true; };		

		if (!GW_EDITING) exitWith {};

		_object = player getVariable ["GW_EditingObject", nil];
		if (isNil "_object") exitWith {};
		
		if (_key == _grabKey) then { [player, _object] spawn dropObj; }; 
		if (_key == _attachKey) then { [player, _object] spawn attachObj; }; 
		if (_key == _rotateCWKey) then { [_object, 4.5] spawn rotateObj; };
		if (_key == _rotateCCWKey) then { [_object, -4.5] spawn rotateObj; };	
	};

	if (GW_CURRENTZONE == "workshopZone") exitWith {};

	if (GW_INVEHICLE && GW_ISDRIVER) then {

		_canShoot = if (!("cloak" in GW_VEHICLE_STATUS) && !("noshoot" in GW_VEHICLE_STATUS)) then { true } else { false };
		_canUse = if (!GW_WAITUSE && !("cloak" in GW_VEHICLE_STATUS) && !("nouse" in GW_VEHICLE_STATUS)) then { true } else { false };

		["Can Use", true] call logDebug;

		{	

			if (count _x == 0) then {} else {

				{
				
					_tag = _x select 0;

					_isWeaponBind = if (_tag in GW_WEAPONSARRAY) then { true } else { false };
					_isModuleBind = if (_tag in GW_TACTICALARRAY) then { true } else { false };
					_isVehicleBind = if (!_isWeaponBind && !_isModuleBind) then { true } else { false };

					_obj = objNull;
					_bind = if (_isVehicleBind) then { (_x select 1) } else { _obj = (_x select 1); (_obj getVariable ["GW_KeyBind", ["-1", "1"]]) };			
					

					// Make sure were working with a properly formatted array bind
					if (_bind isEqualType []) then {} else {						
						_k = if ( !(_bind isEqualType "") ) then { (str _bind) } else { _bind };
						_bind = [_k, "1"];
						if (!_isVehicleBind) then { _obj setVariable ["GW_KeyBind", _bind, true]; };	
					};

					// Get the keycode we are working with
					_keyCode = if ( !((_bind select 0) isEqualType 0) ) then { (parseNumber (_bind select 0)) } else { (_bind select 0) };
						
					_exitEarly = false;	

					if (_keyCode >= 0 && _keyCode == _key) then {	
						
						// Vehicle binds
						if (_isVehicleBind) exitWith {							

							if (_tag == "HORN") exitWith { [GW_CURRENTVEHICLE, ["horn"], 1] call addVehicleStatus; [GW_CURRENTVEHICLE] spawn tauntVehicle; };
							if (_tag == "UNFL") exitWith { [GW_CURRENTVEHICLE, false, false] spawn flipVehicle; };				
							if (_tag == "EPLD") exitWith { [GW_CURRENTVEHICLE] call detonateTargets; playSound "beep"; };
							if (_tag == "TELP") exitWith { [GW_CURRENTVEHICLE] call activateTeleport;  playSound "beep"; };
							if (_tag == "LOCK" && {	_exists = false; {	if (([_x, GW_CURRENTVEHICLE] call hasType) > 0) exitWith { _exists = true; };false } count GW_LOCKONWEAPONS > 0;	_exists	}) exitWith { [GW_CURRENTVEHICLE] call toggleLockOn; playSound "beep"; };
							if (_tag == "OILS" && ((["OIL", GW_CURRENTVEHICLE] call hasType) > 0) ) exitWith { GW_OIL_ACTIVE = nil; playSound "beep"; };
							if (_tag == "DCLK" && ((["CLK", GW_CURRENTVEHICLE] call hasType) > 0) ) exitWith { [GW_CURRENTVEHICLE, ["cloak"]] call removeVehicleStatus; playSound "beep"; };
							if (_tag == "PARC" && ((["PAR", GW_CURRENTVEHICLE] call hasType) > 0) ) exitWith { if (GW_CHUTE_ACTIVE) then { GW_CHUTE_ACTIVE = false; playSound "beep"; };  };
							

						};	

						// Weapon binds
						if (_canShoot && _isWeaponBind) exitWith {					

							

							_indirect = true;
							{	if ((_x select 0) == _obj) exitWith { _indirect = false; }; false } count GW_AVAIL_WEAPONS > 0;
							[_tag, GW_CURRENTVEHICLE, _obj, _indirect] spawn fireAttached;			
						};

						// Module Binds
						if (_canUse && _isModuleBind) exitWith {

							// If its a bag of explosives, just drop one bag
							if (_tag == "EPL" || _tag == "TPD" || _tag == "NPA") then { _exitEarly = true; false };							
							[_tag, GW_CURRENTVEHICLE, _obj] call useAttached;
						};	

					};

					if (_exitEarly) exitWith { false };

					false

				} count _x;

			};
		
			false

		} count [

			(GW_CURRENTVEHICLE getVariable ["weapons", []]),
			(GW_CURRENTVEHICLE getVariable ["tactical", []]),
			(GW_CURRENTVEHICLE getVariable ["GW_Binds", []])

		] > 0;		

	};	

	true

};

initBinds = {

	fireKeyDown = '';

	GW_KEYDOWN = nil;

	waituntil {
		!isNull (findDisplay 46) 
	};

	if (!isNil "GW_KD_EH") then { (findDisplay 46) displayRemoveEventHandler ["KeyDown", GW_KD_EH]; };
	GW_KD_EH = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call checkBinds; false"];

	if (!isNil "GW_KU_EH") then { (findDisplay 46) displayRemoveEventHandler ["KeyUp", GW_KU_EH];	GW_KU_EH = nil;	};
	GW_KU_EH = (findDisplay 46) displayAddEventHandler ["KeyUp", "_this call resetBinds; false"];

	if (!isNil "GW_MD_EH") then { (findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", GW_MD_EH];	GW_MD_EH = nil;	};
	GW_MD_EH = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call setMouseDown; false;"];

	if (!isNil "GW_MU_EH") then { (findDisplay 46) displayRemoveEventHandler ["MouseButtonUp", GW_MU_EH];	GW_MU_EH = nil;	};
	GW_MU_EH = (findDisplay 46) displayAddEventHandler ["MouseButtonUp", "_this call setMouseUp; false;"];

	setMouseDown = {			
		if ((_this select 1) == 0) then { GW_LMBDOWN = true; };		
	};

	setMouseUp = {		
		if ((_this select 1) == 0) then {  GW_LMBDOWN = false; };		
	};

};


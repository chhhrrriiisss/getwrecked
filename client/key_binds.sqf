keyCodes = [

	['ESC', 1],
	['F1', 59],
	['F2', 60],
	['F3', 61],
	['F4', 62],
	['F5', 63],
	['F6', 64],
	['F7', 65],
	['F8', 66],
	['F9', 67],
	['F10', 68],
	['F11', 87],
	['F12', 88],
	['Print', 183],
	['Scroll', 70],
	['Pause', 197],
	['^', 41],
	['1', 2],
	['2', 3],
	['3', 4],
	['4', 5],
	['5', 6],
	['6', 7],
	['7', 8],
	['8', 9],
	['9', 10],
	['0', 11],
	['ß', 12],
	['´', 13],
	['Ü', 26],
	['Ö', 39],
	['Ä', 40],
	['#', 43],
	['<', 86],
	[',', 51],
	['.', 52],
	['-', 53],
	['POS1', 199],
	['Tab', 15],
	['Enter', 28],
	['Del', 211],
	['Backspace', 14],
	['Insert', 210],
	['End', 207],
	['PgUP', 201],
	['PgDown', 209],
	['Caps', 58],
	['A', 30],
	['B', 48],
	['C', 46],
	['D', 32],
	['E', 18],
	['F', 33],
	['G', 34],
	['H', 35],
	['I', 23],
	['J', 36],
	['K', 37],
	['L', 38],
	['M', 50],
	['N', 49],
	['O', 24],
	['P', 25],
	['Q', 16],
	['U', 22],
	['R', 19],
	['S', 31],
	['T', 20],
	['V', 47],
	['W', 17],
	['X', 45],
	['Y', 21],
	['Z', 44],
	['LShift', 42],
	['RShift', 54],
	['Up', 200],
	['Down', 208],
	['Left', 203],
	['Right', 205],
	['Num 0', 82],
	['Num 1', 79],
	['Num 2', 80],
	['Num 3', 81],
	['Num 4', 75],
	['Num 5', 76],
	['Num 6', 77],
	['Num 7', 71],
	['Num 8', 72],
	['Num 9', 73],
	['Num +', 78],
	['NUM', 69],
	['Num /', 181],
	['Num *', 55],
	['Num -', 74],
	['Num Enter', 156],
	['R Ctrl', 29],
	['L Ctrl', 157],
	['L Win', 220],
	['R Win', 219],
	['L Alt', 56],
	['Space', 57],
	['R Alt', 184],
	['App ', 221]

];

GW_RESTRICTED_KEYS = [
	1, // esc
	17, // w
	30, // a 
	32, // d
	69 // Num Lock Spam
];

initBinds = {	
	
	fireKeyDown = '';

	GW_KEYDOWN = nil;
	keyDown = true;

	waituntil {!(isNull (findDisplay 46))};

	(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call checkBinds; false"];
	(findDisplay 46) displayAddEventHandler ["KeyUp", "_this call resetBinds; false"];

	(findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call setMouseDown; false;"];
	(findDisplay 46) displayAddEventHandler ["MouseButtonUp", "_this call setMouseUp; false;"];

	setMouseDown = {			
		if ((_this select 1) == 0) then {  GW_LMBDOWN = true; };
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

	GW_KEYDOWN = nil;
};

checkBinds = {

	User1 = actionKeys "User1"; // Grab/drop
	User2 = actionKeys "User2"; // Attach / detach
	User3 = actionKeys "User3"; // Rotate CW 
	User4 = actionKeys "User4"; // Rotate CCW
	User5 = actionKeys "User5"; // Tilt Forward
	User6 = actionKeys "User6"; // Tilt Backward
	User20 = actionKeys "User20"; // Settings

	_key = _this select 1; // The key that was pressed
	_shift = _this select 2; 
	_ctrl = _this select 3; 
	_alt = _this select 4; 

	keyDown = true;	

	// Conditionals
	_vehicle = (vehicle player);
	_inVehicle = !(player == (_vehicle));
	_isDriver = (player == (driver (_vehicle)));	

	if (GW_BUY_ACTIVE) then {
		if (_key in [2,3,4,5,6,7,8,9,10,11]) exitWith {		
			[_key] spawn setQuantityUsingKey;
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

	if (_key in GW_RESTRICTED_KEYS) exitWith {};

	GW_KEYDOWN = _key;

	if (GW_SETTINGS_ACTIVE || GW_DEPLOY_ACTIVE || GW_SPAWN_ACTIVE) exitWith {};		

	// In Vehicle Keys
	if (_inVehicle && _isDriver && GW_CURRENTZONE != "workshopArea") then { 

		_status = _vehicle getVariable ["status", []];
		_canShoot = if (!GW_WAITFIRE && !('cloak' in _status)) then { true } else { false };
		_canUse = if (!GW_WAITUSE && !('cloak' in _status)) then { true } else { false };

		if (_canShoot) then {

			_weaponsList = _vehicle getVariable ["weapons", []];
			if (count _weaponsList == 0) exitWith {};
			{	

				_obj = _x select 1;
				_bind = _obj getVariable ["bind", -1];
				_bind = if (typename _bind == "STRING") then { parseNumber(_bind) } else { _bind };

				if (_bind >= 0 && _bind == _key) then {
				
					_tag = _x select 0;
			
					if (_tag in GW_WEAPONSARRAY && _canShoot) then {

						if (_tag == 'GUD' || _tag == 'MIS' || (_tag == 'MOR' && (count GW_LOCKEDTARGETS) > 0) )  then {

							GW_ACTIVE_WEAPONS = (GW_ACTIVE_WEAPONS - [_obj]) + [_obj];
							[_tag, _vehicle, "MANUAL"] spawn fireAttached;

						} else {

							if (count GW_AVAIL_WEAPONS == 0) exitWith {};

							{
								if ((_x select 0) == _obj) then {
									GW_ACTIVE_WEAPONS = (GW_ACTIVE_WEAPONS - [_obj]) + [_obj];
									[_tag, _vehicle, "MANUAL"] spawn fireAttached;
								};
								
								false 

							} count GW_AVAIL_WEAPONS > 0;

						};

					};	
				
				};	

				false

			} count _weaponsList > 0;

		};

		if (_canUse) then {

			_tacticalList = _vehicle getVariable ["tactical", []];
			if (count _tacticalList == 0) exitWith {};

			{
				_tag = _x select 0;
				_obj = _x select 1;
				_bind = _obj getVariable ["bind", -1];
				_bind = if (typename _bind == "STRING") then { parseNumber(_bind) } else { _bind };

				_exit = false;
				
				if (_bind >= 0 && _bind == _key) then {	

					_tag = _x select 0;			
					if (_tag in GW_TACTICALARRAY && _canUse) then {

						// If its a bag of explosives, just drop one bag
						if (_tag == "EPL") then { _exit = true; };
						[_tag, _vehicle] spawn useAttached;
					};						
				};	

				if (_exit) exitWith {};

				false 

			} count _tacticalList > 0;

		};

	};

	// Save
	if (_ctrl && _key == 31) exitWith {

		[''] spawn saveVehicle;
		//[''] execVM 'client\persistance\save.sqf';
	};

	// Preview
	if (_ctrl && _key == 24) exitWith {
		[] spawn previewMenu;
		//[''] execVM 'client\ui\preview.sqf';
	};

	// Editor Keys
	if ( GW_EDITING && !_inVehicle ) then {

		_object = player getVariable ["editingObject", nil];
		if (isNil "_object") exitWith {};
		
		if (_key in User1) then { [player, _object] spawn dropObj; }; 
		if (_key in User2) then { [player, _object] spawn attachObj; }; 
		if (_key in User3) then { [_object, 4.5] spawn rotateObj; };
		if (_key in User4) then { [_object, -4.5] spawn rotateObj; };	
				
		// Currently disabled due to bugginess
		// if (_key in User5) then { [_object, [-10, 0]] spawn tiltObj; }; 
		// if (_key in User6) then { [_object, [10, 0]] spawn tiltObj; }; 
	};

	// Outside Editor Keys
	if ( !GW_EDITING && !_inVehicle ) then {

		_object = cursorTarget;
		if (isNil "_object") exitWith {};

		_useable = _object getVariable ["isObject", false];
		if ( !_useable ) exitWith {};
		
		if (_key in User1) then { [_object, player] spawn moveObj; }; 
		
	};

	true

};

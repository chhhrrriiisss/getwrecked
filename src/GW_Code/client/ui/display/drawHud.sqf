//
//      Name: drawHud
//      Desc: Renders the hud in and out of a vehicle and handles visual effects for various vehicle statuses
//		Return: None
//

private ['_b', '_k', '_bindKeys', '_tag'];

disableSerialization;

if (GW_HUD_LOCK && isNil "GW_HUD_INITIALIZED") exitWith { false };
if (GW_HUD_LOCK) exitWith {
	GW_HUD_INITIALIZED = nil;
	10000 cutText ["", "PLAIN"];
	12000 cutText ["", "PLAIN"];
	false
};

if (isNil "GW_HUD_INITIALIZED") then {
	12000 cutRsc ["GW_HUD_Vehicle", "PLAIN"];
	10000 cutRsc ["GW_HUD", "PLAIN"];	
};

// Vehicle only hud
_layerVHud = ("GW_HUD_Vehicle" call BIS_fnc_rscLayer);
_vHud = uiNamespace getVariable "GW_HUD_Vehicle"; 

// Main hud
_layerHud = ("GW_HUD" call BIS_fnc_rscLayer);
_hud = uiNamespace getVariable "GW_HUD"; 

// Static effect
_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);	

// Gather all the control groups for use with tweening
_vHudSidebar = [
	(_vHud displayCtrl 12001),
	(_vHud displayCtrl 12002),
	(_vHud displayCtrl 12003),
	(_vHud displayCtrl 12004),
	(_vHud displayCtrl 12005),
	(_vHud displayCtrl 12006),
	(_vHud displayCtrl 12007),
	(_vHud displayCtrl 12008),
	(_vHud displayCtrl 12009)
];

_vHudBars = [
	(_vHud displayCtrl 13001),
	(_vHud displayCtrl 13002),
	(_vHud displayCtrl 13003),
	(_vHud displayCtrl 13004),
	(_vHud displayCtrl 13005),
	(_vHud displayCtrl 13006),
	(_vHud displayCtrl 13007),
	(_vHud displayCtrl 13008),
	(_vHud displayCtrl 13009)
];

_vHudIcons = [
	(_vHud displayCtrl 14001),
	(_vHud displayCtrl 14002),
	(_vHud displayCtrl 14003),
	(_vHud displayCtrl 14004),
	(_vHud displayCtrl 14005),
	(_vHud displayCtrl 14006),
	(_vHud displayCtrl 14007),
	(_vHud displayCtrl 14008),
	(_vHud displayCtrl 14009)
];

// Status information while in vehicle
_vHudIcon = (_vHud displayCtrl 12010);
_vHudFuel = (_vHud displayCtrl 12011);
_vHudAmmo = (_vHud displayCtrl 12012);
_vHudHealth = (_vHud displayCtrl 12013);
_vHudStatus = (_vHud displayCtrl 12014);
_vHudNotification = (_vHud displayCtrl 12017);
_vHudMoney = (_vHud displayCtrl 12016);

_hudStatusBox = [
	(_hud displayCtrl 11000),
	(_hud displayCtrl 11001),
	(_hud displayCtrl 11002),
	(_hud displayCtrl 11003),
	(_hud displayCtrl 11004)
];

// Information while out of a vehicle
_hudMoney = (_hud displayCtrl 10001);
_hudTransaction = (_hud displayCtrl 10002);
_hudStripesTopLeft = (_hud displayCtrl 10021);
_hudStripesBottomRight = (_hud displayCtrl 10022); 

// Race HUD info
_vHudRace = (_vHud displayCtrl 18020);
_vHudRaceTime = (_vHud displayCtrl 18021);
_vHudRacePlayer = (_vHud displayCtrl 18022);
_vHudRaceStart = (_vHud displayCtrl 18018);
_vHudRaceFinish = (_vHud displayCtrl 18019);

_vHudRaceOpponents = [];
_baseIDC = 18031;
_maxOpponents = GW_MAX_PLAYERS - 1;

for "_i" from 0 to (_maxOpponents-1) step 1 do {
	_marker = (_vHud displayCtrl (_baseIDC + _i));	
	_vHudRaceOpponents pushback _marker;
};

_vHudRaceInfo = [
	_vHudRace,
	_vHudRaceTime,
	_vHudRacePlayer,
	_vHudRaceStart,
	_vHudRaceFinish
];

_vHudRaceInfo append _vHudRaceOpponents;

if (isNil "GW_HUD_INITIALIZED") then {	

	// _layerStatic cutRsc ["RscStatic", "PLAIN" , 1];

	// Iterate through all the controls and ensure they are not visible to start
	_count = (count _vHudBars -1);
	{	
		[[ _x, (_vHudSidebar select _count), (_vHudIcons select _count)],  [['fade', 0, 1, 0]], "quad"] spawn createTween;
		_count = _count - 1;
	} count _vHudBars > 0;		

	[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification, _vHudRaceInfo], [['fade', 0, 1, 0]], "quad"] spawn createTween;
	[[_hudStripesTopLeft, _hudStripesBottomRight], [['fade', 1, 0, 1.2]], "quad"] spawn createTween;

	GW_HUD_INITIALIZED = true;		
	GW_HUD_VEHICLE_ACTIVE = false;
	GW_HUD_NORMAL_ACTIVE = false;
	GW_HUD_REFRESH = true;
	GW_HUD_RACE_ACTIVE = false;

};

if (GW_HUD_LOCK) exitWith { true };

if (!GW_INVEHICLE && !GW_ISDRIVER) then {

	if (!GW_HUD_NORMAL_ACTIVE) then {		
		GW_HUD_NORMAL_ACTIVE = true;	
		[[_hudMoney, _hudTransaction], [['fade', 1, 0, 1.2]], "quad"] spawn createTween;

	};

	// Set money/balance information
	_balance = profileNamespace getVariable [GW_BALANCE_LOCATION, 0];
	_balanceColour = if (_balance <= 10) then { '#ff0000' } else { '#ffffff' };
	_hudMoney ctrlSetStructuredText parseText ( (format["<img size='1.5' align='center' valign='top' image='%1' /> <t size='1.3' color='%2' align='center'>$%3</t>", balanceIcon, _balanceColour, ([_balance] call numberToCurrency)]) );
	_hudMoney ctrlCommit 0;

} else {

	if (GW_HUD_NORMAL_ACTIVE) then {
		GW_HUD_NORMAL_ACTIVE = false;
		[[_hudMoney, _hudTransaction], [['fade', 0, 1, 0.25]], "quad"] spawn createTween;
	};

};

_vHudModuleList = [];	
_vHudIconsArray = [];

if (GW_INVEHICLE && GW_ISDRIVER) then {

	_inRace = if (!isNil "GW_CURRENTRACE" && { ([GW_CURRENTRACE] call checkRaceStatus >= 2) }) then { 

		if (!GW_HUD_RACE_ACTIVE) then {
			GW_HUD_RACE_ACTIVE = true;
			[_vHudRaceInfo, [['fade', 1, 0, 0]], "quad"] spawn createTween;
		};

		// Check these items aren't faded
		{
			if (ctrlFade _x > 0) then {
				_x ctrlSetFade 0;
				_x ctrlCommit 0.25;
			};
		} count [
			_vHudRaceStart,
			_vHudRaceFinish,
			_vHudRacePlayer,
			_vHudRaceTime,
			_vHudRace
		];

		_vHudRaceX = 0.25;
		_vHudRaceRange = 0.5;

		// Loop through vehicles in current race, retrieve progress and update bar
		_baseIDC = 18031;
		{	


			// Ignore our own vehicle
			if (_x == GW_CURRENTVEHICLE) then {} else {
				_progress = [ (_x getVariable ['GW_R_PR', 0]), 0, 1] call limitToRange; 
				disableSerialization;
				_marker = (_vHud displayCtrl (_baseIDC + _forEachIndex));	
				_marker ctrlSetFade 0;
				_marker ctrlCommit 0;

				_color = '';
				_size = 1.5;
				_iconToUse = if (!alive _x && _progress < 1) then { _size = 1.7; _color = '#ff0000'; noTargetIcon } else { 
					if (_progress == 0) exitWith { blankIcon };
					raceOpponent 
				};

				_marker ctrlSetStructuredText parseText (format["<img size='%3' color='%2' image='%1' />", _iconToUse, _color, _size]);

				_marker ctrlSetPosition [(((_progress * _vHudRaceRange) + _vHudRaceX) - 0.02) * safezoneW + safezoneX, (ctrlPosition _marker) select 1];
				_marker ctrlCommit 1.5;
			};
			false
		} foreach (((GW_CURRENTRACE call getRaceID) select 0) select 5);

		// Update our own progress		
		_vHudRacePlayer ctrlSetPosition [(((GW_CURRENTRACE_PROGRESS * _vHudRaceRange) + _vHudRaceX) - 0.02) * safezoneW + safezoneX, (ctrlPosition _vHudRacePlayer) select 1];

		// Calculate how long race has been running
		_timeSince = serverTime - ((((GW_CURRENTRACE call getRaceID) select 0) select 0) select 5);

		_vHudRaceTime ctrlSetStructuredText parseText ( format["<t size='1.25' color='#ffffff' align='center'>+%1</t>", _timeSince call formatTimestamp ] );
		_vHudRacePlayer ctrlSetStructuredText parseText ( format["<img size='1.5' image='%1' /><t size='1' color='#ffffff' align='left'>%2</t>", racePlayer, name player ] );		

		if (GW_POWERUP_ACTIVE) then { 
			if (ctrlFade _vHudRaceTime < 1) then { _vHudRaceTime ctrlSetFade 1; };
		} else {
			if (ctrlFade _vHudRaceTime > 0) then { _vHudRaceTime ctrlSetFade 0; };
		};

		_vHudRace ctrlCommit 0;
		_vHudRaceTime ctrlCommit 0;
		_vHudRacePlayer ctrlCommit _this;

	} else {

		if (GW_HUD_RACE_ACTIVE) then {
			GW_HUD_RACE_ACTIVE = false;
			[_vHudRaceInfo, [['fade', 0, 1, 0.5]], "quad"] spawn createTween;
		};
	};

	// Set available bars to modulelist length
	if ((count _vHudModuleList) > (count _vHudBars)) then { _vHudModuleList resize ((count _vHudBars) -1); };	

	if (!GW_HUD_VEHICLE_ACTIVE || GW_HUD_REFRESH) then {
		
		// Calculate a list of current modules on the vehicle
		{
			_tag = _x getVariable ['GW_Tag', ''];
			if ( !(_tag in _vHudModuleList) && (_tag in GW_WEAPONSARRAY || _tag in GW_TACTICALARRAY)) then { _vHudModuleList pushBack _tag; };
			false
		} count attachedObjects GW_CURRENTVEHICLE > 0;

		GW_HUD_VEHICLE_ACTIVE = true;	

		if (GW_HUD_REFRESH) then {			
			GW_HUD_REFRESH = false;

			// Initially set vehicle bars to hidden
			_count = 0;
			{
				[[(_vHudBars select _count), (_vHudSidebar select _count), (_vHudIcons select _count)], [['fade', 0, 1, 0]], "quad"] spawn createTween;	
				_count = _count + 1;
				false
			} count _vHudBars > 0;

		} else {
			_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];
		};

		// Fade in Vehicle HUD elements
		[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification], [['fade', 1, 0, 0.1]], "quad"] spawn createTween;
		_vHudIcon ctrlSetStructuredText parseText ( format["<img size='2.4' align='center' valign='top' image='%1' />", [typeOf GW_CURRENTVEHICLE] call getVehiclePicture] );
		_vHudIcon ctrlCommit 0;
		
		// Don't fade in until vHudModuleList is ready
		if (count _vHudModuleList == 0) exitWith {};		
		for "_i" from 0 to (count _vHudModuleList) -1 step 1 do {
			[[(_vHudBars select _i), (_vHudSidebar select _i), (_vHudIcons select _i)], [['fade', 1, 0, 0.5]], "quad"] spawn createTween;	
		};

		// _count = 0;
		// {
		// 	_barsToFade = [];



		// 	[[(_vHudBars select _count), (_vHudSidebar select _count), (_vHudIcons select _count)], [['fade', 1, 0, 0.5]], "quad"] spawn createTween;	
		// 	_count = _count + 1;

		// 	false
		// } count _vHudModuleList > 0;		

	};

	// 
	// 
	// 	Health, fuel, money status
	// 
	// 

	_blink = if (round (time) % (_this * 0.75) == 0) then { true } else { false };

	// Fuel Status
    _fuel = fuel GW_CURRENTVEHICLE + (GW_CURRENTVEHICLE getVariable ["fuel", 0]);
    _maxFuel = GW_CURRENTVEHICLE getVariable ["maxFuel", 1];
    _actualFuel = round ( (_fuel / _maxFuel) * 100 );
    _actualFuel = [_actualFuel, 0, 100] call limitToRange;	

	// Ammo Status
    _ammo = GW_CURRENTVEHICLE getVariable ["ammo", 0];
    _maxAmmo = GW_CURRENTVEHICLE getVariable ["maxAmmo", 1];
    _actualAmmo = round( (_ammo / _maxAmmo) * 100);
	_actualAmmo = [_actualAmmo, 0, 100] call limitToRange;	

	// Money Status
	_balance = profileNamespace getVariable [GW_BALANCE_LOCATION, 0];
	_balanceColour = if (_balance <= 10) then { '#ff0000' } else { '#ffffff' };

	// Commit all of the above
	_vHudFuelIcon = if (_actualFuel > 10) then { fuelIcon } else { fuelEmptyIcon };
    _vHudFuel ctrlSetStructuredText parseText ( format["<img size='1.15' align='center' valign='bottom' shadow='0' image='%1' /><t size='0.82' align='center'>%2%3</t>  ", _vHudFuelIcon, _actualFuel, '%'] );		
    _vHudAmmo ctrlSetStructuredText parseText ( format["<img size='1.15' align='center' valign='bottom' shadow='0' image='%1' /><t size='0.82' align='center'>%2%3</t>  ", ammoIcon, _actualAmmo, '%'] );
	_vHudMoney ctrlSetStructuredText parseText ( (format["<t size='1' color='%1' align='center'>$%2</t>", _balanceColour, ([_balance] call numberToCurrency)]) );

	_vHudFuel ctrlCommit 0;
	_vHudAmmo ctrlCommit 0;	
	_vHudMoney ctrlCommit 0;	

	// Calculate reload times for each module   
	_weaponsArray = GW_CURRENTVEHICLE getVariable ['weapons', []];
    _tacticalArray = GW_CURRENTVEHICLE getVariable ['tactical', []];        
   		     
	_c = 0;
	{
		_tag = _x;
		_hasType = [_tag, GW_CURRENTVEHICLE] call hasType;
		_relArray = if (_tag in GW_WEAPONSARRAY) then { _weaponsArray } else { _tacticalArray };

		// If the type is missing
		if (_hasType <= 0) then {} else {

			// If there's more than one of these items, get the timeout to check all tags of that type
			_state = [_tag, time] call checkTimeout;
			_totalOnTimeout = (_state select 2);

			// Determine what's the correct reload time for the number of modules
			_reloadTime = ([_tag] call getTagData) select 0;		
			_adjustedReloadTime = (_reloadTime * _hasType);
			_timeLeft = (_state select 0);

			_pos = if ((_state select 1) && {_timeLeft > 0} && {!isNil "_reloadTime"} && {_tag != "EPL"}) then {
				(1 - (_timeLeft / _adjustedReloadTime)) 
			} else { 1 };

			_pos = switch (_tag) do {

				case "CLK": { (_actualAmmo / 100) };
				case "OIL": { (_actualFuel / 100) };
				case "FLM": { (_actualFuel / 100) };
				case "THR": { (_actualFuel / 100) };
				case "NTO": { (_actualFuel / 100) };
				default { _pos };

			};
			
			// Use the cache if we've already found an icon for this tag
			_icon = nil;
			{ 
				if (_tag == (_x select 0)) exitWith { _icon = (_x select 1); false };
				false
			} count _vHudIconsArray;

			// Otherwise find the icon using getData
			_icon = if (isNil "_icon") then {
				_data = [_tag, GW_LOOT_LIST] call getData; 
				if (!isNil "_data") exitWith { _vHudIconsArray pushBack [_tag, (_data select 9)]; (_data select 9) };
				""
			} else { _icon };		

			_bindKeys = '';
			{
				_exit = false;
				if ((_x select 0) == _tag) then {

					_exit = if (_tag == "EPL") then { true } else { false };
					_b = (_x select 1) getVariable ["GW_KeyBind", ["-1", "1"]];
					_b = if !(_b isEqualType []) then { [str _b, "1"] } else { _b };
					_k = if !((_b select 0) isEqualType "") then { 
						"-1"
					} else { 
						if ((_b select 0) == "-1") exitWith { "-1" };
						([parseNumber(_b select 0)] call codeToKey) 
					};					
					_k = if (_k != "-1") then { format[' [ %1 ]', _k] } else {''};			
					_bindKeys = format['%1%2', _bindKeys, _k];

				};
				if (_exit) exitWith {};

			} count _relArray > 0;

			(_vHudIcons select _c) ctrlSetStructuredText parseText ( format["<img size='1.2' align='center' valign='middle' shadow='0' image='%3' /><t size='0.5' shadow='0' valign='middle' align='center' color='#ffc730'> %1</t>", _bindKeys, { if (count toArray _bindKeys > 0) exitWith { 'right' }; 'center' }, _icon] );	
			
			if (progressPosition (_vHudBars select _c) != _pos) then {
				(_vHudBars select _c) progressSetPosition _pos;		
			};

			_c = _c + 1;

		};

		false

	} count _vHudModuleList > 0;  

	// For each module, show its icon
	for "_i" from 0 to count _vHudIcons step 1 do {
		(_vHudIcons select _i) ctrlCommit 0;
		(_vHudBars select _i) ctrlCommit 0;
	};

	// Hud Status & Visual Effects			
    if (count GW_VEHICLE_STATUS == 0) then {
            
        "dynamicBlur" ppEffectEnable false; 
        "dynamicBlur" ppEffectAdjust [0]; 
        "dynamicBlur" ppEffectCommit 0; 

        "colorCorrections" ppEffectEnable false; 
        "colorCorrections" ppEffectCommit 0;
       
        "colorCorrections" ppEffectEnable false; 
        "filmGrain" ppEffectCommit 0; 

        _vHudStatus ctrlSetStructuredText parseText( "" );
		_vHudStatus ctrlCommit 0;

    } else {

    	_string = '';

    	// Add a notification icon to the vehicle picture (if said icon exists)
        {
        	_icon = _x call {

        		if (_this == "nofuel") exitWith { fuelIcon };
        		if (_this == "noammo") exitWith { ammoIcon };
        		if (_this == "emp") exitWith {warningIcon };
        		if (_this == "tyresPopped") exitWith { warningIcon };
        		if (_this == "invulnerable") exitWith { shieldIcon };
        		if (_this == "fire" || _this == "inferno") exitWith { flameIcon };
        		if (_this == "locked") exitWith { lockedIcon };
        		if (_this == "locking") exitWith { lockingIcon };
        		if (_this == "radar") exitWith { radarSupplyIcon };
        		if (_this == "nanoarmor") exitWith { armorSupplyIcon };
        		if (_this == "overcharge") exitWith { speedSupplyIcon };
        		""
        	};

        	if (_icon != '') then {
        		_colour = '#ff0000';
	        	_string = format["%1<img size='2.7' color='%2' align='center' valign='top' image='%3' />", _string, _colour, _icon];
			};	

			false

    	} count GW_VEHICLE_STATUS > 0;    

    	// Blink the icon on and off
    	if (count toArray _string > 0) then {

    		if (ctrlCommitted _vHudStatus) then { 

    			_str = parseText '';
    			_fade = if (ctrlFade _vHudStatus >= 1) then { 0 } else { _str = parseText (_string); 1 };

	    		_vHudStatus ctrlShow true;
	    		_vHudStatus ctrlSetFade _fade;
	    		_vHudStatus ctrlSetStructuredText _str;
				_vHudStatus ctrlCommit 0.5;

			};
		};

		// Show alerts for some specific status effects
		if ("tyresPopped" in GW_VEHICLE_STATUS) then {
            [localize "str_gw_wheels_disabled", _this, warningIcon, colorRed, "warning", "beep_warning"] spawn createNotification;
        };
       
        if ("invulnerable" in GW_VEHICLE_STATUS) then {

            //[localize "str_gw_invulnerable", 1, shieldIcon, colorRed, "warning"] spawn createAlert;
            [localize "str_gw_invulnerable", _this, shieldIcon, colorRed, "slideup"] spawn createNotification;

            if (!ctrlCommitted _vHudStatus) then {} else {
				_vHudStatus ctrlSetStructuredText parseText( "" );
				_vHudStatus ctrlCommit 0.75;
			};                  

        };

        if ("fire" in GW_VEHICLE_STATUS) then {
            [localize "str_gw_fire_detected", _this, flameIcon, colorRed, "warning", "beep_warning"]  spawn createNotification;   
        };
 
        if ("locked" in GW_VEHICLE_STATUS) then {
            [localize "str_gw_lock_detected", _this, rpgTargetIcon, colorRed, "slideup", "beep_warning"]  spawn createNotification;   
        };

        if ("emp" in GW_VEHICLE_STATUS) then {

            [localize "str_gw_disabled", _this, warningIcon, colorRed, "warning", "beep_warning"] spawn createNotification;                 

            if (!ppEffectCommitted "dynamicBlur") then {} else {           
				_layerStatic cutRsc ["RscStatic", "PLAIN" ,1]; 
                "dynamicBlur" ppEffectEnable true; 
                "dynamicBlur" ppEffectAdjust [3]; 
                "dynamicBlur" ppEffectCommit (random _this);
            };                        
        };
	
    };



} else {

	if (GW_HUD_VEHICLE_ACTIVE) then {
		GW_HUD_VEHICLE_ACTIVE = false;

		_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];
		[localize "str_gw_connection_lost", 1, warningIcon, colorRed, "warning"] spawn createAlert;  

		// Fade Out Vehicle HUD  elements
		_count = 0;
		{
			[[(_vHudBars select _count), (_vHudSidebar select _count), (_vHudIcons select _count)], [['fade', 0, 1, 0]], "quad"] spawn createTween;	
			_count = _count + 1;
			false
		} count _vHudBars > 0;

		[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification, _vHudRaceInfo], [['fade', 0, 1, 0]], "quad"] spawn createTween;

	};

};

true
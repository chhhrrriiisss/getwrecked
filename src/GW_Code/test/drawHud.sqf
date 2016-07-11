//
//      Name: drawHud
//      Desc: Renders the hud in and out of a vehicle and handles visual effects for various vehicle statuses
//		Return: None
//

private ['_b', '_k', '_bindKeys', '_tag'];

if (GW_HUD_ACTIVE) exitWith {};
GW_HUD_ACTIVE = true;

disableSerialization;

12000 cutRsc ["GW_HUD_Vehicle", "PLAIN"];
_layerVHud = ("GW_HUD_Vehicle" call BIS_fnc_rscLayer);
_vHud = uiNamespace getVariable "GW_HUD_Vehicle"; 

10000 cutRsc ["GW_HUD", "PLAIN"];
_layerHud = ("GW_HUD" call BIS_fnc_rscLayer);
_hud = uiNamespace getVariable "GW_HUD"; 

// Gather all the control groups for use with tweening
_vHudSidebar = [
	(_vHud displayCtrl 12001),
	(_vHud displayCtrl 12002),
	(_vHud displayCtrl 12003),
	(_vHud displayCtrl 12004),
	(_vHud displayCtrl 12005),
	(_vHud displayCtrl 12006),
	(_vHud displayCtrl 12007),
	(_vHud displayCtrl 12008)
];

_vHudBars = [
	(_vHud displayCtrl 13001),
	(_vHud displayCtrl 13002),
	(_vHud displayCtrl 13003),
	(_vHud displayCtrl 13004),
	(_vHud displayCtrl 13005),
	(_vHud displayCtrl 13006),
	(_vHud displayCtrl 13007),
	(_vHud displayCtrl 13008)
];

_vHudIcons = [
	(_vHud displayCtrl 14001),
	(_vHud displayCtrl 14002),
	(_vHud displayCtrl 14003),
	(_vHud displayCtrl 14004),
	(_vHud displayCtrl 14005),
	(_vHud displayCtrl 14006),
	(_vHud displayCtrl 14007),
	(_vHud displayCtrl 14008)
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

// Iterate through all the controls and ensure they are not visible to start
_count = (count _vHudBars -1);
{	
	[[ _x, (_vHudSidebar select _count), (_vHudIcons select _count)],  [['fade', 0, 1, 0]], "quad"] spawn createTween;
	_count = _count - 1;
} count _vHudBars > 0;		

_moduleList = [];

[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification, _vHudRaceInfo], [['fade', 0, 1, 0]], "quad"] spawn createTween;
[[_hudStripesTopLeft, _hudStripesBottomRight], [['fade', 1, 0, 1.2]], "quad"] spawn createTween;


// Starting conditions and loop config
_refreshRate = 0.75; // How quickly the hud should update (faster can be buggier)

_blink = false;
_blinkCount = 0;
_blinkLimit = _refreshRate * 0.5;

_jammedActive = false;
_empActive = false;
_invActive = false;
_safeActive = false;
_boundsActive = false;
_fireActive = false;
_powerUpActive = false;
_lockedActive = false;
_status = [];
_lastStatusCount = 0;
_iconsArray = [];

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);

GW_HUD_RACE_ACTIVE = false;
GW_HUD_VEHICLE_ACTIVE = false;
GW_HUD_NORMAL_ACTIVE = false;
GW_HUD_REFRESH = false;

for "_i" from 0 to 1 step 0 do {

	_startTime = time;

	_inRace = if (isNil "GW_CURRENTRACE") then { false } else {
		IF ([GW_CURRENTRACE] call checkRaceStatus >= 2) exitWith { true };
		false
	};
	
	// Open the default HUD
	if (!GW_HUD_NORMAL_ACTIVE && (!GW_PREVIEW_CAM_ACTIVE || !GW_TIMER_ACTIVE) ) then {

		GW_HUD_NORMAL_ACTIVE = true;
		[[_hudMoney, _hudTransaction], [['fade', 1, 0, 1.2], ['y', '0', '0.1', 1.2]], "quad"] spawn createTween;
		
	};

	// Close the default HUD
	if (GW_HUD_NORMAL_ACTIVE && (GW_PREVIEW_CAM_ACTIVE || GW_TIMER_ACTIVE) ) then {

		GW_HUD_NORMAL_ACTIVE = false;
		[[_hudMoney, _hudTransaction], [['fade', 1, 0, 0], ['y', '0', '-0.1', 1.2]], "quad"] spawn createTween;
	};
	
	
	// We're in a vehicle
	if (GW_INVEHICLE && GW_ISDRIVER) then {		

		// We're in a race
		if (_inRace) then {

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

			_vHudRace ctrlCommit 0;
			_vHudRaceTime ctrlCommit 0;
			_vHudRacePlayer ctrlCommit 1.5;

		};	

		if (_inRace && (!GW_HUD_RACE_ACTIVE || GW_HUD_REFRESH)) then {
			GW_HUD_RACE_ACTIVE = true;
			[_vHudRaceInfo, [['fade', 1, 0, 0.5]], "quad"] spawn createTween;
		};


		// Calculate a list of current modules on the vehicle
		_moduleList = [];
		{
			_tag = _x getVariable ['GW_Tag', ''];
			if ( !(_tag in _moduleList) && (_tag in GW_WEAPONSARRAY || _tag in GW_TACTICALARRAY)) then {  _moduleList pushBack _tag; };
			false
		} count attachedObjects GW_CURRENTVEHICLE > 0;

		if ((count _moduleList) > (count _vHudBars)) then {
			_moduleList resize (count _vHudBars);
		};	

		// Open vehicle HUD
		if (!GW_HUD_VEHICLE_ACTIVE || GW_HUD_REFRESH) then {

			if (GW_HUD_REFRESH) then {
				GW_HUD_REFRESH = false;
				_count = 0;
				{
				
					[[(_vHudBars select _count), (_vHudSidebar select _count), (_vHudIcons select _count)], [['fade', 0, 1, 0]], "quad"] spawn createTween;	
					_count = _count + 1;

					false
				} count _vHudBars > 0;

			} else { _layerStatic cutRsc ["RscStatic", "PLAIN" , 1]; };			

			GW_HUD_VEHICLE_ACTIVE = true;				

			// Fade Out Player HUD 
			[[_hudMoney, _hudTransaction], [['fade', 0, 1, 0]], "quad"] spawn createTween;

			// Fade in Vehicle HUD, if 3rd person camera
			[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification], [['fade', 1, 0, 0.1]], "quad"] spawn createTween;
			_vHudIcon ctrlSetStructuredText parseText ( format["<img size='2.4' align='center' valign='top' image='%1' />", [typeOf GW_CURRENTVEHICLE] call getVehiclePicture] );
			_vHudIcon ctrlCommit 0;
				
			_count = 0;
			{
			
				[[(_vHudBars select _count), (_vHudSidebar select _count), (_vHudIcons select _count)], [['fade', 1, 0, 0.5]], "quad"] spawn createTween;	
				_count = _count + 1;

				false
			} count _moduleList > 0;		
			
		};

	} else {			

		// Close Vehicle HUD
		if (GW_HUD_VEHICLE_ACTIVE) then {

			_layerStatic cutRsc ["RscStatic", "PLAIN" , 0.5];

			[localize "str_gw_connection_lost", 1, warningIcon, colorRed, "warning"] spawn createAlert;  

			GW_HUD_VEHICLE_ACTIVE = false;
			GW_HUD_RACE_ACTIVE = false;

			// Fade Out Vehicle HUD 
			_count = (count _moduleList -1);
			{
				[[(_vHudBars select _count), (_vHudSidebar select _count), (_vHudIcons select _count)],  [['fade', 0, 1, 0]], "quad"] spawn createTween;
				_count = _count - 1;
				false
			} count _moduleList > 0;		

			[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification, _vHudRaceInfo], [['fade', 0, 1, 0]], "quad"] spawn createTween;

			_moduleList = [];

			// Fade In Player HUD 
			[[_hudMoney, _hudTransaction], [['fade', 1, 0, 0.1]], "quad"] spawn createTween;

		};

	};

	// Show the balance when the normal hud is active
	if (!GW_HUD_VEHICLE_ACTIVE && GW_HUD_NORMAL_ACTIVE) then {

		_balance = profileNamespace getVariable [GW_BALANCE_LOCATION, 0];
		_balanceColour = if (_balance <= 10) then { '#ff0000' } else { '#ffffff' };
		_hudMoney ctrlSetStructuredText parseText ( (format["<img size='1.5' align='center' valign='top' image='%1' /> <t size='1.3' color='%2' align='center'>$%3</t>", balanceIcon, _balanceColour, ([_balance] call numberToCurrency)]) );
		_hudMoney ctrlCommit 0;

	};

	// If the vehicle hud is active, populate it with data
	if (GW_HUD_VEHICLE_ACTIVE) then {

		// For use with alternating things on and off
		if (_blinkCount > _blinkLimit) then {                
            if (_blink) then { _blink = false; } else { _blink = true;  };        
            _blinkCount = 0;
        } else {          
            _blinkCount = _blinkCount + 1;
        };

        // Health status (kinda unused right now)
		_status = GW_VEHICLE_STATUS;

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

		_hornActive = if ("horn" in _status) then { true } else { false  };

		_vHudFuel ctrlCommit 0;
		_vHudAmmo ctrlCommit 0;	
		_vHudMoney ctrlCommit 0;	
		
		// Hud Status & Visual Effects			
        if (count _status == 0 && _lastStatusCount > 0) then {

 			_lastStatusCount = 0;
                
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

        	_lastStatusCount = count _status;

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

	    	} count _status > 0;    

	    	// Blink the icon on and off
	    	if (_blink && (count toArray _string > 0)) then {
	    		_vHudStatus ctrlShow true;
	    		_vHudStatus ctrlSetFade 1;
	    		_vHudStatus ctrlSetStructuredText parseText ( _string );
				_vHudStatus ctrlCommit 1;

			} else {
				_vHudStatus ctrlShow true;
				_vHudStatus ctrlSetFade 0;
				_vHudStatus ctrlSetStructuredText parseText( "" );
				_vHudStatus ctrlCommit 0;
			};
		
	    };

	    // if ("wrwy" in _status) then {
     //        ["WRONG WAY", 1, rotateCWIcon, colorRed, "warning", "beep_warning"] spawn createAlert;
     //    };

        if ("tyresPopped" in _status) then {
            [localize "str_gw_wheels_disabled", 1, warningIcon, colorRed, "warning", "beep_warning"] spawn createNotification;
        };
       
        if ("invulnerable" in _status) then {

            //[localize "str_gw_invulnerable", 1, shieldIcon, colorRed, "warning"] spawn createAlert;
            [localize "str_gw_invulnerable", 1, shieldIcon, colorRed, "slideup"] spawn createNotification;

            if (_blink) then {} else {
				_vHudStatus ctrlSetStructuredText parseText( "" );
				_vHudStatus ctrlCommit 0;
			};                  

        };

        if ("fire" in _status) then {
            [localize "str_gw_fire_detected", 1, flameIcon, colorRed, "warning", "beep_warning"]  spawn createNotification;   
        };
 
        if ("locked" in _status) then {
            [localize "str_gw_lock_detected", 1, rpgTargetIcon, colorRed, "slideup", "beep_warning"]  spawn createNotification;   
        };

        if ("emp" in _status) then {

            [localize "str_gw_disabled", 1, warningIcon, colorRed, "warning", "beep_warning"] spawn createNotification;                 

            if (_blink) then {} else {              
				_layerStatic cutRsc ["RscStatic", "PLAIN" ,1]; 
                "dynamicBlur" ppEffectEnable true; 
                "dynamicBlur" ppEffectAdjust [3]; 
                "dynamicBlur" ppEffectCommit 1;       
            };                        
        };

        _weaponsArray = GW_CURRENTVEHICLE getVariable ['weapons', []];
        _tacticalArray = GW_CURRENTVEHICLE getVariable ['tactical', []];        
       	
		// Calculate reload times for each module        
		_c = 0;
		{
			_tag = _x;
			_hasType = [_tag, GW_CURRENTVEHICLE] call hasType;
			_relArray = if (_tag in GW_WEAPONSARRAY) then { _weaponsArray } else { _tacticalArray };

			// If the type is missing
			if (_hasType <= 0) then {
		
			} else {

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
				} count _iconsArray;

				// Otherwise find the icon using getData
				_icon = if (isNil "_icon") then {
					_data = [_tag, GW_LOOT_LIST] call getData; 
					if (!isNil "_data") exitWith { _iconsArray pushBack [_tag, (_data select 9)]; (_data select 9) };
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

		} count _moduleList > 0;  

		// For each module, show its icon
		_c = 0;
		{
			_x ctrlCommit 0;
			(_vHudBars select _c) ctrlCommit 0;
			_c = _c + 1;

			false
			
		} count _vHudIcons;



		// If we're not disabled to any extent (or we've not been to a pad for 3 seconds)
		if ({ if (_x in GW_VEHICLE_STATUS) exitWith {1}; false } count ["emp", "disabled", "noservice"] isEqualTo 0) then { 

			_nearbyService = GW_CURRENTVEHICLE getVariable ["GW_NEARBY_SERVICE", nil];
			[GW_CURRENTVEHICLE] spawn checkTyres;

			if (!isNil "_nearbyService") then {   
				[GW_CURRENTVEHICLE, _nearbyService] call servicePoint;
			};
		};	

		// Check tyres aren't disabled
		[GW_CURRENTVEHICLE] spawn checkTyres;

		// Give a little bit of fuel if it looks like we're out
		if (fuel GW_CURRENTVEHICLE < 0.01 && !("emp" in GW_VEHICLE_STATUS)) then {
			GW_CURRENTVEHICLE setFuel 0.01;
		};

		// No status, reinflate tyres 
		if (count GW_VEHICLE_STATUS <= 0) exitWith {
			GW_CURRENTVEHICLE sethit ["wheel_1_1_steering", 0];
			GW_CURRENTVEHICLE sethit ["wheel_1_2_steering", 0];
			GW_CURRENTVEHICLE sethit ["wheel_2_1_steering", 0];
			GW_CURRENTVEHICLE sethit ["wheel_2_2_steering", 0];
		};	



	};
	
	['HUD Update', format['%1', ([(time - _startTime), 2] call roundTo)]] call logDebug;

	Sleep _refreshRate;

	if (!GW_HUD_ACTIVE || !alive player) exitWith {};

};

GW_HUD_ACTIVE = false;

10000 cutText ["", "PLAIN"];
12000 cutText ["", "PLAIN"];


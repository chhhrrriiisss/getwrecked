//
//      Name: drawHud
//      Desc: Renders the hud in and out of a vehicle and handles visual effects for various vehicle statuses
//		Return: None
//

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
_hudLogo = (_hud displayCtrl 10020);
_hudStripesTopLeft = (_hud displayCtrl 10021);
_hudStripesBottomRight = (_hud displayCtrl 10022); 

// Iterate through all the controls and ensure they are not visible to start
_count = (count _vHudBars -1);
{	
	[[ _x, (_vHudSidebar select _count), (_vHudIcons select _count)],  [['fade', 0, 1, 0]], "quad"] spawn createTween;
	_count = _count - 1;
} count _vHudBars > 0;		

_moduleList = [];

[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification], [['fade', 0, 1, 0]], "quad"] spawn createTween;
[[_hudStripesTopLeft, _hudStripesBottomRight], [['fade', 1, 0, 1.2]], "quad"] spawn createTween;

// Starting conditions and loop config
_refreshRate = 0.3; // How quickly the hud should update (faster can be buggier)

_blink = false;
_blinkCount = 0;
_blinkLimit = _refreshRate * 0.75;

_empActive = false;
_invActive = false;
_safeActive = false;
_boundsActive = false;
_fireActive = false;
_status = [];

toggleBlink = {
    if (_blink) then {
        _blink = false;
    } else {
        _blink = true;
    };        
};

_layerStatic = ("BIS_layerStatic" call BIS_fnc_rscLayer);

GW_HUD_VEHICLE_ACTIVE = false;
GW_HUD_NORMAL_ACTIVE = false;

while {GW_HUD_ACTIVE && alive player} do {

	_vehicle = (vehicle player);		
	_inVehicle = !(player == _vehicle);
	_isDriver = (player == (driver (_vehicle)));		
	_hasLockOns = _vehicle getVariable ["lockOns", false];

	// Open the default HUD
	if (!GW_HUD_NORMAL_ACTIVE && (!GW_PREVIEW_CAM_ACTIVE || !GW_TIMER_ACTIVE) ) then {
		GW_HUD_NORMAL_ACTIVE = true;

		[[_hudMoney, _hudTransaction], [['fade', 1, 0, 1.2], ['y', '0', '0.1', 1.2]], "quad"] spawn createTween;
		_hudLogo ctrlSetFade 0;
		_hudLogo ctrlCommit 1;
		
	};

	// Close the default HUD
	if (GW_HUD_NORMAL_ACTIVE && (GW_PREVIEW_CAM_ACTIVE || GW_TIMER_ACTIVE) ) then {
		GW_HUD_NORMAL_ACTIVE = false;

		_hudLogo ctrlSetFade 1;
		_hudLogo ctrlCommit 0;

		[[_hudMoney, _hudTransaction], [['fade', 1, 0, 0], ['y', '0', '-0.1', 1.2]], "quad"] spawn createTween;

	};
	
	// We're in a vehicle
	if (_inVehicle && _isDriver) then {		

		_weaponsList = _vehicle getVariable ["weapons", []];	
		_tacticalList = _vehicle getVariable ["tactical", []];	
		_totalList = _weaponsList + _tacticalList;

		// Calculate a list of current modules on the vehicle
		_moduleList = [];
		{
			_tag = _x select 0;

			if (_tag in _moduleList) then {} else {
				_moduleList set[ count _moduleList, _tag];
			};

			false

		} count _totalList > 0;

		if ((count _moduleList) > (count _vHudBars)) then {
			_moduleList resize (count _vHudBars);
		};

		// Open vehicle HUD
		if (!GW_HUD_VEHICLE_ACTIVE) then {

			_layerStatic cutRsc ["RscStatic", "PLAIN" , 1];

			GW_HUD_VEHICLE_ACTIVE = true;				

			// Fade Out Player HUD 
			[[_hudMoney, _hudTransaction, _hudLogo], [['fade', 0, 1, 0]], "quad"] spawn createTween;

			// Fade in Vehicle HUD 
			[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification], [['fade', 1, 0, 0.1]], "quad"] spawn createTween;
			_vHudIcon ctrlSetStructuredText parseText ( format["<img size='2.4' align='center' valign='top' image='%1' />", [typeOf _vehicle] call getVehiclePicture] );
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

			['CONNECTION LOST!', 1, warningIcon, colorRed, "warning"] spawn createAlert;  

			GW_HUD_VEHICLE_ACTIVE = false;

			// Fade Out Vehicle HUD 
			_count = (count _moduleList -1);
			{
				[[(_vHudBars select _count), (_vHudSidebar select _count), (_vHudIcons select _count)],  [['fade', 0, 1, 0]], "quad"] spawn createTween;
				_count = _count - 1;
				false
			} count _moduleList > 0;		

			[[_vHudIcon, _vHudFuel, _vHudAmmo, _vHudHealth, _vHudMoney, _vHudNotification], [['fade', 0, 1, 0]], "quad"] spawn createTween;

			_moduleList = [];

			// Fade In Player HUD 
			[[_hudMoney, _hudTransaction, _hudLogo], [['fade', 1, 0, 0.1]], "quad"] spawn createTween;

		};

	};

	// Show the balance when the normal hud is active
	if (!GW_HUD_VEHICLE_ACTIVE && GW_HUD_NORMAL_ACTIVE) then {

		_balance = profileNamespace getVariable ['GW_BALANCE', 0];
		_balanceColour = if (_balance <= 10) then { '#ff0000' } else { '#ffffff' };
		_hudMoney ctrlSetStructuredText parseText ( (format["<img size='1.5' align='center' valign='top' image='%1' /> <t size='1.3' color='%2' align='center'>$%3</t>", balanceIcon, _balanceColour, ([_balance] call numberToCurrency)]) );
		_hudMoney ctrlCommit 0;

	};

	// If the vehicle hud is active, populate it with data
	if (GW_HUD_VEHICLE_ACTIVE) then {

		// For use with alternating things on and off
		if (_blinkCount > _blinkLimit) then {                
            [] call toggleBlink;
            _blinkCount = 0;
        } else {          
            _blinkCount = _blinkCount + 1;
        };

        // Health status (kinda unused right now)
		_damage = getDammage _vehicle;    
	    _actualHealth = ((1 - _damage) * 100) max 0;
	    if(_actualHealth > 1) then { _actualHealth = floor _actualHealth } else { _actualHealth = ceil _actualHealth };
	    _actualHealth = [_actualHealth, 0, 100] call limitToRange;

		// Fuel Status
	    _fuel = fuel _vehicle + (_vehicle getVariable ["fuel", 0]);
	    _maxFuel = _vehicle getVariable ["maxFuel", 1];
	    _actualFuel = round ( (_fuel / _maxFuel) * 100 );
	    _actualFuel = [_actualFuel, 0, 100] call limitToRange;	

		// Ammo Status
	    _ammo = _vehicle getVariable ["ammo", 0];
	    _maxAmmo = _vehicle getVariable ["maxAmmo", 1];
	    _actualAmmo = round( (_ammo / _maxAmmo) * 100);
 		_actualAmmo = [_actualAmmo, 0, 100] call limitToRange;	

 		// Money Status
 		_balance = profileNamespace getVariable ['GW_BALANCE', 0];
		_balanceColour = if (_balance <= 10) then { '#ff0000' } else { '#ffffff' };

		// Commit all of the above
		_vHudFuelIcon = if (_actualFuel > 10) then { fuelIcon } else { fuelEmptyIcon };
	    _vHudFuel ctrlSetStructuredText parseText ( format["<img size='1.15' align='center' valign='bottom' shadow='0' image='%1' /><t size='0.82' align='center'>%2%3</t>  ", _vHudFuelIcon, _actualFuel, '%'] );		
	    _vHudAmmo ctrlSetStructuredText parseText ( format["<img size='1.15' align='center' valign='bottom' shadow='0' image='%1' /><t size='0.82' align='center'>%2%3</t>  ", ammoIcon, _actualAmmo, '%'] );
		_vHudMoney ctrlSetStructuredText parseText ( (format["<t size='1' color='%1' align='center'>$%2</t>", _balanceColour, ([_balance] call numberToCurrency)]) );
		_vHudFuel ctrlCommit 0;
		_vHudAmmo ctrlCommit 0;	
		_vHudMoney ctrlCommit 0;	
		
		// Hud Status & Visual Effects				
        _status = _vehicle getVariable ["status", []];  
        if (count _status <= 0) then {

            if (_empActive || _boundsActive || _fireActive || _invActive) then {

                _empActive = false;  
                _boundsActive = false;  
                _fireActive = false;
                _invActive = false;
                _safeActive = false;
                
                "dynamicBlur" ppEffectAdjust [0]; 
                "dynamicBlur" ppEffectCommit 0.5; 

                "colorCorrections" ppEffectEnable false; 
                "colorCorrections" ppEffectCommit 0;

                "filmGrain" ppEffectAdjust [0, 0, 0, 0, 0, true];  
                "filmGrain" ppEffectCommit 0.5; 

                _vHudStatus ctrlSetStructuredText parseText( "" );
				_vHudStatus ctrlCommit 0;

            };

        } else {

        	_string = '';

        	// Add a notification icon to the vehicle picture (if said icon exists)
	        {
	        	_icon = switch (_x) do {

	        		case "emp": { warningIcon };
	        		case "tyresPopped": { warningIcon };
	        		case "invulnerable": { shieldIcon };
	        		case "fire": { flameIcon };
	        		case "locked": { lockedIcon };
	        		case "locking": { lockingIcon };
	        		default {
	        			""
	        		};
	        	};

	        	if (_icon != '') then {
		        	_string = format["%1<img size='2.7' color='#ff0000' align='center' valign='top' image='%2' />", _string, _icon];
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

        if ("tyresPopped" in _status) then {
            ["WHEELS DISABLED!", 1, warningIcon, colorRed, "warning"] spawn createAlert;   
        };

        if ("invulnerable" in _status) then {

            ["INVULNERABLE!", 1, shieldIcon, colorRed, "warning"] spawn createAlert;

            if (_blink) then {
	            
			} else {
				_vHudStatus ctrlSetStructuredText parseText( "" );
				_vHudStatus ctrlCommit 0;
			};

            if (_invActive) then {} else {
                _invActive = true;

                "colorCorrections" ppEffectEnable true; 
                "colorCorrections" ppEffectAdjust [1, 0.3, 0, [1,1,1,-0.1], [1,1,1,2], [-0.5,0,-1,5]]; 
                "colorCorrections" ppEffectCommit 1;

            };                           

        };

        if ("fire" in _status) then {

            ["FIRE DETECTED!", 1, warningIcon, colorRed, "warning"] spawn createAlert;  

            if (_fireActive) then {} else {
                _fireActive = true;

                "colorCorrections" ppEffectEnable true; 
                "colorCorrections" ppEffectAdjust [1, 0.3, 0, [1,1,1,-0.1], [1,1,1,2], [-0.5,0,-1,5]];
                "colorCorrections" ppEffectCommit 1;
            };   

        };
 
        if ("locked" in _status) then {

            ["LOCK DETECTED!", 1, rpgTargetIcon, colorRed, "warning"] spawn createAlert;   

        };

        if ("emp" in _status) then {

            ["DISABLED!", 1, warningIcon, colorRed, "warning"] spawn createAlert;                  

            if (_empActive) then {} else {
                _empActive = true;                            
                _layerStatic cutRsc ["RscStatic", "PLAIN" ,2];       
                playSound3D ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_3.wss", (vehicle player), false, (visiblePosition (vehicle player)), 2, 1, 100]; 
                "dynamicBlur" ppEffectEnable true; 
                "dynamicBlur" ppEffectAdjust [2]; 
                "dynamicBlur" ppEffectCommit 1; 

                "filmGrain" ppEffectEnable true; 
                "filmGrain" ppEffectAdjust [0.1, 0.5, 2, 0, 0, true];  
                "filmGrain" ppEffectCommit 1;

            };    
          
            if (_blink) then {} else {
              
				_layerStatic cutRsc ["RscStatic", "PLAIN" ,1];  

                "dynamicBlur" ppEffectEnable true; 
                "dynamicBlur" ppEffectAdjust [3]; 
                "dynamicBlur" ppEffectCommit 1;       
            };                        
        };

       
		// Calculate reload times for each module        
		_c = 0;
		{
			
			_tag = _x;

			_state = [_tag, time] call checkTimeout;
			_reloadTime = ([_tag] call getTagData) select 0;
			_hasType = [_tag, _vehicle] call hasType;
			_actualReloadTime = _reloadTime * _hasType;

			_timeLeft = (_state select 0);
			_found = (_state select 1);
			_pos = if (_timeLeft > 0 && _found && !isNil "_reloadTime" && _tag != "EPL") then {
				(1 - (_timeLeft / _actualReloadTime)) 
			} else { 1 };

			if (_tag == "CLK") then {
				_pos = (_actualAmmo / 100);
			};

			if (_tag == "OIL" || _tag == "FLM") then {
				_pos = (_actualFuel / 100);
			};
			
			_data = [_tag, GW_LOOT_LIST] call getData;
			_icon = if (!isNil "_data") then { (_data select 9) } else { "" };
			(_vHudIcons select _c) ctrlSetStructuredText parseText ( format["<img size='1.2' align='center' valign='middle' shadow='0' image='%1' />", _icon] );	
			(_vHudBars select _c) progressSetPosition _pos;		

			_c = _c + 1;

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

	};

	Sleep _refreshRate;

};

GW_HUD_ACTIVE = false;

10000 cutText ["", "PLAIN"];
12000 cutText ["", "PLAIN"];


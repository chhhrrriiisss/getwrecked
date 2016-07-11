//
//      Name: initEvents
//      Desc: Periodically activates events on the server
//      Return: None
//

private ['_condition'];

if (!isServer) exitWith {};

if (isNil "GW_EVENTS_ACTIVE") then { GW_EVENTS_ACTIVE = false; };

if (GW_EVENTS_ACTIVE) then {
	GW_EVENTS_ACTIVE = false;
	waitUntil{ Sleep 1; (isNil "GW_EVENTS_ACTIVE") };
};

GW_EVENTS_LIST = [
	
	[	
		// Name of even
		"sponsorship",

		// Minimum time between checks
		120,

		// Condition to check for
		{
			( count (['workshopZone'] call findAllInZone) < (count allUnits) )
		},

		// Script to run on TRUE
		{

			_activeZones = [];
			{
				if ((_x select 1) isEqualTo "battle") then {
					_zoneName = format['%1%2', (_x select 0), 'Zone'];
					_inZone = ([_zoneName] call findAllInZone);
					if (count _inZone > 0) exitWith {
						
						{
							_lastPos = _x getVariable ['lastPos', [0,0,0]];
							_currentPos = getPosASL _x;
							_hasMoved = if ((_currentPos distance _lastPos) > 100) then { true } else { false };
							_x setVariable ['lastPos', _currentPos];

							if (_hasMoved) then {
								[		
									[],
									"giveSponsor",
									_x,
									false
								] call bis_fnc_mp;	 								
							};

							false
						} count _inZone > 0;

					};
				};									
				false
			} count GW_VALID_ZONES > 0;

		},

		// Script to run on FALSE
		{ true }
	],

	[
		// Name of event
		"supply", 

		// Minimum time between checks
		60, 

		// Condition to check for
		{ 
			((count (['workshopZone'] call findAllInZone) < (count allUnits)) && random 1 > 0.80)
		},

		// Script to run on TRUE condition
		{ 
			_activeZones = [];

			{
				if ((_x select 1) isEqualTo "battle") then {
					_zoneName = format['%1%2', (_x select 0), 'Zone'];
					if (count ([_zoneName] call findAllInZone) > 0) then {
						_activeZones pushBack _zoneName;
					};
				};									
				false
			} count GW_VALID_ZONES > 0;

			_selectedZone = _activeZones call BIS_fnc_selectRandom;
			if (isNil "_selectedZone") exitWith { false };
			if (_selectedZone == "workshopZone") exitWith { false };
			diag_log format['Supply box triggered for %2 at %1.', time, _selectedZone];

			// Don't create a new one if we're already at maximum
			if (GW_SUPPLY_ACTIVE >= GW_SUPPLY_MAX) exitWith { false };

			[(_selectedZone call findLocationInZone), true] spawn createSupplyDrop;

			true	

		},

		// Script to run on FALSE condition
		{ true }
	],

	// Ignore night + excess fog (looking at you Tanoa...)
	[
		// Name of event
		"env", 

		// Minimum time between checks
		10*60, 

		// Condition to check for
		{ ((daytime >= 17) || (daytime < 7)) },

		// Script to run on TRUE condition
		{ 
			_curTime = daytime;

			// Don't allow fog over 0.2
			if (fog > 0.2) then {
				30 setFog [0.2,0,0];
			};

			// Set time to loop (almost)
			if (_curTime >= 17) exitWith { skiptime (7 + (24 - _curTime)); true };
			if (_curTime < 7) exitWith { skiptime (7 - _curTime); true };

			true
		},

		// Script to run on FALSE condition
		{ true }
	],

	// Cleanup check
	[
		// Name of event
		"cleanup", 

		// Minimum time between checks
		5 * 60, 

		// Condition to check for
		{ TRUE },

		// Script to run on TRUE condition
		{ 

			// // Adjust cleanup frequency 
			// _rate = ( (count allPlayers) / GW_MAX_PLAYERS) call {
			// 	_this = [_this, 0, 1] call limitToRange;
			// 	if (_this >= 0.75) exitWith { GW_CLEANUP_RATE_HIGH };
			// 	if (_this >= 0.5) exitWith { GW_CLEANUP_RATE_MED };
			// 	GW_CLEANUP_RATE_LOW
			// };

			// GW_CLEANUP_TIMEOUT = time + _rate;
			// diag_log format['Running cleanup script at %1', time];

			[] call executeCleanUp;

			true
		},

		{ false }

	]

];


waitUntil {
    Sleep 1;
    serverTime > 0
};

if (!isServer) exitWith {};

if (isNil "GW_EVENTS_ACTIVE") then { 
	GW_EVENTS_ACTIVE = true; 
} else {
	GW_EVENTS_ACTIVE = false;
	_timeout = time + 5;
	waitUntil{ Sleep 1; (isNil "GW_EVENTS_ACTIVE" || time > _timeout) };
};

GW_EVENTS_ACTIVE = true;

diag_log format['Events check initialized at %1.', time];

// Pre calculate a list of event timeouts
_eventTimeouts = [];
{
    _eventTimeouts pushback [(_x select 0), serverTime - (_x select 1)];
    false
} count GW_EVENTS_LIST;

for "_i" from 0 to 1 step 0 do {

	if (!GW_EVENTS_ACTIVE) exitWith {};	

	if (round (time) % 30 == 0) then { diag_log format['Events system active [%1]', time]; };

    // Find what the current timeout is for this event
    {

    	_timeout = 0;
        _event = _x;
        _name = (_event select 0);
        _index = 0;
        if ({
            if ((_x select 0) == _name) exitWith { _timeout = (_x select 1); 1};
            _index = _index + 1;
            false
        } count _eventTimeouts > 0) then {                    

            _minTimeout = (_event select 1);

            // If minTimeout has not been reached and we're not a 0 second timeout
            if (_minTimeout != 0 && { (serverTime - _timeout < _minTimeout) }) exitWith {};

            // Update the timeout
            (_eventTimeouts select _index) set [1, serverTime];

            // Call trigger condition and execute fail/success functions
        	if (call (_event select 2)) then {

        		diag_log format['Running event [%1] at %2', _name, serverTime];	
        		[] call (_event select 3);

        	} else {

                // Call fail condition otherwise
                [] call (_event select 4);
            };

        };

    	false

	} count GW_EVENTS_LIST > 0;

	Sleep 1;	
	
};

diag_log format['Events check stopped at %1.', time];
GW_EVENTS_ACTIVE = nil;
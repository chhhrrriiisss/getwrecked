//
//      Name: initEvents
//      Desc: Periodically activates events on the server
//      Return: None
//

private ['_condition'];

if (!isServer) exitWith {};

if (isNil "GW_EVENTS_ACTIVE") then {
	GW_EVENTS_ACTIVE = false;
};

if (GW_EVENTS_ACTIVE) then {
	GW_EVENTS_ACTIVE = false;
	waitUntil{ Sleep 1; (isNil "GW_EVENTS_ACTIVE") };
};

_eventsList = [

	[
		"supply", // Name of event
		80, // Probability of event
		// Condition to check for
		{ 
			if (count (['workshopZone'] call findAllInZone) < (count allUnits)) exitWith { true };
			false
		},
		// Script to run on TRUE condition
		{ 
			_activeZones = [];

			{
				if ((_x select 1) != "safe") then {
					_zoneName = format['%1%2', (_x select 0), 'Zone'];
					if (count ([_zoneName] call findAllInZone) > 0) then {
						_activeZones pushBack _zoneName;
					};
				};									
				false
			} count GW_VALID_ZONES > 0;

			_length = random ((count _activeZones) -1);
			_selectedZone = _activeZones select (round _length);
			diag_log format['Supply box triggered for %2 at %1.', time, _selectedZone];

			// Don't create a new one if we're already at maximum
			if (GW_SUPPLY_ACTIVE >= GW_SUPPLY_MAX) exitWith { false };

			[(_selectedZone call findLocationInZone), true] spawn createSupplyDrop;

			true	

		}
	]

];

GW_EVENTS_ACTIVE = true;
diag_log format['Events check initialized at %1.', time];

for "_i" from 0 to 1 step 0 do {

	if (!GW_EVENTS_ACTIVE) exitWith {};	

	// Adjust timeout based on number of active players on server
	_timeout = ( (count allUnits) - (count (['workshopZone'] call findAllInZone)) ) call {
		if (_this > 8) exitWith { (GW_EVENTS_FREQUENCY select 2) };
		if (_this >= 4) exitWith { (GW_EVENTS_FREQUENCY select 1) };
		(GW_EVENTS_FREQUENCY select 0)
	};

    Sleep _timeout;
    diag_log format['Running events check at %1.', time];

    {

    	_chance = (_x select 1);
    	_rnd = random (100);

    	if (_rnd < _chance) then {
    		_condition = [] call (_x select 2);    		
    		if (_condition) then {
    			[] spawn (_x select 3);
    		};
    	};

    	false

	} count _eventsList > 0;
};

diag_log format['Events check stopped at %1.', time];
GW_EVENTS_ACTIVE = nil;
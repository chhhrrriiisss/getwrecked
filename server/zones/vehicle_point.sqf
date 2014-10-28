if (!isDedicated) then {
	
		_vehicle = _this select 0;
		_player = (driver _vehicle);

		_inUse = _vehicle getVariable ['inUse', false];
		if (!local _player || _inUse) exitWith {};
		_vehicle setVariable ['inUse', true];
		
		_startPos = getPosATL _vehicle;
		_limit = 7;
		_error = false;

		_a = _this select 1;
		_type = typeOf _vehicle;
		_reloadTime = 0.1;

		switch (_a) do {

				case "rearm":
				{	

					["REARMING...      ", 1, ammoIcon, nil, "flash"] spawn createAlert;
		
					_maxAmmo = _vehicle getVariable ["maxAmmo",1];
					_currentAmmo = _vehicle getVariable ["ammo",0];		

					while {_vehicle getVariable "ammo" < _maxAmmo} do {

						if (_vehicle distance _startPos > _limit) exitWith {
							_error = true;
						};

						_newAmmo = (_vehicle getVariable "ammo") + (_maxAmmo / 5);
						_vehicle setVariable["ammo", _newAmmo];
						Sleep 0.5;

						playSound3D ["a3\sounds_f\weapons\Reloads\1_reload.wss", _vehicle, false, getPos _vehicle, 3, 1, 20];					

					};
					
					if (!_error) then {
						_vehicle setVariable["ammo", _maxAmmo];
						["VEHICLE REARMED!", 0.5, successIcon, nil, "slideDown"] spawn createAlert;	
					};			
			
				};


				case "repair":
				{		
					["REPAIRED...      ", 1, healthIcon, nil, "flash"] spawn createAlert;
		

					while {getDammage _vehicle > 0} do {

						if (_vehicle distance _startPos > _limit) exitWith {
							_error = true;
						};

						_vehicle setDamage (getDammage _vehicle - 0.05);
						sleep 0.5;
					};				

					if (!_error) then {
						_vehicle setDamage 0;
						["VEHICLE REPAIRED!", 0.5, successIcon, nil, "slideDown"] spawn createAlert;
					};
					
			
				};

				case "refuel":
				{

					["REFUELLING...      ", 0.5, fuelIcon, nil, "flash"] spawn createAlert;						

					_maxFuel = _vehicle getVariable ["maxFuel",1];
					_extraFuel = _vehicle getVariable "fuel";
					_currentFuel = (fuel _vehicle) + (_vehicle getVariable ["fuel",0]);

					while {_currentFuel < _maxFuel} do {

						if (_vehicle distance _startPos > (_limit*2)) exitWith {
							_error = true;
						};

						_currentFuel = _currentFuel + (_maxFuel / 5);

						_allocated = (_currentFuel - 1);

						if (_allocated < 0) then {_allocated = 0};

						if (_allocated < 0) then {
							 _allocated = 0;
						};

						_vehicle setVariable["fuel", _allocated];
						_vehicle setFuel _currentFuel;
						sleep 0.5;
					};

					if (!_error) then {

						_vehicle setFuel 1;
						_vehicle setVariable ["fuel", (_maxFuel - 1)];						
						["VEHICLE REFUELLED!", 1, successIcon, nil, "slideDown"] spawn createAlert;

					};
					
				};

				default
				{					
					_error = true;					
				};



		};

		if (_error) then {
			["TOO FAR AWAY!", 2, warningIcon, colorRed, "warning"] spawn createAlert;		
		};		

		Sleep _reloadTime;

		_vehicle setVariable ['inUse', false];

		if (true) exitWith {};

};
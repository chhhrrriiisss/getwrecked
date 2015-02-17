//
//      Name: oilSlick
//      Desc: Drops patches of oil that have a chance of setting vehicles on fire
//      Return: None
//

private ["_obj"];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_vehicle = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj || isNull _vehicle) exitWith {};


// Creates a detector that runs intersect checks on all points in the oil array
createOilDetector = {
	 
	_timeout = time + 60;
	_v = _this select 0;
	GW_OIL_DETECTOR = true;

	while {alive _v && alive player && (count GW_OIL_ARRAY > 0) && time < _timeout} do {

		_lastPos = [0,0,0];
		_count = 0;

		{
			_o = (_x select 0);
			_t = (_x select 1);

			_p = if (typename _o == "OBJECT") then { getPosATL _o } else { _o };
			_p set [2, 1];		

			if ( ((ASLtoATL _p) distance [0,0,0]) < 100 || ((ASLtoATL _lastPos) distance [0,0,0]) < 100) then {} else {
				_p = (ATLtoASL _p);
				[_lastPos, _p, objNull, 100] spawn burnIntersects;					
				if (GW_DEBUG) then { [_lastPos, _p, 1] spawn debugLine; };		
			};

			_lastPos = _p;
			_count = _count + 1;

			false
			
		} count GW_OIL_ARRAY > 0;

		Sleep 0.5;
	};

	// Clean list of old triggers
	_count = 0;
	{
		_o = (_x select 0);
		_t = (_x select 1);
		if (_t < (time - 30)) then {

			if (typename _o == "OBJECT") then {
				deleteVehicle _o; 
				GW_WARNINGICON_ARRAY = GW_WARNINGICON_ARRAY - [_o];
				GW_DEPLOYLIST = GW_DEPLOYLIST - [_o];			
				GW_OIL_ARRAY deleteAt _count;
			};

		};
		
		_count = _count + 1;

		false
		
	} count GW_OIL_ARRAY;

	GW_OIL_ARRAY = GW_OIL_ARRAY - ['x'];

	// If there's still oil about
	if (count GW_OIL_ARRAY > 0) then {
		[_v] spawn createOilDetector;
	} else {
		GW_OIL_DETECTOR = nil;
	};

};

dropOil = {

	_oPos = _this select 0;
	_oDir = _this select 1;

	_oPos = [_oPos, 1.6, 1.6, 0] call setVariance;
	_oPos set[2, 0];

	_oil = createVehicle ["Oil_Spill_F", _oPos, [], 0, "CAN_COLLIDE"];
	_oil setDir _oDir;

	_dist = (_oPos distance GW_LASTPOS);

	GW_OIL_COUNT = GW_OIL_COUNT + 1;

	// Every 10m drop a trigger point
	if (GW_OIL_COUNT > 10) then {
		GW_OIL_ARRAY set[count GW_OIL_ARRAY, [_oil, time] ];		
		GW_OIL_COUNT = 0;
	};

	// Every 30m drop a warning icon
	if (_dist > 30) then {

		GW_LASTPOS = _oPos;
		
		[] spawn cleanDeployList;		
		GW_WARNINGICON_ARRAY pushBack _oil;
		GW_DEPLOYLIST pushBack _oil;
	};	

};

_oPos = [0,0,0];
GW_LASTPOS = [0,0,0];
GW_OIL_COUNT = 0;

playSound3D ["a3\sounds_f\sfx\explosion3.wss", _obj, false, _oPos, 2, 1, 100];

["DROPPING OIL ", 0.5, oilSlickIcon, nil, "default"] spawn createAlert;   

_fuel = fuel _vehicle + (_vehicle getVariable ["fuel", 0]);

GW_OIL_ACTIVE = true;

// If there's existing oil
if (!isNil "GW_OIL_ARRAY") then {
	GW_OIL_ARRAY set [count GW_OIL_ARRAY, [[0,0,0], time] ];
};

_cost = (['OIL'] call getTagData) select 1;

[_vehicle, player, _fuel, _cost] spawn {

	_v = _this select 0;
	_u = _this select 1;
	_f = _this select 2;
	_c = _this select 3;

	while {alive _v && alive _u && _f > 0.01 && !isNil "GW_OIL_ACTIVE"} do {

		_f = (fuel _v + (_v getVariable ["fuel", 0])) - _c;

		if (_f <= 0.01) exitWith {		
			["LOW FUEL!", 0.5, warningIcon, colorRed, "warning"] spawn createAlert;  
		};

		if (_f > 1) then {
			_v setFuel 1;
			_v setVariable ["fuel", (_f - 1)];
		} else {
			_v setFuel _f;
			_v setVariable ["fuel", 0];
		};

		// Ok, let's position it behind the vehicle
		_maxLength = ([_v] call getBoundingBox) select 1;
		_oPos = _v modelToWorld [0,(_maxLength * -1.5), 0];
		_oPos set[2,0];
		_oDir = (random 360);

		// If its the first trigger, start the checker
		if (isNil "GW_OIL_ARRAY") then {
			GW_OIL_ARRAY = [];
		};

		if (isNil "GW_OIL_DETECTOR") then {
			[_v] spawn createOilDetector;
		};

		[_oPos, _oDir] call dropOil;	

		Sleep 0.1;
	};

	GW_OIL_ACTIVE = nil;
	GW_LASTPOS = [0,0,0];


};

true
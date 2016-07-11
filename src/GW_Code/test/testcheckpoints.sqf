//
//      Name: testCheckpoints
//      Desc: 
//      Return: 
//

// Creates a series of checkpoints, waits for player to enter correctly 
_abortSequence = {
	
	_toDelete = _this;

	GW_CURRENTVEHICLE say "siren";
	[GW_CURRENTVEHICLE, 9999, 'client\images\lock_halo.paa',{ (alive GW_CURRENTVEHICLE) }, false] spawn createHalo;

	// Empty _cpArray
	{
		{
			deleteVehicle _x;
		} foreach (_x select 2);
	} foreach _toDelete;

};

// _points = [_this, 0, [], [[]]] call bis_fnc_param;
_points = [
	(vehicle player) modelToWorldVisual [0, 50, 0]
];

for "_i" from 1 to 2 step 1 do {
	_p = GW_CURRENTVEHICLE modelToWorldVisual [0 + ((random 50) - 25), 75*_i, 0];
	_p set [2, 0];
	_points set [_i, _p];
};

private ['_points', '_targetRace', '_startPosition', '_raceStatus', '_raceName'];

_targetRace = [_this, 0, [], [[], ""]] call bis_fnc_param;
_targetRace = if ((typename _targetRace) == "STRING") then { ((_targetRace call getRaceID) select 0) } else { _targetRace };
if (count _targetRace == 0) exitWith { hint 'Could not start - invalid race'; };

_points = [_targetRace, 1, _points, [[]]] call bis_fnc_param;
if (count _points == 0) exitWith { hint 'Could not start - bad point data'; };

_raceName = (_targetRace select 0) select 0;
_raceHost = _targetRace select 2;

_startPosition = _points select 0;
_firstPosition = _points select 1;
_raceStatus = [_targetRace, 3, -1, [0]] call filterParam;

_cpArray = [];
_dirNext = 0;
_totalCheckpoints = count _points;

// Clear any pre-existing icon checkpoints
if (count GW_CHECKPOINTS > 0) then { {  deletevehicle _x; } foreach GW_CHECKPOINTS;};
GW_CHECKPOINTS = [];
GW_CHECKPOINTS_COMPLETED = [];

// Create checkpoint halo as a guide
[GW_CURRENTVEHICLE, 9999, 'client\images\checkpoint_halo.paa',{ 

	_rT = _this select 0;
	_rB = _this select 1;

	if (count GW_CHECKPOINTS == 0) exitWith { false };
	_cP = GW_CHECKPOINTS select 0;

	_dirTo = [([GW_CURRENTVEHICLE, _cP] call dirTo) - (getDir GW_CURRENTVEHICLE)] call normalizeAngle;
	_dirToRB = [_dirTo + 180] call normalizeAngle;

	[_rT, [-90,0,_dirTo]] call setPitchBankYaw;
	[_rB, [90,0,_dirToRB]] call setPitchBankYaw;

	// _rT setDir _dirTo;
	// _rB setDir _dirTo;

	((alive GW_CURRENTVEHICLE) || (count GW_CHECKPOINTS > 0))

}, false, [0,2,0.5], true] spawn createHalo;

// Create CP markers at each point
{

	_objArray = [];
	_cPos = _x;

	_cp = "Sign_sphere100cm_F" createVehicleLocal _cPos;
	_dirNext = if (_forEachIndex == (count _points - 1)) then { _dirNext } else { ([_cPos, _points select (_forEachIndex + 1)] call dirTo) };
	_cp setDir _dirNext;
	hideObject _cp;
	_cp enableSimulationGlobal false;
	_cp hideObject true;

	_objArray pushBack _cp;

	_c = "Sign_Circle_F" createVehicleLocal _cPos;
	_c setPos [_cPos select 0, _cPos select 1, (_cPos select 2) - 5];
	_c setDir _dirNext;
	_c enableSimulationGlobal false;
	_c hideObject true;

	_objArray pushBack _c;

	// Add to checkpoint 3d icons array
	GW_CHECKPOINTS pushBack _c;

	{
		_t = "UserTexture10m_F" createVehicleLocal _cPos; 
		_t setObjectTextureGlobal [0,"client\images\stripes_fade.paa"]; 
		_offsetPos = (_cp modelToWorldVisual _x);
		_offsetPos set [2, 0.1];
		_t setPos _offsetPos;		

		if ((surfaceNormal _offsetPos) distance [0,0,1] > 0.1) then {
			hideObject _t;
		} else {
			[_t, [-90,0,[(_dirNext+180)] call normalizeAngle]] call setPitchBankYaw;  
		};

		_t enableSimulationGlobal false;
		_objArray pushBack _t;


	} foreach [
		[10,-4.8,0],
		[0,-4.8,0],
		[-10,-4.8,0]

	];
	
	_cpArray pushBack [_cp, _dirNext, _objArray];

} foreach _points;

// Otherwise just start
// GW_CURRENTVEHICLE setFuel 1;
// GW_CURRENTVEHICLE engineOn true;
// [GW_CURRENTVEHICLE, ["noshoot", "nouse"], 9999] call addVehicleStatus;

_maxTime = [_this, 1, 15, [0]] call bis_fnc_param;
_timeout = time + _maxTime;

hint '';
hint format['Race started! (%1s)', _maxTime];

_distTolerance = 10;
_dirTolerance = 80;
_startTime = time;

for "_i" from 0 to 1 step 0 do {

	if (count _cpArray == 0 || time > _timeout || !alive GW_CURRENTVEHICLE) exitWith {};

	_targetCp = (_cpArray select 0) select 0;

	// Unhide circle for current active CP
	_targetCpCircle= (((_cpArray select 0) select 2) select 1);
	if (isObjectHidden _targetCpCircle) then { _targetCpCircle hideObject false; };
	

	if ((GW_CURRENTVEHICLE distance _targetCp) < _distTolerance) then {

		// Remove shooting/use restrictions after first WP
		// if ((count GW_CHECKPOINTS_COMPLETED) == 0) then {
		// 	[GW_CURRENTVEHICLE, ["noshoot", "nouse"]] call removeVehicleStatus;
		// };

		// Requires correct orientation?
		_correctDir = (_cpArray select 0) select 1;
		_currentDir = getDir GW_CURRENTVEHICLE;
		_difDir = abs ([_currentDir - _correctDir] call flattenAngle);
		//if (_difDir > _dirTolerance) exitWith {};

		_group = ((_cpArray select 0) select 2);
		{ deleteVehicle _x; } foreach _group;

		_timeStamp = (time - _startTime) call formatTimeStamp;
		_timeStamp = format['+%1', _timeStamp];

		GW_CHECKPOINTS_COMPLETED pushback [(getpos ((_cpArray select 0) select 0)), _timeStamp, 1];
		_cpArray deleteAt 0;
		GW_CHECKPOINTS deleteAt 0;
		hint format['Reached checkpoint %1/%2!', _totalCheckpoints - (count _cpArray), _totalCheckpoints, time];
		GW_CURRENTVEHICLE say "blipCheckpoint";		

	};

	_timeLeft = [_maxTime - (time - _startTime), 0, 99999] call limitToRange;

	if (_timeLeft <= (_maxTime * 0.3) ) then {

		_timeLeft = (_timeout - time) call formatTimeStamp;
		hint format['-%1', _timeLeft];
		GW_CURRENTVEHICLE say "beepTarget";

	};

	Sleep 0.1;

};

_raceID =  ((_raceName call getRaceID) select 1);

_vehiclesArray = [GW_ACTIVE_RACES, _raceID, [], [[]]] call filterParam;
_vehiclesArray = [_vehiclesArray, 4, allPlayers, [[]]] call filterParam;

if ((count _cpArray) == 0 && time <= (_timeout + 0.1) ) then {
	hint format['Race complete! (%1s)', ([time - _startTime, 2] call roundTo)];	

	GW_CURRENTVEHICLE say "electronTrigger";
	GW_CURRENTVEHICLE say "summon";

	[
		[_raceName, GW_CURRENTVEHICLE],
		'endRace',
		false,
		false
	] call bis_fnc_mp;	

	//[] execVM 'testfinishcamera.sqf';

	// _timeStamp = (time - _startTime) call formatTimeStamp;
	// _text = format["<br /><t size='3.3' color='#ffffff' align='center' valign='middle' shadow='0'>+%1</t>", _timeStamp];

	// _done = [_text, "SPECTATE", false, { true }, 10] spawn createTitle;
	

	// _timeout = time + 10;
	// waitUntil {
	// 	Sleep 0.1;
	// 	((time > _timeout) || (scriptDone _done))
	// };

	// 9999 cutText ["", "BLACK OUT", 1]; 
	// Sleep 1; 
	// [] execVM 'testspectatorcamera.sqf';
	
	// [] execVM 'testfinishcamera.sqf';

	//_result = ['START', 5, false] call createTimer;
		
	GW_CHECKPOINTS = [];
	GW_CHECKPOINTS_COMPLETED = [];	

} else {
	hint format['Race failed! (Timeout)', time];
	_cpArray call _abortSequence;
};

if (alive GW_CURRENTVEHICLE) then {

	_timeStamp = (time - _startTime) call formatTimeStamp;

	// Show title if we have a time or DNC
	waitUntil { Sleep 0.1; (isNull (findDisplay 95000)) };
	[ format["<br /><t size='3.3' color='#ffffff' align='center' valign='middle' shadow='0'>+%1</t>", _timeStamp], "RESPAWN AT WORKSHOP", [false, { true }] , { true }, 9999, true, { closeDialog 0; true }] call createTitle;

	GW_FLYBY_ACTIVE = FALSE;

	9999 cutText ["", "BLACK OUT", 0.5];

	waitUntil { Sleep 0.5; (isNull (findDisplay 95000)) };

	GW_CURRENTVEHICLE call destroyInstantly;
	// [_vehiclesArray] execVM 'testspectatorcamera.sqf';

};

// Cleanup
{
	{ deleteVehicle _x; } foreach (_x select 2);
} foreach _cpArray;


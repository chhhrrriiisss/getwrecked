// systemchat 'running...';

if (!isNil "GW_OFFSET_ACTIVE") then { GW_OFFSET_ACTIVE = false; };
if (GW_OFFSET_ACTIVE) then {GW_OFFSET_ACTIVE = false; };

Sleep 1;

GW_OFFSET_ACTIVE = true;

_renderArrows = {

	_hasArrows = _this getVariable ['GW_ARROWS', false];
	if (_hasArrows) exitWith {};
	_this setVariable ['GW_ARROWS', true];
	
	_this spawn {

		_src = _this;
		_pos = _src modelToWorldVisual ([0,0,0.05] vectorAdd (boundingCenter _src));

		_trigger = "TargetP_Civ_F" createVehicleLocal ([(_pos select 0), (_pos select 1), (_pos select 2) + 4]);
		_trigger setPos ([(_pos select 0), (_pos select 1), (_pos select 2) + 4]);
		_trigger enableSimulationGlobal false;

		_yArrow = "Sign_arrow_direction_green_F" createVehicleLocal _pos; 
		_yArrow setPos _pos;
		[_yArrow, [90,0,(getDir _src)]] call setPitchBankYaw;

		_timeout = time + 2;
		waitUntil {
			Sleep 0.5;
			_arrows = _src getVariable ['GW_ARROWS', false];
			((time > _timeout) || (!alive _src) || (isNull attachedTo _src) || !_arrows)
		};

		deleteVehicle _yArrow;
		deleteVehicle _trigger;

		_src setVariable ['GW_ARROWS', false];

	};

};

waitUntil {
	
	_pos = (ASLtoATL visiblePositionASL player);
	_found = nil;

	{
		_isObject = _x call isObject;
		if (_isObject) then {

			_dist = _x distance _pos;
			if (_dist < 5) then {

				if (!isNull (attachedTo _x)) then {				

					_inScope = [([(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,4])] call dirTo), _x, 15] call checkScope;
					if (_inScope && isNil "_found") exitWith { _found = _x; };
					_x setVariable ['GW_ARROWS', false];
				};
			};
		};

		systemChat '';


	} foreach GW_NEARBY_OBJECTS;

	if (!isNil "_found") then {
		//systemchat format['%1 / %2', typeof _found, attachedTo _found];
		_found call _renderArrows;
	};
	

	_objs = lineIntersectsWith [(ATLtoASL positionCameraToWorld [0,4,8]), (ATLtoASL positionCameraToWorld [0,4,2]), objNull, player, true];
	[positionCameraToWorld [0,4,8], positionCameraToWorld [0,4,2], 0.01] call renderLine;
	systemChat format['%1', _objs];



	!GW_OFFSET_ACTIVE
};


//
// _firstCompile = _this getVariable ["firstCompile", false];
// if (!_firstCompile) then { [_this] call compileAttached; };


// {

// 	_attachPoint = _this worldToModelVisual (_x modelToWorldVisual [0,0,0]);
// 	systemchat format['%1 / %2', typeof _x, _attachPoint];
// 	_attachPoint set [2, (_attachPoint select 2) + 0.1];


// 	_x attachTo [_this, _attachPoint];

// } foreach (attachedObjects _this);

// Sign_arrow_f
// Sign_arrow_green_f
// Sign_arrow_blue_f
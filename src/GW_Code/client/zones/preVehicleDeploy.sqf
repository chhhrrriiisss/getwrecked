//
//      Name: preVehicleDeploy
//      Desc: Abort sequence prior to deployment
//      Return: None
//

params ['_vehicleToDeploy', '_unit'];
private ['_driver', '_vehicleToDeploy', '_success', '_unit'];

// If we're not the driver then make it happen
_vehicleToDeploy lockDriver false;
_driver = driver _vehicleToDeploy;
if (_unit != _driver) then { _unit moveInDriver _vehicleToDeploy; };

// Create a countdown timer with an abort option
//_canAbort =  [_this, 2, [true, true], [false]] call filterParam;


_canAbort = [true, true];
_success = ['ABORT', 5, _canAbort, true] call createTimer;

if (!_success) exitWith {

	// Eject from driver seat
	_driver = driver _vehicleToDeploy;
	if (_unit == _driver) then { _unit action ["eject", _vehicleToDeploy]; };

	// Check for items attached to the vehicle that might cause eject to go wrong
	_unit spawn {
		_timeout = time + 3;
		waitUntil {
			Sleep 0.25;
			((_this == (vehicle _this)) || (time > _timeout))
		};

		// Refresh HUD
		GW_HUD_ACTIVE = false;
		
		_objs = lineIntersectsWith [ATLtoASL (_this modelToWorldVisual [0,0,1.6]), ATLtoASL (_this modelToWorldVisual [0,5,1.6]), _this, objNull];
		if (count _objs == 0) exitWith {};
		_this setPos (_this modelToWorldVisual [0,5,0]);

		
	};

	// Notify and re-lock driver seat then retain ownership
	['ABORTED!', 2, warningIcon, colorRed, "warning"] spawn createAlert;   
	_vehicleToDeploy lock true;
	_vehicleToDeploy setVariable ['GW_Owner', (name _unit), true];

	false
};

true
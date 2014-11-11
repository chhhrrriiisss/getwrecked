//
//      Name: vehicleForks
//      Desc: Impale and attach hostile vehicles to the spikes
//      Return: None
//

private ["_targets", "_vehicle"];


_vehicle = _this select 0;

_vehiclePos =  (ASLtoATL visiblePositionASL _vehicle);
_nearby = _vehiclePos nearEntities [["Car"], 10];
if (count _nearby == 0) exitWith {};

{
	if ("Land_PalletTrolley_01_khaki_F" == (typeOf _x)) then {

		_fork = _x;
		_pos = _fork modelToWorldVisual [0,0,0];

		{
			_isVehicle = _x getVariable ["isVehicle", false];
			_status = _x getVariable ["status", []];

			if (_isVehicle && { _x != _vehicle } && { !('forked' in _status) }) exitWith {

				[       
	                [
	                    _x,
	                    ['forked'],
	                    10
	                ],
	                "addVehicleStatus",
	                _x,
	                false 
	        	] call BIS_fnc_MP;  

	        	_p = _fork worldToModelVisual (ASLtoATL visiblePositionASL _x);

	        	_p set [2, (ASLtoATL visiblePositionASL _fork) select 2];

	        	_x attachTo [_fork, _p];

	        	_x spawn {

	        		Sleep 5;
	        		detach _this;

	        	};

			};

		} ForEach _nearby;

	};
	false
} count (attachedObjects _vehicle) > 0;



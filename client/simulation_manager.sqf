//
//      Name: simulationManager
//      Desc: Disables simulation on far away objects to increase fps
//      Return: Bool
//

waitUntil{ !(isNil "GW_CURRENTZONE") };

#define CHECK_RATE 2
#define CHECK_DISTANCE 5
#define CHECK_DIRECTION 20
#define SIMULATION_RANGE 1700

GW_SIMULATION_MANAGER_ACTIVE = true;
_lastPos = [0,0,0];
_lastDir = 0;

for "_i" from 0 to 1 step 0 do {

	if (!GW_SIMULATION_MANAGER_ACTIVE) exitWith {};

	_currentPos = positionCameraToWorld [0,0,0];

	if ( (_currentPos distance _lastPos > CHECK_DISTANCE) && !GW_PREVIEW_CAM_ACTIVE && !GW_LIFT_ACTIVE) then {
		
		_lastPos = _currentPos;

		{

			_i = _x getVariable ['GW_IGNORE_SIM', false];

			if (_x == (vehicle player) || _i) then {} else {
			
				_d = _currentPos distance _x;

				if (_d < SIMULATION_RANGE) then {

					if (simulationEnabled _x) then {
						_x enableSimulation false;
					};

					if (!simulationEnabled _x) then {
						_x enableSimulation true;
					};
				};

				if (_d > SIMULATION_RANGE && simulationEnabled _x) then {
					_x enableSimulation false;
				};
				
			};
			
			false

		} count (allMissionObjects "Car") > 0;

		Sleep 0.01;		

	};

	Sleep CHECK_RATE;

};
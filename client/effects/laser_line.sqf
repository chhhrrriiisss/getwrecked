//
//      Name: laserLine
//      Desc: Creates a drawLine3D between two points and a dust effect at destination to simulate lasers, tracers etc
//      Return: None
//

if (isDedicated) exitWith {};

_this spawn {
		
	_colour = [1,0,0,1];
	_duration = 1;
	_packet = _this select 0;

	GW_LINEEFFECT_COLOR = _colour;
	GW_LINEFFECT_ARRAY pushback _packet;	

	_p1 = (_packet select 0);
	_p2 = (_packet select 1);

	_pos = if (typename _p2 == "OBJECT") then { visiblePositionASL _p2 } else { _p2 };		
	
	_isVisible = [_pos, _duration] call effectIsVisible;
	if (!_isVisible) exitWith { GW_LINEFFECT_ARRAY = []; };	
				
	_source = "#particlesource" createVehicleLocal _pos;
	_source setParticleCircle [0, [0, 0, 0]];
	_source setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
	_source setParticleParams [["\A3\data_f\Cl_water", 1, 0, 1], "", "Billboard", 3, 1.5, [0, 0, 0], [0, 0, 3], 0, 10, 7.9, 0.075, [1.3, 2.6, 5], [[0, 0, 0, 1], [0.15, 0.15, 0.15, 0.1], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _p2];
	_source setDropInterval 0.075;

	Sleep _duration;
	
	GW_LINEFFECT_ARRAY = GW_LINEFFECT_ARRAY - [_packet];

	Sleep 0.3;

	if (alive _source) then { deleteVehicle _source; };

};

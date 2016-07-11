//
//      Name: napalmEffect
//      Desc: Create a massive ball of fire at location
//      Return: None
//

private ['_target', '_pos', '_duration', '_size'];

_pos = [_this,0, [], [[]]] call filterParam;
if (count _pos == 0) exitWith {};

_objectsArray = [];

for "_i" from 0 to 4 step 1 do {

	_theta = random 360;

	_size = 0.75;

	_r = 7;
	_phi = 1;

	_rx = _r * (sin _theta) * (cos _phi);
	_ry = _r * (cos _theta) * (cos _phi);	

	_nPos = _pos vectorAdd [_rx, _ry, 0];

	_src = "Land_PenBlack_F" createVehicleLocal _nPos;
	[_src, 10, _size] spawn infernoEffect;
	_objectsArray pushback _src;
};	

for "_i" from 0 to 4 step 1 do {
	_src = "Land_PenBlack_F" createVehicleLocal _pos;	
	[_src, 10] spawn flameEffect;
	_src setVelocity [(random 22)-11, (random 22)-11, 15];	
	_objectsArray pushback _src;
};

_objectsArray spawn {	
	Sleep 10;
	{ deleteVehicle _x; } foreach _this;
};


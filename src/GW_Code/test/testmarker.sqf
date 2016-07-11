a1 = player;
a2 = "Land_penblack_f" createVehicle (player modelToWorld [0,0,0]);
a2 attachTo [a1, [0,5,0]];




// create some marker arrows
_markers = [];

_maxMarkers = [(a2 distance a1) / 10, 2, 30] call limitToRange;
_inc = [(a2 distance a1) / _maxMarkers, 0.1, 0.3] call limitToRange;

for "_i" from 0 to _maxMarkers do {
  _marker = "Sign_Arrow_F" createVehicle (player modelToWorld [0,10,0]);
  _markers pushBack _marker;
};

_timeout = time + 10;


systemchat format['marker test started at %1', time];


// repeatedly place those 4 markers between two helicopters (a1 & a2)
while {time < _timeout} do {

  for "_i" from 0 to (count _markers) -1 do {
    _time = (_i+1)*_inc; // arrows are at 0.2, 0.4, 0.6 & 0.8 intervals

   
    _arr = [getPosASL a1, getPosASL a2, velocity a1, velocity a2, vectorDir a1, vectorDir a2, vectorUp a1, vectorUp a2, _time];
    (_markers select _i) setVelocityTransformation _arr;
  };
};

systemchat format['marker test ended at %1', time];

{
	deleteVehicle _x;
} foreach _markers;
deleteVehicle a1;
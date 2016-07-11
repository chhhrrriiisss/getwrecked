//
//      Name: createCheckpoint
//      Desc: Create a checkpoint at the desired location
//      Return: Object array (Objects at the checkpoint)
//

params ['_index', '_cpArray'];	
private ['_index', '_cpArray'];	

_cPos = _cpArray select _index;

_objArray = [];
_dirNext = 0;

_dirNext = if (_index == (count _cpArray - 1)) then { _dirNext } else { ([_cPos, _cpArray select (_index + 1)] call dirTo) };

_cp = "Sign_Circle_F" createVehicleLocal _cPos;

_np = [_cPos select 0, _cPos select 1, (_cPos select 2) - 5];
_np = if (surfaceIsWater _cPos) then { _np } else { ASLtoATL _np };

_cp setPos _np;

_cp setDir _dirNext;
_cp enableSimulation false;

_objArray pushBack _cp;

{
	if ((surfaceNormal (_cp modelToWorldVisual _x)) distance [0,0,1] > 0.1 || surfaceIsWater _np) then {} else {

		_t = "UserTexture10m_F" createVehicleLocal _cPos; 
		_t setObjectTextureGlobal [0,"client\images\stripes_fade.paa"]; 
		_offsetPos = (_cp modelToWorldVisual _x);
		_offsetPos set [2, 0.1];
		_t setPos _offsetPos;	
		
		[_t, [-90,0, ( [(_dirNext+180)] call normalizeAngle )]] call setPitchBankYaw;  

		_t enableSimulation false;
		_objArray pushBack _t;

	};
	false
} count [
	[10,-4.8,0],
	[0,-4.8,0],
	[-10,-4.8,0]
];

_objArray
//
//      Name: createBoundary
//      Desc: Create a two-sided boundary texture at specified position
//      Return: None
//

_source = +(_this select 0);
_step = (_this select 1);

_source set[2, 0];				
_newDestination = [_source, _step, (_this select 2)] call BIS_fnc_relPos;

_isWater = (surfaceIsWater _newDestination);

_normal = if (_isWater) then {
	_newDestination = ATLtoASL (_newDestination);
	_newDestination set[2, 0];
	[0,0,1]
} else {
 	(surfaceNormal _newDestination)
};
	
_wallInside = createVehicle ["UserTexture10m_F", _newDestination, [], 0, "CAN_COLLIDE"]; 
_wallOutside = createVehicle ["UserTexture10m_F", _newDestination, [], 0, "CAN_COLLIDE"]; 

_wallInside setVariable ['GW_CU_IGNORE', true];
_wallOutside setVariable ['GW_CU_IGNORE', true];

if (_isWater) then {
	_wallInside setPosASL _newDestination;
	_wallOutside setPosASL _newDestination;
};

_wallInside setVectorDirAndUp [(_this select 3), _normal];
_wallOutside setVectorDirAndUp [(_this select 4), _normal];

_wallInside setObjectTextureGlobal [0,"client\images\stripes_fade.paa"];
_wallOutside setObjectTextureGlobal [0,"client\images\stripes_fade.paa"];

//
//	  swapVehicleTexture
//	  Desc: Temporarily swap the texture to another (with timeout)
//	  return (none)
//

private ['_vehicle', '_condition'];

_vehicle = [_this,0, objNull , [objNull]] call BIS_fnc_param;
_condition = [_this,3, { true } , [{}]] call BIS_fnc_param;

_selections = getObjectTextures (_this select 0);

{
	(_this select 0) setObjectTextureGlobal [_foreachindex, (_this select 1)];
} Foreach _selections;

_timeout = time + (_this select 2);

waitUntil{
	Sleep 0.1;
	(([] call _condition) || (time > _timeout))
};

for "_i" from 0 to 1 step 0 do {
	if ( !([] call _condition) || (time > _timeout) ) exitWith {};
	Sleep 0.1;
};

{
	(_this select 0) setObjectTextureGlobal [_foreachindex, _x];
} Foreach _selections;


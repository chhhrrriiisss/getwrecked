//
//      Name: detonateTargets
//      Desc: Detonates all explosives current deployed
//      Return: None
//

private ['_vehicle', '_dir', '_pos', '_alt', '_vel'];


_vehicle = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith {};

missionNamespace setVariable ["#FX", [_vehicle, 1]];
publicVariable "#FX";
playSound3D [
    "a3\sounds_f\weapons\other\sfx9.wss",
    _vehicle
];


_targets = _vehicle getVariable ["GW_detonateTargets", []];
if (count _targets == 0) exitWith {};

{
	_x setVariable ["triggered", true];
	false
} count _targets > 0;

_vehicle setVariable ["GW_detonateTargets", []];

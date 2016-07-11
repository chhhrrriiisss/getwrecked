//
//      Name: activateTeleport
//      Desc: Activates current teleport pad
//      Return: None
//

private ['_vehicle', '_dir', '_pos', '_alt', '_vel', '_target'];

_vehicle = [_this,0, objNull, [objNull]] call filterParam;

if (isNull _vehicle) exitWith {};

_targets = _vehicle getVariable ["GW_teleportTargets", []];
if (count _targets == 0) exitWith {  ['UNAVAILABLE', 0.5, warningIcon, colorRed, "warning"] spawn createAlert;   };

_state = ['TELP', time] call checkTimeout;
if (_state select 1) exitWith {	[format['PLEASE WAIT (%1s)', (_state select 0)], 0.5, warningIcon, nil, "flash"] spawn createAlert; };

missionNamespace setVariable ["#FX", [_vehicle, 1]];
publicVariable "#FX";
playSound3D [
    "a3\sounds_f\weapons\other\sfx9.wss",
    _vehicle
];

_target = nil;
{
	if ((_x distance _vehicle) > 50) exitWith { _target = _x; };
} count _targets > 0;

if (isNil "_target") exitWith {  ['TOO CLOSE!', 0.5, warningIcon, colorRed, "warning"] spawn createAlert;   };

[_target, _vehicle] spawn teleportTo;

_reloadTime = (['TPD'] call getTagData) select 0;	
['TELP', _reloadTime] call createTimeout;	

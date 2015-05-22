//
//      Name: setDirTo
//      Desc: Improved version of setDir that works irrespective of locality and attached items
//      Return: None
//

private ['_obj', '_ang'];

// If this object isn't local to here, execute setDir where it is
if (!local (_this select 0)) exitWith {

	[
		[(_this select 0), (_this select 1)],
		'setDirTo',
		(_this select 0),
		false
	] call gw_fnc_mp;	

};

_obj = [_this, 0, objNull, [objNull]] call filterParam;
_ang = [_this, 1, 0, [0]] call filterParam;

if (isNull _obj) exitWith {};
if (!alive _obj) exitWith {};

// If the object is attached to something
_ang = if (!isNull attachedTo _obj) then {	([_ang - getDir (attachedTo _obj)] call normalizeAngle) } else { _ang };

_obj setDir _ang;
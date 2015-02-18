//
//      Name: shockwaveEffect
//      Desc: Creates a shockwave that moves vehicles and players in the radius
//		Author: Original by iConic, modified by Sli
//		Return: None
//

_target = if (isNil {_this select 0 }) exitWith {};
_target = (_this select 0);

_radius =  if (isNil {_this select 1 }) then { 20 } else { (_this select 1) };
_force =  if (isNil {_this select 2 }) then { 25 } else { (_this select 2) };

_sourcePos = if (typename _target == "OBJECT") then { (ASLtoATL visiblePositionASL _target) } else { _target };

_objectList = _sourcePos nearEntities [["Car", "Man"], (_this select 1)];

if (count _objectList == 0) exitWith {};

{

	_objectVel = velocity _x;
	_objectDir = direction _x;

	_objectMass = getMass _x;
	_objectMass = if (isNil "_objectMass") then { 1000 } else { (_objectMass) };
	_distance = _x distance _sourcePos;

	_dis = _sourcePos vectorDiff (ASLtoATL visiblePositionASL _x);
	_shockX = sqrt((_this select 2) - (_dis select 0))*2;
	_shockY = sqrt((_this select 2) - (_dis select 1))*2;
	_shockZ = ((_this select 2) - _distance)/2;

	_shockX_F = (((_this select 2)/_objectMass)*(_this select 2))*_shockX;
	_shockY_F = (((_this select 2)/_objectMass)*(_this select 2))*_shockY;
	_shockZ_F = (((_this select 2)/_objectMass)*(_this select 2))*_shockZ;

	if ((_dis select 0) > 0) then {
		_shockX_F = -_shockX_F;
	};

	if ((_dis select 1) > 0) then {
		_shockY_F = -_shockY_F;
	};

	_shockX_F = ceil(random _shockX_F);
	_shockY_F = ceil(random _shockY_F);
	_shockZ_F = ceil(random _shockZ_F);

	_targetVelocity = [(_objectVel select 0) + (sin _objectDir * _shockX_F),(_objectVel select 1) + (cos _objectDir * _shockY_F),_shockZ_F];

	// Apply velocity to vehicle whether local or remote
	if (local _x) then {		
		_x setVelocity _targetVelocity;
	} else {
		[       
			[
				_x,
				_targetVelocity
			],
			"setVelocityLocal",
			_x,
			false 
		] call BIS_fnc_MP;  
	};

	false

} count _objectList > 0;
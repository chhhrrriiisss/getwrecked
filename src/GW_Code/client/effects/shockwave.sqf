//
//      Name: shockwaveEffect
//      Desc: Creates a shockwave that moves vehicles and players in the radius
//		Author: Original by iConic, modified by Sli
//		Return: None
//

params ['_target', '_radius', '_force'];

_target = if (_target isEqualType objNull) then { (ASLtoATL visiblePositionASL _target) } else { _target };
_radius = if (_radius isEqualType 0) then { _radius } else { 20 };
_force =  if (_force isEqualType 0) then { _force } else { 25 };

_objectList = _target nearEntities [["Car", "Man"], (_this select 1)];

if (count _objectList == 0) exitWith {};

{

	_objectVel = velocity _x;
	_objectDir = direction _x;

	_objectMass = if (isNil { getMass _x }) then { 1000 } else { (getmass _x) };
	if (_objectMass == 0) then { _objectMass = 2; };
		
	_distance = _x distance _target;

	_dis = _target vectorDiff (ASLtoATL visiblePositionASL _x);
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

	_targetVelocity = [
		([(_objectVel select 0) + (sin _objectDir * _shockX_F), -20, 20] call limitToRange),
		([(_objectVel select 1) + (cos _objectDir * _shockY_F), -20, 20] call limitToRange),
		([_shockZ_F, -20, 20] call limitToRange)
	];

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
		] call bis_fnc_mp;  
	};

	false

} count _objectList > 0;
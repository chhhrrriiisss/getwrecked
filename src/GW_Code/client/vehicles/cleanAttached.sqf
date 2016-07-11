
private ['_vehicle', '_currentWeapons', '_currentModules', '_maxModules', '_maxWeapons'];

_vehicle = _this;

_currentWeapons = 0;
_currentModules = 0;
_maxWeapons = _vehicle getVariable ['maxWeapons', 9999];
_maxModules = _vehicle getVariable ['maxModules', 9999];

{

	_tag =_x getVariable ['GW_Tag', ''];

	if (true) then {
		if (!alive _x) exitWith { deleteVehicle _x; };
		if (_x call isWeapon) then { if (_currentWeapons < _maxWeapons) then { _currentWeapons = _currentWeapons + 1; } else { deleteVehicle _x; }; };
		if (_x call isModule) then { if (_currentModules < _maxModules) then { _currentModules = _currentModules + 1; } else { deleteVehicle _x; }; };
	};

	false

} count (attachedObjects _vehicle) > 0;

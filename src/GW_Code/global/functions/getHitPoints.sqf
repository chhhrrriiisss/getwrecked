//
//      Name: getHitPoints
//      Desc: Returns hit point selections for specified vehicle class
//      Return: Array 
//

private ["_class", "_hitPoints", "_cfgVehicle", "_hitPointsCfg", "_nbHitPoints", "_hitPoint", "_i"];
_class = _this;

if (_class isEqualType objNull) then {  _class = typeOf _class; };

_hitPoints = [];
_cfgVehicle = configFile >> "CfgVehicles" >> _class;

while {isClass _cfgVehicle} do {
    _hitPointsCfg = _cfgVehicle >> "HitPoints";

    if (isClass _hitPointsCfg) then {
        _nbHitPoints = count _hitPointsCfg;

        for "_i" from 0 to (_nbHitPoints - 1) do
        {
            _hitPoint = _hitPointsCfg select _i;

            if ({configName _hitPoint == configName _x} count _hitPoints == 0) then
            {
                _hitPoints pushBack _hitPoint;
            };
        };
    };

    _cfgVehicle = inheritsFrom _cfgVehicle;
};

_hitPoints
//
//      Name: checkTyres
//      Desc: Auto reinflates tyres to prevent immobilization
//      Return: None 
//

private ['_vehicle', '_status'];
params ['_vehicle'];

_status = _vehicle getVariable ["status", []];

if (!canMove _vehicle && !("tyresPopped" in _status) ) then {
    
    _vehicle sethit ["wheel_1_1_steering", 0];
    _vehicle sethit ["wheel_1_2_steering", 0];
    _vehicle sethit ["wheel_2_1_steering", 0];
    _vehicle sethit ["wheel_2_2_steering", 0];
};

true
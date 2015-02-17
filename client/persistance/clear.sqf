//
//      Name: clearPad
//      Desc: Clears target location of vehicles/unwanted items
//      Return: Bool 
//

private['_target', '_nearby'];

_target = _this select 0;
_notify = [_this,1, true, [false]] call BIS_fnc_param; // Show notifications?
_targetPos = [0,0,0];

_owner = if (isDedicated) then { true } else {
    ( [_target, 8] call checkNearbyOwnership)
};

if (!_owner) exitWith {
    systemchat "Someone else is using this terminal.";
};

_error = false;

// Ensure we actually have a position to work with
if (typename _target == 'OBJECT') then {  _targetPos = (ASLtoATL getPosASL _target); } else {   _targetPos = _target; };

if (_notify) then { systemChat 'Clearing area...'; };

_nearby = _targetPos nearObjects 10;
if (count _nearby == 0) exitWith {};

// Check and clear if vehicles nearby
{      
    _y = _x;
    _type = typeOf _y;              

    // Make sure its not a whitelisted item
    switch (true) do {

        case (_type in GW_UNCLEARABLE_ITEMS): { };
        case (_type in GW_PROTECTED_ITEMS): {
            _relPos = [_targetPos, 10, (random 360)] call BIS_fnc_relPos;
            _y setPos _relPos;
            systemChat 'A supply box was moved as it was on the vehicle pad.';
        };
        default {
            deleteVehicle _y;
        };

    };

    false

} count _nearby >0;

if (_notify) then { systemChat 'Area cleared.'; };

true
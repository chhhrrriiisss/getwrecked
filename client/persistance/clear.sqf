//
//      Name: clearPad
//      Desc: Clears target location of vehicles/unwanted items
//      Return: Bool 
//

private['_target', '_nearby'];
params ['_target'];

_notify = [_this,1, true, [false]] call filterParam; 
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

_itemsDeleted = false;
_nearbyPlayers = [];

// Check and clear if vehicles nearby
{      
    _y = _x;
    _type = typeOf _y; 

    // Make sure its not a whitelisted item
    switch (true) do {
        case (isPlayer _y && (_y distance _targetPos <= 5)): { _nearbyPlayers pushBack _y; };
        case (_type in GW_UNCLEARABLE_ITEMS): { };
        case (_type in GW_PROTECTED_ITEMS): {
            _relPos = [_targetPos, 10, (random 360)] call relPos;
            _y setPos _relPos;
            player customChat [GW_WARNING_CHANNEL, 'A supply box was moved as it was on the pad.'];  
        };
        default {
           deleteVehicle _y;
           _itemsDeleted = true;
        };

    };

    false

} count _nearby >0;


if (_notify) then { systemChat 'Area cleared.'; };
if (count _nearbyPlayers == 0) exitWith { true };
if (!_itemsDeleted) exitWith { true };
    
{
    _newPos = [_targetPos, 10, (random 360)] call relPos;
    _newDir = [_newPos, _targetPos] call dirTo;
    _x setPos _newPos;
    [_x, _newDir] call setDirTo;
} count _nearbyPlayers;

true
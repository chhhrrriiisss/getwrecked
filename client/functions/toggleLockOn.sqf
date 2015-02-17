//
//      Name: toggleLockOn
//      Desc: Toggle auto-lock on and off, optionally set to the desired state
//      Return: None
//

private ['_vehicle', '_dir', '_pos', '_alt', '_vel'];

_vehicle = _this select 0;
_state = _this select 1;

_currentState = _vehicle getVariable ["lockOns", false];
_state = if (typename _state == "BOOL") then { _state } else { !_currentState };

GW_LOCKEDTARGETS = [];
_vehicle setVariable ["lockOns", _state];	



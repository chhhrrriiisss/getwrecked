//
//      Name: toggleLockOn
//      Desc: Toggle auto-lock on and off, optionally set to the desired state
//      Return: None
//

private ['_vehicle', '_dir', '_pos', '_alt', '_vel'];
params ['_vehicle', '_state'];

_currentState = _vehicle getVariable ["lockOns", false];
_state = if (_state isEqualType true) then { _state } else { !_currentState };

GW_LOCKEDTARGETS = [];
_vehicle setVariable ["lockOns", _state];	



//
//      Name: setBind
//      Desc: Creates a timeout that waits for a new key to be pressed and uses that as a bind
//      Return: None
//

private ['_index', '_timeout', '_list', '_prevData', '_prevText'];

_index = [_this,1, -1, [0]] call BIS_fnc_param;
_timeout = time + 8;

// Invalid row selected (like a category header for example)
if (_index == -1) exitWith {};

disableSerialization;
_list = ((findDisplay 92000) displayCtrl 92001);
_list lnbSetColor [_index, 1, [1,0,0,1]];

if (_index in reservedIndexes) exitWith { _list lnbSetCurSelRow (((lnbSize 92001) select 0) -1); };

_prevText = lnbText [92001, [_index, 2]];
_prevData = lnbData [92001, [_index, 2]];

lnbSetText [92001, [_index, 2], '  []'];
lnbSetData [92001, [_index, 2], ''];
// _list lnbSetCurSelRow _index;

// Retrieve the object reference (and any existing bind)
_obj = missionNamespace getVariable [format['%1', [_index,0]], nil];

GW_TARGETICON_ARRAY pushback _obj;

_pos = if (!isNil "_obj") then { getPosASL _obj } else { [0,0,0] };
_points = [_pos, (getPosASL (vehicle player))];

// Wait for a key press
waitUntil{ 		
	( (time > _timeout) || !isNil "GW_KEYDOWN" || !isNil { GW_SETTING_CANCEL } )
};

GW_TARGETICON_ARRAY = GW_TARGETICON_ARRAY - [_obj];

// If the key was pressed
if (!isNil "GW_KEYDOWN" && time < _timeout && isNil "GW_SETTING_CANCEL") then {

	_keyCode = GW_KEYDOWN;

	// Certain keys are kinda silly (wsad for example) as they conflict with existing actions
	if (_keyCode in GW_RESTRICTED_KEYS) then {
		systemChat 'That key is not allowed.';
	} else {
		[_index, _keyCode] call formatBind;
		[] call saveBinds;
	};

} else {
	systemChat 'Timed out waiting for key bind';
	lnbSetText [92001, [_index, 2], _prevText];
	lnbSetData [92001, [_index, 2], _prevData];
	GW_SETTING_CANCEL = nil;
};	


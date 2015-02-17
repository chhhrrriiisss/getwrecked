//
//      Name: setBind
//      Desc: Creates a timeout that waits for a new key to be pressed and uses that as a bind
//      Return: None
//

private ['_index', '_timeout', '_list', '_prevData', '_prevText'];

_index = if (isNil { _this select 1} ) then { -1 } else { (_this select 1) };
_mouseOnly = if (isNil { _this select 2} ) then { false } else { (_this select 2) };

_timeout = time + 8;

if (isNil "GW_LASTBIND_TRIGGER") then {
	GW_LASTBIND_TRIGGER = time;
};

if (time < (GW_LASTBIND_TRIGGER + 0.03)) exitWith {};
GW_LASTBIND_TRIGGER = time;

// Invalid row selected (like a category header for example)
if (_index == -1) exitWith {};

disableSerialization;
_list = ((findDisplay 92000) displayCtrl 92001);
_list lnbSetColor [_index, 1, [1,0,0,1]];

if (_index in reservedIndexes) exitWith { _list lnbSetCurSelRow (((lnbSize 92001) select 0) -1); };

// Check if we're selecting the mouse icon rather than the keybind area
if (!isNil "GW_MOUSEX" && !isNil "GW_MOUSEY" && { GW_MOUSEX > 0.4 } ) then {

	if (_mouseOnly) then {

		_tag = lnbData [92001, [_index, 1]];
		if (!(_tag in GW_WEAPONSARRAY)) exitWith {};

		_mouseBindState = lnbData [92001, [_index, 3]];
		_mouseBindState = if (typename _mouseBindState == "STRING") then { _mouseBindState } else { (str _mouseBindState) };
		_mouseBindState = if (_mouseBindState == "1") then { systemchat 'Mouse fire disabled.'; [mouseInactiveIcon, "0"] } else { systemchat 'Mouse fire enabled.'; [mouseActiveIcon, "1"] };
		lnbSetData [92001, [_index, 3], (_mouseBindState select 1)];
		lnbSetPicture[92001, [_index, 3], (_mouseBindState select 0)];
		[_index] call saveBinds;

	};

} else {

	_prevText = lnbText [92001, [_index, 2]];
	_prevData = lnbData [92001, [_index, 2]];

	lnbSetText [92001, [_index, 2], '  []'];
	lnbSetData [92001, [_index, 2], ''];

	// Retrieve the object reference (and any existing bind)
	_obj = missionNamespace getVariable [format['%1', [_index,0]], nil];

	GW_TARGETICON_ARRAY pushback _obj;

	_pos = if (!isNil "_obj") then { getPosASL _obj } else { [0,0,0] };
	_points = [_pos, (getPosASL (vehicle player))];

	GW_KEYBIND_ACTIVE = true;

	// Wait for a key press
	waitUntil{ 		
		( (time > _timeout) || !isNil "GW_KEYDOWN" || !isNil { GW_SETTING_CANCEL } )
	};

	GW_KEYBIND_ACTIVE = false;

	GW_TARGETICON_ARRAY = GW_TARGETICON_ARRAY - [_obj];

	// If the key was pressed
	if (!isNil "GW_KEYDOWN" && time < _timeout && isNil "GW_SETTING_CANCEL") then {

		_keyCode = GW_KEYDOWN;

		// Certain keys are kinda silly (wsad for example) as they conflict with existing actions
		if (_keyCode in GW_RESTRICTED_KEYS) then {
			systemChat 'That key is not allowed.';
		} else {
			[_index, _keyCode] call formatBind;
			[_index] call saveBinds;
		};

	} else {
		systemChat 'Timed out waiting for key bind';
		lnbSetText [92001, [_index, 2], _prevText];
		lnbSetData [92001, [_index, 2], _prevData];
		GW_SETTING_CANCEL = nil;
	};	

	GW_KEYBIND_ACTIVE = false;

};
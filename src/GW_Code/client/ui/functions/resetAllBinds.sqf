//
//      Name: resetAllBinds
//      Desc: Does what it says on the tin
//      Return: None
//

private ['_result', '_list', '_listLength'];

_result = ['RESET ALL BINDS?', '', 'CONFIRM'] call createMessage;

if (!_result) exitWith {};

disableSerialization;
_list = ((findDisplay 92000) displayCtrl 92001);
_listLength = ((lnbSize 92001) select 0);

for "_i" from 0 to _listLength step 1 do {

	if (_i in reservedIndexes) then {} else {
		
		// Retrieve the object reference
		_obj = missionNamespace getVariable [format['%1', [_i,0]], nil];

		// -1 Effectively means no bind
		if (!isNil "_obj") then { _obj setVariable ["bind", -1];	};

		[_i, -1] call formatBind;

	};

};

// Save all binds
[] call saveBinds;
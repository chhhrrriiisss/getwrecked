/*
	Original Author: Karel Moricky
	Modified by: Chris Nicholls (removed GUI message output + number only return)

	Description:
	Measures how much time it takes to execute given expression

	Parameter(s):
		0: STRING - tested expression
		1 (Optional): ANY - Param(s) passed into code (default: [])
		2 (Optional): NUMBER - Number of cycles (default: 10000)
		2 (Optional): DISPLAY - Display in which the message window with results will be opened. Use displayNull to disable the window.

	Returns:
	NUMBER - avarage time spend in code execution [ms]
*/
private ["_code","_params","_cycles","_fnc_codePerformance_cycles","_display","_codeText","_timeResult"];

_code = [_this,0,"",[""]] call bis_fnc_param;
_params = [_this,1,[]] call bis_fnc_param;
_cycles = [_this,2,10000,[0]] call bis_fnc_param;
_display = [_this,3,[] call bis_fnc_displayMission,[displaynull]] call bis_fnc_param;
_fnc_codePerformance_cycles = _cycles;

//--- Compile code (calling the code would increase the time)
_timeResult = 0;
_codeText = compile format [
	"
		private ['_time','_fnc_codePerformance_timeLimit'];
		_time = diag_ticktime;
		_fnc_codePerformance_timeLimit = _time + 1;
		if (true) then {
			private ['_code','_params','_cycles','_display','_codeText','_timeResult'];
			for '_i' from 1 to %2 do {
				%1;
				if (diag_ticktime > _fnc_codePerformance_timeLimit) exitwith {_fnc_codePerformance_cycles = _i;};
			};
		};
		_timeResult = ((diag_ticktime - _time) / _fnc_codePerformance_cycles) * 1000;
	",
	_code,
	_cycles
];

//--- Execute testing
"----------------------------------" call bis_fnc_logFormat;
["Test Start. Code: %1",_code] call bis_fnc_logFormat;
_params call _codeText;
["Test Cycles: %1 / %2",_fnc_codePerformance_cycles,_cycles] call bis_fnc_logFormat;
["Test End. Result: %1 ms",_timeResult] call bis_fnc_logFormat;
"----------------------------------" call bis_fnc_logFormat;

// [
// 	parsetext format [
// 		"<t color='#99ffffff'>Result:</t>" +
// 		"<br />" +
// 		"<t font='EtelkaMonospacePro' size='2'>%1 ms</t>" +
// 		"<br />" +
// 		"<br />" +
// 		"<t color='#99ffffff'>Cycles:</t>" +
// 		"<br />" +
// 		"%2 / %3" +
// 		"<br />" +
// 		"<br />" +
// 		"<t color='#99ffffff'>Code:</t><br /><t font='EtelkaMonospacePro' size='0.8'>%4</t>" +
// 		"",
// 		_timeResult,
// 		_fnc_codePerformance_cycles,
// 		_cycles,
// 		_code
// 	],
// 	"PERFORMANCE TEST RESULT",
// 	nil,
// 	nil,
// 	_display
// ] spawn bis_fnc_guiMessage;
// copytoclipboard format ["%1 ms",_timeResult];

systemchat format['%1 | %2', _code, _timeResult];

_timeResult
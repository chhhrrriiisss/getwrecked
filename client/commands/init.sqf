//
//		GW Chat Command Interceptor
//		Based off of a script developed by Conroy
//		Retrieved from http://www.armaholic.com/page.php?id=26377
//		Modified by Sli for Get Wrecked
//


// Get the list of available commands
[] call compile preProcessFilelineNumbers "client\commands\commands.sqf";

GW_COMMANDS_MARKER = "!"; //Character at the front of the chat input to intercept it

GW_executeCommand = {

	private ["_chatArr","_seperator","_commandDone","_command","_argument"];

		_chatArr = [_this,0,[]] call BIS_fnc_param;

		// Remove leading intercept character
		_chatArr set [0,-1];
		_chatArr = _chatArr - [-1];

		_seperator = (toArray " ") select 0;
		_commandDone = false;
		_command = [];
		_argument = [];

		{
			if (_x == _seperator && !_commandDone)then{
				_commandDone = true;
			}else{
				if (!_commandDone) then{
					_command set[count _command,_x];
				}else{
					_argument set[count _argument,_x];
				};
			};
			false
		} count _chatArr > 0;

		_command = toString _command;
		_argument = toString _argument;

		{
			if (_command == (_x select 0))exitWith{
				[_argument] call (_x select 1);
			};
		}  Foreach GW_COMMANDS_LIST;

};

// Reset and old EH IDs and scripthandles
if (!isNil "GW_COMMANDS_SETUP")then{
	terminate GW_COMMANDS_SETUP;
};
if (!isNil "GW_COMMANDS_EH")then{
	(findDisplay 24) displayRemoveEventHandler ["KeyDown", GW_COMMANDS_EH];
	GW_COMMANDS_EH = nil;
};

GW_COMMANDS_SETUP = [] spawn {
	private["_equal","_chatArr"];
	
	for "_i" from 0 to 1 step 0 do {

		GW_COMMANDS_STRING = "";
		
		waitUntil{sleep 0.22;!isNull (finddisplay 24 displayctrl 101)};
		
		GW_COMMANDS_EH = (findDisplay 24) displayAddEventHandler["KeyDown",{
			if ((_this select 1) != 28) exitWith{false};
			
			_equal = false;
			
			_chatArr = toArray GW_COMMANDS_STRING;
			//_chatArr resize 1;
			if ((_chatArr select 0) isEqualTo ((toArray GW_COMMANDS_MARKER) select 0))then{
				if (GW_DEBUG)then{
					systemChat format["Intercepted: %1",GW_COMMANDS_STRING];
				};
				_equal = true;
				closeDialog 0;
				(findDisplay 24) closeDisplay 1;
				
				[_chatArr] call GW_executeCommand;
			};
			
			_equal
		}];
		
		waitUntil{
			if (isNull (finddisplay 24 displayctrl 101))exitWith{
				if (!isNil "GW_COMMANDS_EH")then{
					(findDisplay 24) displayRemoveEventHandler ["KeyDown",GW_COMMANDS_EH];
				};
				GW_COMMANDS_EH = nil;
				true
			};
			GW_COMMANDS_STRING = (ctrlText (finddisplay 24 displayctrl 101));
			false
		};

	};
};
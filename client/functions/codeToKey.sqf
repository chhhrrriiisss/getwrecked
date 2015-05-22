//
//      Name: codeToKey
//      Desc: Converts numerical key code to string 
//      Return: String
//

private ['_code'];

_code = [_this,0, 0, [0]] call filterParam;

if (_code <= 0) exitWith { '' };

_string = '';

{
	if (_code isEqualTo (_x select 1)) exitWith {
		_string = _x select 0;
	};

	false
	
} count keyCodes > 0;

_string
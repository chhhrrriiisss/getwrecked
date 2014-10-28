//
//      Name: cropString
//      Desc: Cuts extra characters from a string (optional delimiter)
//      Return: String
//

private ['_string', "_limit", "_delimiter"];

_string = [_this,0, "", [""]] call BIS_fnc_param;
_limit = [_this,1, 20, [0]] call BIS_fnc_param;
_delimiter = [_this,2, "", [""]] call BIS_fnc_param;

if (_string == "") exitWith {};

_len = count (toArray _delimiter);

_string = if (count (toArray _string) >= _limit) then {

	_string = toArray _string;
	_string resize (_limit - _len);
	(format['%1%2', toString (_string), _delimiter])

} else {
	_string
};	

_string
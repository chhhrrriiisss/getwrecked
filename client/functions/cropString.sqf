//
//      Name: cropString
//      Desc: Cuts extra characters from a string (optional delimiter)
//      Return: String
//

private ['_string', "_limit", "_delimiter"];

_string = _this select 0;
_limit = _this select 1;
_delimiter = _this select 2;

if (_string == "") exitWith {};

_len = count (toArray _delimiter);

if (count (toArray _string) >= _limit) exitWith {

	_string = toArray _string;
	_string resize (_limit - _len);
	(format['%1%2', toString (_string), _delimiter])
};

_string
//
//      Name: pubVar_globalTitle
//      Desc: Title triggered by pubVar
//      Return: None
//

_msg = _this select 0,
_timeout = _this select 1;  

waitUntil { Sleep 0.1; (isNull (findDisplay 95000)) };
[format["<br /><t size='3' color='#ffffff' align='center'>%1</t>", _msg], "", [false, false] , { true }, _timeout, true] call createTitle;


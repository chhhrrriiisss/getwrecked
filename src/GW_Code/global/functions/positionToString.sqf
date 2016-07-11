//
//      Name: positionToString
//      Desc: Converts a position to string format
//      Return: String (Position)
//
//		Author: Killzone KId

private ["_f2s","_num","_rem"];
_f2s = {
    _num = str _this + ".";
    _rem = str (_this % 1);
    (_num select [0, _num find "."]) + (_rem select [_rem find "."])
};
format [
    "[%1,%2,%3]",
    _this select 0 call _f2s,
    _this select 1 call _f2s,
    _this select 2 call _f2s
]
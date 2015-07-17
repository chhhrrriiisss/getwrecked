//
//      Name: filterParam
//      Desc: Indentical usage to bis_fnc_param, but faster
//      Return: Variable (filtered)
//

private ['_arr'];

_arr = +_this;
_this = _arr deleteAt 0;
(param _arr)

//
//      Name: filterParam
//      Desc: Indentical usage to bis_fnc_param, but faster
//      Return: Variable (filtered)
//

private ['_arr'];

// Temp until param error fix
// if (isNil { _this select 0 } || isNil { _this select 1 }) exitWith {
// 	(_this select 2)
// };

// if ((_this select 1) > (count (_this select 0)) - 1) exitWith {
// 	(_this select 2)
// };

// _selection = (_this select 0) select (_this select 1);

// _typeError = true;
// {
// 	if (_x isEqualType _selection) exitWith {
// 		_matchesType = false;
// 	};
// } foreach (_this select 3);	

// if (_typeError) exitWith { 
// 	(_this select 2)
// };

_arr = +_this;
_this = _arr deleteAt 0;

//(_this call bis_fnc_param) 
(param _arr)

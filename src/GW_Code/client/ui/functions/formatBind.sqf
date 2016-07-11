//
//      Name: formatBind
//      Desc: Updates the row with the correct key bind (and data)
//      Return: None
//

private ['_i', '_k', '_dK'];
params ['_i', '_k'];

_k = if (_k isEqualType "") then { (parseNumber(_k)) } else { _k };
_dK = if (_k < 0) then { "" } else { [_k] call codeToKey };
_dK = if ( (count toArray _dK) == 0) then { "" } else { format['[ %1 ]', _dK] };

lnbSetText [92001, [_i, 2], _dK];
lnbSetData [92001, [_i, 2], format['%1', _k]];
lnbSetColor [92001, [_i, 2], [1,1,1,1]];
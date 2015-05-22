//
//      Name: filterParam
//      Desc: Indentical usage to bis_fnc_param, but faster
//      Return: Variable (filtered)
//

private["_params", "_id", "_value", "_thisCount"];

_thisCount = count _this;
_params = if (_thisCount > 0) then { _this select 0 } else { [] };
_id = if (_thisCount > 1) then { _this select 1 } else { 0 };
if (typename _params != "ARRAY") then { _params = [_params] };
_value = if (count _params > _id) then {  _params select _id } else { nil };

if (_thisCount > 2) then {

    private["_default", "_types", "_typeDefault", "_type"];

    _default = _this select 2;

    if (isnil "_value") then { _value = _default; };

    if (_thisCount > 3) then {
        _types = _this select 3;
        _type = typename _value;
        _typeDefault = typename _default;
        if !({ _type == typename _x } count _types > 0) then {
            if ({  _typeDefault == typename _x } count _types > 0) then {   
                _value = _default;
            };
        };
    };

    if (_thisCount > 4) then {
        if (typename _value == "ARRAY") then {
            private["_valueCountRequired", "_valueCount"];
            _valueCountRequired = [_this, 4, 0, [0, []]] call filterParam;
            if (typename _valueCountRequired != "ARRAY") then { _valueCountRequired = [_valueCountRequired] };
            _valueCount = count _value;
            if !(_valueCount in _valueCountRequired) then { _value = _default; };
        };
    };

    _value

} else {

    if (isnil "_value") then {
        nil
    } else {
        _value
    }
};


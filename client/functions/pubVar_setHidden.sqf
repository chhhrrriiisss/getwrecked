_o = _this select 0;
_state = _this select 1;
_o hideObject _state;
{ _x hideObject _state; false } count (attachedObjects _o);

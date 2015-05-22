//
//      Name: setVisibleAttached
//      Desc: Hides/shows an object and all attached items globally
//      Return: None
//

_o = [_this,0, objNull, [objNull]] call filterParam;
_state = [_this,1, false, [false]] call filterParam;
if (isNull _o || !isServer) exitWith {};

_o hideObjectGlobal _state;
{ _x hideObjectGlobal _state; false	} count (attachedObjects _o);


//
//      Name: setVisibleAttached
//      Desc: Hides/shows an object and all attached items globally
//      Return: None
//

_o = [_this,0, objNull, [objNull]] call BIS_fnc_param;
_state = [_this,1, false, [false]] call BIS_fnc_param;
if (isNull _o || !isServer) exitWith {};

{ 		
	_x hideObjectGlobal _state;		
	false
} count (attachedObjects _o) > 0;

_o hideObjectGlobal _state;
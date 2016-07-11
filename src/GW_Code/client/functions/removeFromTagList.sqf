//
//      Name: removeFromTagList
//      Desc: Removes target from the registry of last seen vehicles used by the hud
//      Return: None
//

params ['_v'];
private ['_c'];

if (isNull _v) exitWith {};

_c = 0;
{ 
	if (_x select 0 == _v) then { GW_TAGLIST set[_c, 'x']; };
	_c = _c + 1;
	false
} count GW_TAGLIST > 0;	

GW_TAGLIST = GW_TAGLIST - ['x'];
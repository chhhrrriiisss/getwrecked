//
//      Name: hasType
//      Desc: Finds modules of tag type attached to the vehicle, returns the number
//      Return: Number (-1 for not found)
//

private ['_arr', '_t', '_v', '_r', '_tag'];

_t = _this select 0;
_v = _this select 1;

if (_t == "" || isNull _v) exitWith { -1 };
_r = 0;

// Loop through and count
{
	_tag = _x getVariable ['GW_Tag', ''];
	if (_tag isEqualTo _t) then {
		_r = _r + 1;
	};
	false
} count (attachedObjects _v) > 0;

// Set to -1 if not found
_r = if (_r == 0) then { -1 } else { _r };

_r
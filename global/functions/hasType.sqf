//
//      Name: hasType
//      Desc: Finds modules of tag type attached to the vehicle, returns the number
//      Return: Number (-1 for not found)
//

private ['_arr', '_t', '_v', '_r'];

_t = [_this,0, "", [""]] call BIS_fnc_param;
_v = [_this,1, objNull, [objNull]] call BIS_fnc_param;

if (_t == "" || isNull _v) exitWith { -1 };
_r = 0;

// Get the correct module list
_arr = switch (true) do {
	case (_t in GW_WEAPONSARRAY): { (_v getVariable ["weapons", []]) };
	case (_t in GW_TACTICALARRAY):	{  (_v getVariable ["tactical", []])  };
	default { [] };
};

// Loop through and count
{
	if ((_x select 0) == _t) then {
		_r = _r + 1;
	};
	false
} count _arr > 0;

// Set to -1 if not found
_r = if (_r == 0) then { -1 } else { _r };

_r
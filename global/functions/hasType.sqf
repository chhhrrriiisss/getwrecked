//
//      Name: hasType
//      Desc: Finds modules of tag type attached to the vehicle, returns the number
//      Return: Number (-1 for not found)
//

private ['_arr', '_t', '_v', '_r'];

_t = _this select 0;
_v = _this select 1;

if (_t == "" || isNull _v) exitWith { -1 };
_r = 0;

// Get the correct module list
_arr = [_t, _v] call {
	if ((_this select 0) in GW_WEAPONSARRAY) exitWith { (_v getVariable ["weapons", []]) };
	if ((_this select 0) in GW_TACTICALARRAY) exitWith {  (_v getVariable ["tactical", []])  };
	[]
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
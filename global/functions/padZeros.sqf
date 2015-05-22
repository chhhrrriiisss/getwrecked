_n = if (typename (_this select 0) == "SCALAR") then { format['%1', (_this select 0)] } else { (_this select 0) };
_w = _this select 1;

if (count toArray _n >= _w) exitWith { _n };

for "_i" from 0 to 1 step 0 do {
	if (count (toArray _n) >= _w) exitWith {};
	_n = format['%1%2','0',_n];
};

_n		

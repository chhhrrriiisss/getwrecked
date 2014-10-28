_n = if (typename (_this select 0) == "SCALAR") then { format['%1', (_this select 0)] } else { (_this select 0) };
_w = _this select 1;

_r = if (count toArray _n >= _w) then { _n } else { 

	while {count (toArray _n) < _w} do {
		_n = format['%1%2','0',_n];
	};

	_n		
};

_r
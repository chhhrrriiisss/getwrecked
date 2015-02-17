arrayToJson = {
	
	private ['_a'];

	_a = _this;	
		
	parseArrayToJson = {
		
		private ['_arr', '_jsonStr'];

		_arr = _this;

		_validTypes = [
			"SCALAR",
			"BOOL",
			"OBJECT"
		];

		_jsonStr = '{ ';
		_arrayCount = 0;
		_arrayPrevious = false;

		{

			_type = typename _x;
			
			if (_type == "SCALAR" || _type == "STRING" || _type == "BOOL") then {
				_endComma = if (_forEachIndex == ((count _arr) -1)) then { '' } else { ',' };
				_jsonStr = format['%1 "%2": "%3"%4', _jsonStr, _forEachIndex, _x, _endComma];
			};

			if (typename _x == "ARRAY") then {
				_jsonStr = format['%1 "%2": %3%4', _jsonStr, _forEachIndex, (_x call parseArrayToJson)];
				_jsonStr = if (_forEachIndex < ((count _arr) -1)) then { format['%1,', _jsonStr] } else { _jsonStr };
			};

			if (_forEachIndex == ((count _arr) -1)) then {	
				_jsonStr = format['%1 }', _jsonStr];
			};

		} foreach _arr;

		_jsonStr

	};


	(_a call parseArrayToJson)
};


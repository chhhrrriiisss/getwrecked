//
//      Name: createTween
//      Desc: Useful for tweening multiple control properties at the same time
//			  Note: this function is a bit of a test and very much WIP and needs some serious updating, really
//

private ["_controls", "_to", "_duration", "_ease", "_controlsList"];

disableSerialization; 

params ['_controls', '_properties', '_ease'];

_controlsList = [];

power = {
	
	params ['_num', '_repeats'];

	for [{_i=1},{_i<=_repeats},{_i=_i+1}] do {
		_num = _num * _num;
	};

	_num
};

// Different easing types
getEasedValue = {
	
	params ['_type', '_i', '_d', '_s', '_e'];
	_value = _s;

	switch (_type) do {

		case "quad":
		{
			_t = _i / _d; 
			_c = _e - _s; 
			_value = ( -_c * _t*(_t-2) + _s );
		};

		// Fancy stuff
		case "expo":
		{
			_t = _i / (_d/2);
			_c = _e - _s; 

			if (_t < 1) then {
				_pow = [2, ( 10 * (_i- 1) ) ] call power;	
				_value = (_c/2) * _pow + _s;
			} else {	
				_pow = [2, (-10 * _i) ] call power;		
				_t = _t - 1;
				_value = (_c/2) * ( (-1 * _pow) + 2 ) + _s;
			};			
		};

		// No easing, sadface
		default
		{		
			_value = _value;
		};

	};

	_value

};

tweenProperty = {

	disableSerialization;
	params ['_control', '_property', '_startValue', '_endValue', '_duration'];

	_defaultX = (ctrlPosition _control) select 0;
	_defaultY = (ctrlPosition _control) select 1;
	_defaultW = (ctrlPosition _control) select 2;
	_defaultH = (ctrlPosition _control) select 3;
	_defaultFade = ctrlFade _control;

	// Determine if we should add to existing position or use the specific value
	isRelative = {
		_valueToChange = _this select 0;

		if (typeName _startValue == "STRING") then { 	
			_startValue = _valueToChange + parseNumber ( _startValue );
		};

		if (typeName _endValue == "STRING") then { 			
			_endValue = _valueToChange + parseNumber ( _endValue );
		};
	};

	if (_property == "fade") then {
		[_defaultFade] call isRelative;
		_control ctrlSetFade _startValue;
	};

	if (_property == "x") then {
		[_defaultX] call isRelative;
		_control ctrlSetPosition [_startValue, _defaultY, _defaultW, _defaultH];		
	};

	if (_property == "y") then {
		[_defaultY] call isRelative;
		_control ctrlSetPosition [_defaultX, _startValue, _defaultW, _defaultH];		
	};

	_control ctrlCommit 0;
	_control ctrlShow true;

	if (_duration == 0) then {} else {

		for "_i" from 0 to 50 step 1 do {

			_newValue = [ease, _i, 50, _startValue, _endValue] call getEasedValue;

			if (_property == "fade") then {	
				_control ctrlSetFade _newValue; 
			};	

			if (_property == "x") then {
				_control ctrlSetPosition [_newValue, _defaultY, _defaultW, _defaultH];
			};	

			if (_property == "y") then {
				_control ctrlSetPosition [_defaultX, _newValue, _defaultW, _defaultH];	
			};	

			_control ctrlCommit 0;		

	    	Sleep (_duration / 50);
		};
	};

	// Restore defaults
	if (_property == "fade") then { _control ctrlSetFade _endValue;	};
	if (_property == "x") then { _control ctrlSetPosition [_endValue, _defaultY, _defaultW, _defaultH];	};
	if (_property == "y") then { _control ctrlSetPosition [_defaultX, _endValue, _defaultW, _defaultH];	};

	_control ctrlCommit 0;

	true
};

tweenControl = {

	disableSerialization;

	params ['_control','_properties', '_ease'];

	{
		_p = _x select 0;
		_s = _x select 1;
		_e = _x select 2;
		_d = _x select 3;
		[_control, _p, _s, _e, _d] spawn tweenProperty;	

	} ForEach _properties;

};

// Trigger animation on controls, trigger a new tween on arrays of controls
filterArray = {
	disableSerialization;

	params ['_array', '_properties'];

	{
		disableSerialization;

		if (typeName _x == "ARRAY") then {
			[_x, _properties] spawn filterArray;		
		};

		if (typeName _x == "CONTROL") then {
			[_x, _properties, 'quad'] call tweenControl;
		};

	} ForEach _array;
};

if (typeName _controls == "CONTROL") then {
	_null = [_controls, _properties, 'quad'] call tweenControl;
} else {
	_null = [_controls, _properties] call filterArray;
};


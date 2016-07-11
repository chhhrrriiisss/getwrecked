encodeString = {

  _input = if (typename _this != "STRING") then { str _this } else { _this };
  _inputArray = toArray _input;
  _encoded = "";

  for "_i" from (count _inputArray) -1 to 0 step -1 do {

    _chr = _inputArray select _i;
    _result = if (_chr >= 65 && _chr <= 90) then {
		_chr
	} else {
		(_chr - 65) + (26 * floor( random 2 ) ) 
	};

	systemchat format['result: %1', _result];

    _encoded = format['%1%2', _encoded, toString [_result]];
    
   };

   _encoded

  
};

  // toHash = {
	
// 	_input = _this select 0;
// 	_alphabet = toArray (_this select 1);
// 	_alphabetLength = count _alphabet;
// 	_output = '';
// 	{
// 		_selection = floor (_input % _alphabetLength);
// 		_output = format['%1%2', _output, toString [(_alphabet select _selection)]];
// 		_input = (_input / _alphabetLength);
// 	} count (toArray str _input);

// 	_output
// };

// reverseModulus = {
// 	_div = _this select 0;
// 	_a = _this select 1;
// 	_remainder = _this select 2;

// 	if (_remainder >= _div) exitWith { 0 };
// 	if (_a < _remainder) exitWith { 
// 		(_remainder - _a)
// 	};
//  	((_div + _remainder) - _a)
// };

// toTime = {	

// 	_input = _this select 0;
// 	_inputLength = count (toArray _input) - 1;
// 	_alphabet = toArray (_this select 1);
// 	_alphabetLength = count _alphabet;
// 	_output = '';

// 	for "_i" from 0 to _inputLength step 1 do {

// 		_selection = (toArray _input) select _i;
// 		_index = _alphabet find _selection;

// 		systemchat format['%1', _index];


// 		// _reverse = [_alphabetLength, _inputLength - _i, _index] call reverseModulus;

// 		// _output = format['%1%2', _output, _reverse];

// 		// _ref = (_alphabetLength * (_inputLength - _i));
// 		// systemchat format['%1 / %2 / %3', _selection,_index, _ref];
// 		// _output pushback (_index * _ref);


// 	};

// 	_output



// };
// toTime = {	

// 	_input = _this select 0;
// 	_inputLength = count (toArray _input) - 1;
// 	_alphabet = toArray (_this select 1);
// 	_alphabetLength = count _alphabet;
// 	_output = [];

// 	for "_i" from 0 to _inputLength step 1 do {

// 		_selection = (toArray _input) select _i;
// 		_index = _alphabet find _selection;


// 		_ref = (_alphabetLength * (_inputLength - _i));


// 		systemchat format['%1 / %2 / %3', _selection,_index, _ref];
// 		_output pushback (_index * _ref);


// 	};

// 	_output



// };

_key = _this select 1;
_hash = [_this select 0, _key] call toHash;
_time = [_hash, _key] call toTime;

_encoded = (_this select 0) call encodeString;

systemchat format['hash: %1 / time: %2 / encoded: %3', _hash, _time, _encoded];
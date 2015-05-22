private ['_name', '_des', '_att'];

if (isNil "GW_GENERATOR_ACTIVE") then { GW_GENERATOR_ACTIVE = false; };
if (GW_GENERATOR_ACTIVE) exitWith { true };
GW_GENERATOR_ACTIVE = true;

_sub = GW_subjects select (floor (random (count GW_subjects)));
_des = GW_descriptors select (floor (random (_sub select 1)));
_att = GW_attributes select (floor (random (count GW_attributes)));

_add = if ((random 100) > 75) then { 
	(format['%1%2', GW_additions select (floor (random (count GW_additions))),  GW_attributes select (floor (random (count GW_attributes)))])
} else { '' };

_name = (format["%1%2%3%4", (_sub select 0), _des, _att, _add]);

_name spawn {      

	disableSerialization;
	_input = ((findDisplay 93000) displayCtrl 93001);
	_input ctrlSetFade 0.001;
	_input ctrlCommit 0;

	_output = '';
	_nameArray = toArray _this;
	for "_i" from 0 to (count (toArray _this)-1) step 1 do {              
	    
	    _output = format['%1%2', _output, toString [_nameArray select _i]];
	    _input ctrlSetText toUpper(_output);
	    _input ctrlCommit 0;
	    Sleep (0.05 - (_i * 0.005));
	};

	GW_GENERATOR_ACTIVE = false;

};


true
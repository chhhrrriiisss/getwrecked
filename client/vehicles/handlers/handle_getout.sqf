//
//      Name: handleGetOut
//      Desc: Main handler for getting out of vehicles
//      Return: None
//

params ['_vehicle', '_nil', '_unit'];

if (alive _vehicle) then { _unit setDammage 0; };
GW_INVULNERABLE = false;

// If we've been kicked out due to lower health blow it up
if (getDammage _vehicle >= 0.9) then {
	_vehicle setDammage 1;
};

"dynamicBlur" ppEffectEnable false; 
"colorCorrections" ppEffectEnable false; 

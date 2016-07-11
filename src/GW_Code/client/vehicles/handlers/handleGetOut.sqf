//
//      Name: handleGetOut
//      Desc: Main handler for getting out of vehicles
//      Return: None
//

private ['_vehicle', '_nil', '_unit'];
params ['_vehicle', '_nil', '_unit'];

if (isNull _vehicle) exitWith {};
if (!local _vehicle) exitWith { systemchat 'not local!'; };
if (alive _vehicle) then { _unit setDammage 0; };

if (_unit == player) then {

	GW_INVULNERABLE = false;
	GW_ISDRIVER = false;
	GW_INVEHICLE = false;

	"dynamicBlur" ppEffectEnable false; 
	"colorCorrections" ppEffectEnable false; 

};

if (getDammage _vehicle >= 0.9) then {
	_vehicle setDammage 1;
};



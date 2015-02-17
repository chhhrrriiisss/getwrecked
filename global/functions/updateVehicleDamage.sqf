//
//      Name: updateVehicleDamage
//      Desc: Update health variable on vehicle used for health bar on tags
//      Return: None
//

// If last update
if (isNil "GW_LASTDAMAGE_UPDATE") then {
    GW_LASTDAMAGE_UPDATE = time;
};

if (time - GW_LASTDAMAGE_UPDATE < GW_DAMAGE_UPDATE_INTERVAL) exitWith { true };
	
GW_LASTDAMAGE_UPDATE = time;

_oD = 3;
{
    _d = (_this) getHit _x;
    _d = if (isNil "_d") then { 0 } else { _d };
    _oD = _oD - _d;
} count ['palivo', 'motor', 'karoserie'] > 0;

_this setVariable ['health', round ( (_oD / 3) * 100), true];

true
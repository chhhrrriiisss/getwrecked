/*

	Get Out Handler

*/

private ['_unit'];

_unit = _this select 2;
_vehicle = _this select 0;

if (alive _vehicle) then { _unit setDammage 0; };
GW_INVULNERABLE = false;

"dynamicBlur" ppEffectEnable false; 
"colorCorrections" ppEffectEnable false; 

//
//      Name: handleGetIn
//      Desc: Handler for jumping in vehicles
//      Return: None
//

private ['_vehicle', '_position', '_unit'];

_vehicle = _this select 0;   
_position = _this select 1;
_unit = _this select 2;		

// If we're a passenger and driver is vacant, move to slow
if ( _position != "driver" ) then {
	_unit action ["eject", _vehicle];
	_unit action ["getInDriver", _vehicle];
};

// Still compiling? get out quick man!
if (GW_WAITCOMPILE) exitWith {
	_unit action ["eject", _vehicle];
};	

[_vehicle] call compileAttached;
//[_vehicle] execVM 'client\vehicles\compile_attached.sqf';

// Ownership check
_isOwner = [_vehicle, _unit, true] call checkOwner;

// We're the owner, nothing to do here
if (_isOwner) exitWith {};

// We're not, lets grab some stuff!
_vehicle setVariable ["owner", (name _unit), true];

_attached = attachedObjects _vehicle;

if (count _attached <= 0) exitWith {};

{
    _x setVariable ["owner", (name _unit), true];

} ForEach _attached;	

if (local _vehicle) then {
	systemChat "You are now the owner of this vehicle.";
};
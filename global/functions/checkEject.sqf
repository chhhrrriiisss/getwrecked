//
//      Name: checkEject
//      Desc: Determines if the vehicles eject system should be triggered, then activates it
//      Return: Bool (Unused)
//

_vehicle = [_this,0, objNull, [objNull]] call filterParam;
_unit = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _vehicle || isNull _unit) exitWith { false };

// Are there people to eject?
_crew = (crew _vehicle);
if ( count _crew == 0) exitWith { false };

// Does this vehicle have an eject system?
_hasChute = ["PAR", _vehicle] call hasType;
if (_hasChute <= 0) exitWith { false };

// If the current damage is significant enough and check chance of failure
_eject = if ( (getDammage _vehicle) >= 0.91 && (random 100) > GW_EJECT_FAILURE) then { true } else { false };

if (_eject) exitWith {
    [_vehicle, _unit] call ejectSystem; 
    systemChat "Emergency eject activated.";
    true
}; 

false
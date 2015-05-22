//
//      Name: checkOwner
//      Desc: Determines if the object is owner by the player (and takes ownership if requested)
//      Return: Bool 
//

private ['_obj', '_unit', '_makeOwner', '_owner'];

_obj = [_this,0, objNull, [objNull]] call filterParam;
_unit = [_this,1, objNull, [objNull]] call filterParam;

if (isNull _obj || isNull _unit) exitWith { false };

// Optionally take ownership if it's unowned
_makeOwner = [_this,2, true, [false]] call filterParam;

_owner = if (isNull attachedTo _obj) then { (_obj getVariable ['GW_Owner', '']) } else { 
	if (isPlayer (attachedTo _obj)) exitWith { (name  (attachedTo _obj)) }; 
	((attachedTo _obj) getVariable ['GW_Owner', '']) 
};

// No owner, take ownership
if (count toArray _owner == 0 && _makeOwner) exitWith { 
	_obj setVariable ['GW_Owner', (name _unit), true];	
	true
};

// No owner, dont take ownership	
if (count toArray _owner == 0 && !_makeOwner) exitWith { true }; 

// Has owner, not ours	
if ( !(_owner isEqualTo (name _unit)) ) exitWith { false }; 

// Has owner, ours
if (_owner isEqualTo (name _unit)) exitWith { true }; 

// Default, not the owner
false 


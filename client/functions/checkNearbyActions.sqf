//
//      Name: checkNearbyActions
//      Desc: Applies actions, data and handlers to nearby objects/vehicles/etc on the fly
//      Return: None
//

private ['_pos', '_nearby'];

_pos = [_this,0, [], [[]]] call filterParam;

if (count _pos == 0) exitWith {};

// Check actions on objects nearby
GW_NEARBY_OBJECTS = nearestObjects [_pos, [],7];
if(count GW_NEARBY_OBJECTS == 0) exitWith {};

{

	_hasActions = _x getVariable ["hasActions", false];	
	_hasHandlers = _x getVariable ["hasHandlers", false];	
	_hasData = if (isNil { _x getVariable "GW_Data" }) then { false } else { true };
	_isObject = _x call isObject; 
	_isVehicle = _x getVariable ["isVehicle", false];	

	if (_isObject && !_hasData) then {
		[_x] call setObjectProperties;
	};

	if (!_hasHandlers) then {

		if (_isObject) then {
			[_x] call setObjectHandlers;
		};

		if (_isVehicle) then {
			[_x] call setVehicleHandlers;
		};
	};	

	if (_hasActions) then {} else {   		    
   		
   		_isPaint = _x call isPaint;
   		_isSupply = _x call isSupplyBox;
   		_isTerminal = _x getVariable ["isTerminal", nil];  		

   		if (!isNil "_isTerminal") then {
   			[_x, _isTerminal] call setTerminalActions;
   		};

   		// Supply boxes
   		if (_isSupply) then {
			[_x] call setSupplyAction;
		};	

		// Paint Bucket
		if (_isPaint) then {
			[_x] call setPaintAction;
		};

   		// Object handlers & actions
   		if (_isObject) then {

			// Strip actions
			removeAllActions _x;	

			_attached = attachedTo _x;				

			if (isNull _attached) then {
				[_x] call setMoveAction;
			} else {

				if ( _attached getVariable ["isVehicle", false] ) then {
					[_x] call setDetachAction;
				};

			};

   		};     	

   	};

   	false

} count GW_NEARBY_OBJECTS > 0;
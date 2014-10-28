//
//      Name: checkNearbyActions
//      Desc: Applies actions and handlers to nearby objects/vehicles/etc on the fly
//      Return: None
//

private ['_pos', '_nearby'];

_pos = [_this,0, [], [[]]] call BIS_fnc_param;

if (count _pos == 0) exitWith {};

// Check actions on objects nearby
_nearby = nearestObjects [_pos, [],5];
if(count _nearby == 0) exitWith {};

{

	_hasActions = _x getVariable ["hasActions", false];		
		
	if (_hasActions) then {} else {

   		_isObject = _x getVariable ["isObject", false];	       
   		_isVehicle = _x getVariable ["isVehicle", false];	
   		_isPaint = _x getVariable ["isPaint", false];
   		_isSupply = _x getVariable ["isSupply", false];

   		// Supply boxes
   		if (_isSupply) then {
			[_x] call setSupplyAction;
		};	

		// Paint Bucket
		if (_isPaint) then {
			[_x] call setPaintAction;
		};

		// Vehicle handlers
   		if (_isVehicle) then {
   			[_x] call setupLocalVehicleHandlers;	 
   		}; 	

   		// Object handlers & actions
   		if (_isObject) then {
   			
   			[_x] call setupLocalObjectHandlers;

			// Strip actions
			removeAllActions _x;	

			// Attempt to stop certain action menu elements		
			_x lockCargo true;			

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

} count _nearby > 0;
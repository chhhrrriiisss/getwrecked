//
//      Name: tagObj
//      Desc: Shows object name and properties in the HUD
//      Return: None
//

private ['_obj'];

_obj = [_this,0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _obj) exitWith {};

_obj setVariable ["tag", _obj addAction ["", "", "", 0, false, false, "", "

	    if (!alive _target) exitWith {
	        _target removeAction (_target getVariable 'tag');
	    };

	    if ( (vehicle player) == player && player distance _target < 5) then {

	    	_attached = attachedTo _target;

	    	_color = [1,1,1,1];   	
	    	_color = if ( !(isNull _attached) ) then { [1,0,0,1] } else { _color };
	    	_dist = (player distance _target);
	    	_color set [3, 1 - _dist / 10];
	    	_box = [_target] call getBoundingBox;
	    	_height = _box select 2;
	       	_name = _target getVariable ['name', ''];
	       	_mass = _target getVariable ['mass', 0];
	       	_fuel = _target getVariable ['fuel', 0];
	       	_ammo = _target getVariable ['ammo', 0];
	       	_health = _target getVariable ['health', 0];
	       	_isPaint = _target getVariable ['isPaint', false];
	       	isSupply = _target getVariable ['isSupply', false];

	       	_currentZoom = if (cameraView == 'Internal' || _dist < 2.2) then { 2 * round (call getZoom) } else { round (call getZoom) };

		    _position = [
		        visiblePosition _target select 0,
		        visiblePosition _target select 1,
		        ((visiblePosition _target select 2) + (_height/2) * 1)
		    ];		    

		    if (isNull _attached) then {

				_markPosition = +_position;
				_markPosition set[2, (_markPosition select 2) - (0.1 / _currentZoom)];

				drawIcon3D [
					objectTag,
					[1,1,1,0.5],
					_markPosition,
					7,
					6,
					0,
					'',
					0,
					0,
					'PuristaMedium'
				];	  
		    };		   

		    drawIcon3D [
		        '',
		        _color,
		        _position,
		        0,
		        0,
		        0,
		        _name,
		        1,
		        0.04,
		        'PuristaMedium'
		    ];

		    if (_isPaint || _isSupply) exitWith { false };
		    	
		    _step = 0.14;

		    if (isNull _attached) then {	

		    	_position set[2, (_position select 2) - (_step / _currentZoom)];
		    	
		    	_string = format['%1%2', round (_mass / 10), 'kg'];

		    	if (_fuel > 0) then {
		    		_string = format['%1 / %2L', _string, (_fuel * 100)];			    		
		    	};

		    	if (_ammo > 0) then {
		    		_string = format['%1 / +%2%3 Capacity', _string, (_ammo * 100), '%'];		    
		    	};

		    	_halfColor = [(_color select 0), (_color select 1), (_color select 2), ((_color select 3) * .6)];

		    	drawIcon3D ['', _halfColor, _position, 0, 0, 0, _string, 1, 0.03, 'PuristaMedium'];

		    };

	  	};

	  	if (player getVariable ['isEditing', false] ) exitWith {

	  		true

	  	};

	  	false
"]];

true


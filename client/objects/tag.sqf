//
//      Name: tagObj
//      Desc: Shows object name and properties in the HUD
//      Return: None
//

private ['_obj'];

_obj = [_this,0, objNull, [objNull]] call filterParam;

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

	       	_isPaint = _target call isPaint;
	       	_isSupply = _target call isSupplyBox;
	       	_isWeapon = _target call isWeapon;

	       	_name = '';
	       	_mass = 100;
	       	_ammo = 0;
	       	_fuel = 0;
	       	_health = 100;

	       	if (!_isSupply && !_isPaint) then {

		       	_data = _target getVariable ['GW_Data', '['', 0,0,0,0,0]'];
		       	if (isNil '_data') exitWith {};
		       	_data = call compile _data;
	
				_name = _data select 0;	       	
				_mass = _data select 1;	       	
				_ammo = _data select 2;
				_fuel = _data select 3;
				_health = _data select 4;

			};

	       	if (_isSupply) then { 
	       		_owner =  _target getVariable ['GW_Owner', ''];	       		
	       		_name = if (count toArray _owner == 0) then { 'Supply Box' } else { _owner = [_owner, 10] call cropString; (format['%1`s Supply Box', _owner]) };
	       	};

	       	if (_isPaint) then { 
	       		_paintColor = _target getVariable ['color', 'Random'];  
	       		_name = format['%1 Paint', _paintColor]; 
	       	};

	       	if (_isWeapon) then { _target call renderFOV; }; 
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


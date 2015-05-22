//
//      Name: setPitchBankYaw
//      Desc: Sets an objects pitch/bank/yaw (including if its attached)
//      Return: None
//
//      Author: bapedibupa (Retrieved from BIS_fnc_setPitchBank wiki)
//

private ["_object","_rotations","_aroundX","_aroundY","_aroundZ","_dirX","_dirY","_dirZ","_upX","_upY","_upZ","_dir","_up","_dirXTemp","_upXTemp"];

_object = [_this,0, objNull, [objNull]] call filterParam;
_rotations = [_this,1, [], [[]]] call filterParam;

if (isNull _object || count _rotations == 0) exitWith {};

_aroundX = _rotations select 0; 
_aroundY = _rotations select 1; 
_aroundZ = (360 - (_rotations select 2)) - 360; 
_dirX = 0; 
_dirY = 1; 
_dirZ = 0; 
_upX = 0; 
_upY = 0; 
_upZ = 1; 

if (_aroundX != 0) then { 
    _dirY = cos _aroundX; 
    _dirZ = sin _aroundX; 
    _upY = -sin _aroundX; 
    _upZ = cos _aroundX; 
}; 

if (_aroundY != 0) then { 
    _dirX = _dirZ * sin _aroundY; 
    _dirZ = _dirZ * cos _aroundY; 
    _upX = _upZ * sin _aroundY; 
    _upZ = _upZ * cos _aroundY; 
}; 

if (_aroundZ != 0) then { 
    _dirXTemp = _dirX; 
    _dirX = (_dirXTemp* cos _aroundZ) - (_dirY * sin _aroundZ); 
    _dirY = (_dirY * cos _aroundZ) + (_dirXTemp * sin _aroundZ);        
    _upXTemp = _upX; 
    _upX = (_upXTemp * cos _aroundZ) - (_upY * sin _aroundZ); 
    _upY = (_upY * cos _aroundZ) + (_upXTemp * sin _aroundZ); 		
}; 

_dir = [_dirX,_dirY,_dirZ]; 
_up = [_upX,_upY,_upZ]; 

[_object, [_dir,_up]] call setVectorDirAndUpTo;

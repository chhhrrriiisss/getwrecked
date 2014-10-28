//
//      Name: shareVehicle
//      Desc: Allows a vehicle to be shared by adding it to the local share array
//      Return: None
//

private ['_source', '_string', '_data'];

_source =  [_this,0, "", [""]] call BIS_fnc_param;
_string = [_this,1, "", [""]] call BIS_fnc_param;
_data = [_this,2, [], [[]]] call BIS_fnc_param;

if ((count _data == 0) || _string == "" || _source == "") exitWith {};
if (_source == GW_PLAYERNAME) exitWith {};

if (!isDedicated) then {

	systemChat format["%1 wants to share: %2", _source, _string];
	systemChat format["Use !list add %1 to accept", _string];

	// Add the data to the local share array
	_arr = [_string, _data];
	GW_SHAREARRAY pushBack _arr;
};
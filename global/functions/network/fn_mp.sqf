//
//      Name: gw_fnc_mp
//      Desc: Indentical usage to gw_fnc_mp but faster
//		Author: Karel Moricky, modified by Sli
//      Return: Nothing
//

with missionnamespace do {

	private ["_params","_functionName","_target","_isPersistent","_isCall","_ownerID"];

	_params = 	[_this,0,[]] call filterParam;
	_functionName =	[_this,1,"",[""]] call filterParam;
	_target =	[_this,2,true,[objnull,true,0,[],sideUnknown,grpnull,""]] call filterParam;
	_isPersistent =	[_this,3,false,[false]] call filterParam;
	_isCall =	[_this,4,false,[false]] call filterParam;

	BIS_fnc_mp_packet = [0,_params,_functionName,_target,_isPersistent,_isCall];
	publicvariableserver "BIS_fnc_mp_packet";

	if  (!isMultiplayer) then {
		["BIS_fnc_mp_packet",BIS_fnc_mp_packet] spawn BIS_fnc_mpExec;
	};

	BIS_fnc_mp_packet

};
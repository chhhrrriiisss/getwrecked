//
//      Name: setObjectSimulation
//      Desc: Enable/disable simulation for a group or individual objects
//      Return: None
//

 _o = [_this,0, objNull, [objNull, []]] call BIS_fnc_param;

if (typename _o == "ARRAY") exitWith {

	{
		if (!isNull _x) then { _x enableSimulationGlobal (_this select 1); };
		false
	} count _o > 0;
};

if (isNull _o) exitWith {};
if (typename _o == "OBJECT") exitWith {
	_o enableSimulationGlobal (_this select 1);		
};




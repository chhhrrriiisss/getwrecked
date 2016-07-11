/*

	Mouse handler for LMB click

*/

GW_LMBDOWN = false;

waitUntil{ !isNull (findDisplay 46) };

(findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call setMouseDown; false;"];
(findDisplay 46) displayAddEventHandler ["MouseButtonUp", "_this call setMouseUp; false;"];

setMouseDown = {	
	if ((_this select 1) == 0) then {
		GW_LMBDOWN = true;
	};
};


setMouseUp = {	
	if ((_this select 1) == 0) then {
		GW_LMBDOWN = false;
	};	
};

true
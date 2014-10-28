//
//      Name: removeVehicle
//      Desc: Delete the currently previewed vehicle from the preview menu
//      Return: None
//

if (!isNil "GW_PREVIEW_VEHICLE") then {

	_result = ['DELETE VEHICLE?', '', 'CONFIRM'] call createMessage;

	if (_result) then {

		// Delete the entry
		['delete',currentName] call listFunctions;

		// Refresh the library
		GW_LIBRARY = profileNamespace getVariable ['GW_LIBRARY', []];

		// Regenerate the list
		[] call generateFilterList;

		// Go to the next vehicle
		['next'] spawn changeVehicle;			
	};
};
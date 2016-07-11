//
//      
//      New/Create Menu Functions
//      
//

changeAttributesList = compile preprocessFile "client\ui\functions\changeAttributesList.sqf";	
generateAttributesList = compile preprocessFile "client\ui\functions\generateAttributesList.sqf";
generateVehiclesList = compile preprocessFile "client\ui\functions\generateVehiclesList.sqf";	
selectVehicleFromList = compile preprocessFile "client\ui\functions\selectVehicleFromList.sqf";	

//
//      
//      Buy Menu Functions
//      
//

calculateTotal = compile preprocessFile 'client\ui\functions\calculateTotal.sqf';
setQuantityUsingKey = compile preprocessFile "client\ui\functions\setQuantityUsingKey.sqf";	
setQuantity = compile preprocessFile "client\ui\functions\setQuantity.sqf";	
generateSponsorInfo = compile preprocessFile "client\ui\functions\generateSponsorInfo.sqf";
generateItemsList = compile preprocessFile "client\ui\functions\generateItemsList.sqf";	
requestSupplyBox = compile preprocessFile "client\ui\functions\requestSupplyBox.sqf";	
purchaseList = compile preprocessFile "client\ui\functions\purchaseList.sqf";	
generateCategoryList = compile preprocessFile "client\ui\functions\generateCategoryList.sqf";	
changeCategory = compile preprocessFile "client\ui\functions\changeCategory.sqf";	


// Displays and restores purchase button text
showPurchaseMessage = {

	private ['_msg', '_button'];
	params ['_msg'];

	disableSerialization;
	_button = (findDisplay 97000 displayCtrl 97003);

	_button ctrlSetText _msg;
	_button ctrlCommit 0;

	Sleep 0.5;

	_button ctrlSetText 'PURCHASE';
	_button ctrlCommit 0;	
};

//
//      
//      Preview Menu Functions
//      
//

changeVehicle = compile preprocessFile "client\ui\functions\changeVehicle.sqf";
removeVehicle = compile preprocessFile "client\ui\functions\removeVehicle.sqf";
previewVehicle = compile preprocessFile "client\ui\functions\previewVehicle.sqf";	
generateFilterList = compile preprocessFile "client\ui\functions\generateFilterList.sqf";	

// Spawns selected vehicle
selectVehicle = {


	if (!isNil "GW_PREVIEW_VEHICLE") then {
		GW_PREVIEW_SELECTED = GW_PREVIEW_VEHICLE;
		closeDialog 0;

		// Find other vehicles in workshop that we own and delete them
		if (GW_CURRENTZONE == "workshopZone") then {

		    {
		        if (_x != GW_PREVIEW_VEHICLE) then {
		            _owner =  _x getVariable ['GW_Owner', ''];
		            if (_owner == (name player)) then {             
		                [_x] call clearPad;
		            };               
		        };   
		    } foreach ((getMarkerPos "workshopZone_camera") nearEntities [["Car"], 500]);

		};

	};
	
};

//
//      
//      Deploy Menu Functions
//      
//

selectLocation = compile preprocessFile "client\ui\functions\selectLocation.sqf";
previewLocation = compile preprocessFile "client\ui\functions\previewLocation.sqf";
changeLocation = compile preprocessFile "client\ui\functions\changeLocation.sqf";
generateSpawnList = compile preprocessFile "client\ui\functions\generateSpawnList.sqf";

abortLocation = {
	
	if (GW_DEPLOY_ACTIVE) then {
		GW_DEPLOY_ACTIVE = false;
	};
};

//
//      
//      Inventory Functions
//      
//

countItemsSupplyBox = compile preprocessFile "client\ui\functions\countItemsSupplyBox.sqf";
addItemSupplyBox = compile preprocessFile "client\ui\functions\addItemSupplyBox.sqf";
newItemsSupplyBox = compile preprocessFile "client\ui\functions\newItemsSupplyBox.sqf";	
removeItemSupplyBox = compile preprocessFile "client\ui\functions\removeItemSupplyBox.sqf";	
generateInventoryList = compile preprocessFile "client\ui\functions\generateInventoryList.sqf";	

//
//      
//      Settings Functions
//      
//

resetAllBinds = compile preprocessFile "client\ui\functions\resetAllBinds.sqf";
saveBinds = compile preprocessFile "client\ui\functions\saveBinds.sqf";
formatBind = compile preprocessFile "client\ui\functions\formatBind.sqf";
renameVehicle = compile preprocessFile "client\ui\functions\renameVehicle.sqf";
setBind = compile preprocessFile "client\ui\functions\setBind.sqf";
parseList = compile preprocessFile "client\ui\functions\parseList.sqf";
generateSettingsList = compile preprocessFile "client\ui\functions\generateSettingsList.sqf";
generateTauntsList = compile preprocessFile "client\ui\functions\generateTauntsList.sqf";
setTaunt = compile preprocessFile "client\ui\functions\setTaunt.sqf";

//
//      
//      Race Menu Functions
//      
//

// When GW_ACTIVE_RACES triggered, update races if we're in the menu
"GW_ACTIVE_RACES" addPublicVariableEventHandler { call updateRaces; };
updateRaces = compile preprocessFile "client\ui\functions\updateRaces.sqf";
raceMenu = compile preprocessFile 'client\ui\menus\race.sqf';

// Resets a bind row and saves
clearBind = {

	private ['_index'];

	//if (GW_KEYBIND_ACTIVE) then { 

		// GW_KEYDOWN = nil;
		GW_SETTING_CANCEL = true; 

		// _timeout = time + 1;
		// waitUntil {
		// 	Sleep 0.25;
		// 	(isNil "GW_SETTING_CANCEL" || time > _timeout)
		// };
		
		_index = lnbcurselrow 92001;
		lnbSetText [92001, [_index, 2], ''];
		lnbSetData [92001, [_index, 2], '-1'];

	//};

	//[] call saveBinds;

};

// Adds to the list of rows that aren't bindable
addReservedIndex = {	
	reservedIndexes set[ (count reservedIndexes), (((lnbSize 92001) select 0) -1)];
	true
};

//
//      
//      Misc
//      
//

// Starts the locking process on the target
acquireTarget = compile preprocessFile "client\ui\functions\acquireTarget.sqf";

// Lock title screens
toggleDisplayLock = compile preprocessFile "client\ui\functions\toggleDisplayLock.sqf";	
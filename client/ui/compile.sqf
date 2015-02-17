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

	_msg = _this select 0;

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

// Add the name to the settings stats column
generateName = {
	
	private ['_title', '_name'];

	disableSerialization;
	_title = ((findDisplay 92000) displayCtrl 92003);
	_name = GW_SETTINGS_VEHICLE getVariable ["name", ""];
	_name = [_name, 10, '...'] call cropString;
	_title ctrlSetText toUpper(_name);
	_title ctrlCommit 0;
};

// Resets a bind row and saves
clearBind = {

	private ['_index'];

	GW_SETTING_CANCEL = true;
	
	_index = lnbcurselrow 92001;
	lnbSetText [92001, [_index, 2], ''];
	lnbSetData [92001, [_index, 2], '-1'];

	[] call saveBinds;

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
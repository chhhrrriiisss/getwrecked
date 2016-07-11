{
	
	['AddGroupMember', [group player, _x]] call bis_fnc_dynamicGroups;
} foreach [
	(driver TEST1),
	(driver TEST2),
	(driver TEST3)
];
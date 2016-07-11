//
//      Name: isIndirect
//      Desc: Checks if we are firing in direct or indirect mode for selected gun
//      Return: None
//

if ( ({ if ((_x select 0) == _this) exitWith { 1 }; false } count GW_AVAIL_WEAPONS) > 0) exitWith { false };
true

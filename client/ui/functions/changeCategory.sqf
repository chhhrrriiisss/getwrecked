//
//      Name: changeCategory
//      Desc: Change the current category in the buy menu
//      Return: None
//

private ['_startIndex'];

_control = _this select 0;

[GW_BUY_OBJ] spawn generateItemsList;

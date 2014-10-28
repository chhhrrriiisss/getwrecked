//
//      Name: playerRespawn
//      Desc: On the tin
//      Return: None
//

_unit = _this select 0;

[_unit] spawn playerSpawn;

if(true) exitWith{};
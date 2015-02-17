//
//      Name: pubVar_fnc_logDiag
//      Desc: Log string to diag_log
//      Return: None
//

private["_str"];

diag_log format['%1', _this];
systemchat format['%1', _this];


//
//      Name: functionCompiler
//      Desc: Handles batch compilation of functions at init
//      Return: None
//

params ['_defaultDir', '_devBuild'];
private ['_defaultDir', '_devBuild', '_compileState'];

_defaultDir = (_this select 1);
_devBuild = (_this select 2);
_compileState = if (_devBuild) then { 'compile' } else { 'compileFinal' };

{	
	_dir = if (isNil { (_x select 1) }) then { _defaultDir } else { (_x select 1) };
	_format = format["%1 = %3 preprocessFile '%2%1.sqf';", (_x select 0), _dir, _compileState]; 
	call compile _format;
	false 
} count (_this select 0);

true
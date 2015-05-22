//
//      Name: setObjectOwner
//      Desc: Switch ownership of object 
//      Return: None
//

_o = [_this,0, objNull, [objNull, []]] call filterParam;
_p = [_this,1, objNull, [objNull, []]] call filterParam;

_id = owner _p;

if (typename _o == "ARRAY") exitWith {

	{
		_x setOwner _id;
		false
	} count _o > 0;
};

if (typename _o == "OBJECT") exitWith {
	_o setOwner _id;
};




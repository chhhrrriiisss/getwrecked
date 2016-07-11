//
//      Name: getBoundingBox
//      Desc: Gets the bounding box dimensions for the specified object
//      Return: Array (W, L, H)
//

private ["_bbr","_p1","_p2","_maxWidth","_maxLength","_maxHeight"];

// Use bounding box so it never clips
_bbr = boundingBoxReal (_this select 0);
_p1 = _bbr select 0;
_p2 = _bbr select 1;
_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
_maxLength = abs ((_p2 select 1) - (_p1 select 1));
_maxHeight = abs ((_p2 select 2) - (_p1 select 2));

[_maxWidth, _maxLength, _maxHeight]
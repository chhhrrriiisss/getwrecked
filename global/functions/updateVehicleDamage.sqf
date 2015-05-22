//
//      Name: updateVehicleDamage
//      Desc: Update health variable on vehicle used for health bar on tags
//      Return: None
//

private ['_oD', '_d', '_actual'];

_oD = 3; // Maximum damage the vehicle can take  (sum of all parts)
{
    _d = (_this) getHit _x;
    _d = if (isNil "_d") then { 0 } else { _d };
    _oD = _oD - _d;
} count ['palivo', 'motor', 'karoserie'] > 0;

_actual = ((_oD / 3) * 100) min ((1-(getDammage _this)) * 100);

_this setVariable ['GW_Health', (round _actual), true];

true
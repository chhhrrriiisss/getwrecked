//
//      Name: getZoom
//      Desc: Current zoom level
//      Return: Number
//
//      Author: Killzone KId
//

(
    [0.5,0.5] 
    distance 
    worldToScreen 
    positionCameraToWorld 
    [0,1.05,1]
) * (
    getResolution 
    select 
    5
)
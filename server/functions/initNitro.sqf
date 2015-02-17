if (!isServer) exitWith {};

{    

  _p = createVehicle ["UserTexture10m_F", (ASLtoATL getPosASL _x), [], 0, 'CAN_COLLIDE'];            
  _p setObjectTextureGlobal [0,"client\images\stripes_fade.paa"];      
  _p attachTo [_x, [2.4,5.8,-0.3]];      
  [_p, [-90,0,0]] call setPitchBankYaw;    
  false
} count nitroPads >0;


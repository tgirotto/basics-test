model coldroom
  parameter Real U = 0.2 "Wall heat transfer coefficient [W/m2/K]";
  parameter Real A = 100 "Total wall area [m2]";
  parameter Real C = 500000 "Effective thermal capacity of air, goods and walls [J/K]";
  parameter Real T0 = 288.15 "Initial room temperature [K]";
  parameter Real Q_max = 2000 "Refrigeration capacity [W]";
  input Real T_amb "Ambient temperature [K]";
  input Real cooling_cmd "Compressor command 0..1";
  output Real T_room "Room temperature [K]";
  output Real T_room_C "Room temperature [C]";
  output Real Q_wall "Heat gain through walls [W]";
  output Real Q_cool "Refrigeration power removed [W]";
initial equation
  T_room = T0;
equation
  Q_wall = U * A * (T_amb - T_room);
  Q_cool = Q_max * min(max(cooling_cmd, 0), 1);
  C * der(T_room) = Q_wall - Q_cool;
  T_room_C = T_room - 273.15;
end coldroom;

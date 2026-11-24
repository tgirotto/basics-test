model coldroom
  parameter Real U = 0.2 "Wall heat transfer coefficient [W/m2/K]";
  parameter Real A = 100 "Total wall area [m2]";
  parameter Real C = 500000 "Effective thermal capacity of air, goods and walls [J/K]";
  parameter Real T0 = 288.15 "Initial room temperature [K]";
  parameter Real Q_max = 2000 "Refrigeration capacity [W]";
  parameter Real T_ref = 298.15 "Reference ambient for EER [K] (25 C)";
  parameter Real EER_ref = 4.5 "EER at reference ambient (25 C) [-]";
  parameter Real T_hot = 308.15 "Hot ambient for EER [K] (35 C)";
  parameter Real EER_hot = 3.5 "EER at hot ambient (35 C) [-]";
  parameter Real EER_min = 1.0 "Lower EER clamp [-]";
  parameter Real T_lo = 288.15 "Lower ambient clamp for EER curve [K] (15 C)";
  parameter Real T_hi = 318.15 "Upper ambient clamp for EER curve [K] (45 C)";
  input Real T_amb "Ambient temperature [K]";
  input Real cooling_cmd "Compressor command 0..1";
  output Real T_room "Room temperature [K]";
  output Real T_room_C "Room temperature [C]";
  output Real Q_wall "Heat gain through walls [W]";
  output Real Q_cool "Refrigeration power removed [W]";
  output Real EER "Energy efficiency ratio Q_cool/P_el [-]";
  output Real P_el "Compressor electrical power [W]";
initial equation
  T_room = T0;
equation
  Q_wall = U * A * (T_amb - T_room);
  Q_cool = Q_max * min(max(cooling_cmd, 0), 1);
  EER = max(EER_min, EER_ref + (EER_hot - EER_ref) / (T_hot - T_ref) * (min(max(T_amb, T_lo), T_hi) - T_ref));
  P_el = Q_cool / EER;
  C * der(T_room) = Q_wall - Q_cool;
  T_room_C = T_room - 273.15;
end coldroom;

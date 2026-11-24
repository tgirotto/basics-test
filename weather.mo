model weather
  parameter Real T_mean = 298.15 "Mean ambient temperature [K] (25 C)";
  parameter Real T_amp = 10 "Amplitude [K]";
  parameter Real period = 86400 "Period [s]";
  output Real T_amb "Ambient temperature [K]";
equation
  T_amb = T_mean + T_amp * sin(2 * 3.14159265358979 * time / period);
end weather;

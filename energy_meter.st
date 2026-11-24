PROGRAM energy_meter
  VAR
    EER_in AT %ID0 : REAL;
    P_el_in AT %ID1 : REAL;
    EER_out AT %QD0 : REAL;
    P_el_out AT %QD1 : REAL;
    E_el_kWh AT %QD2 : REAL;
  END_VAR
  VAR
    E_el_J : REAL := 0.0;
  END_VAR

  EER_out := EER_in;
  P_el_out := P_el_in;

  E_el_J := E_el_J + P_el_in * 0.1;
  E_el_kWh := E_el_J / 3600000.0;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#100ms, PRIORITY := 0);
    PROGRAM instance0 WITH task0 : energy_meter;
  END_RESOURCE
END_CONFIGURATION

PROGRAM controller
  VAR
    T_room AT %ID0 : REAL;
    cooling_cmd AT %QD0 : REAL;
  END_VAR
  VAR
    setpoint : REAL := 253.15;
    hyst : REAL := 1.0;
    on_state : BOOL := FALSE;
  END_VAR

  IF T_room > setpoint + hyst THEN
    on_state := TRUE;
  ELSIF T_room < setpoint - hyst THEN
    on_state := FALSE;
  END_IF;

  IF on_state THEN
    cooling_cmd := 1.0;
  ELSE
    cooling_cmd := 0.0;
  END_IF;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#100ms, PRIORITY := 0);
    PROGRAM instance0 WITH task0 : controller;
  END_RESOURCE
END_CONFIGURATION

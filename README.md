# Cold room digital twin

An insulated cold room (walls: U = 0.2 W/m²/K, total area 100 m², so UA = 20 W/K) is kept at **-20 °C** by a refrigeration unit while the ambient temperature swings sinusoidally between 15 °C and 35 °C over 24 h. At peak ambient the wall heat gain is 20 × 55 = 1100 W, below the 2000 W refrigeration capacity.

## Modules

| Module | Path | Kind | Role |
|---|---|---|---|
| weather | `weather.mo` | modelica | `T_amb = 298.15 + 10 sin(2πt/86400)` K (15..35 °C) |
| coldroom | `coldroom.mo` | modelica | `C dT/dt = U·A·(T_amb - T) - Q_cool`, with `Q_cool = 2000 W · cooling_cmd` |
| controller | `controller.st` | structured_text | Hysteresis thermostat: ON above -19 °C, OFF below -21 °C (setpoint 253.15 K) |

## Connections / control loop

- `weather.T_amb` → `coldroom.T_amb`
- `coldroom.T_room` → `controller.T_room`
- `controller.cooling_cmd` → `coldroom.cooling_cmd`

## Units and key parameters

SI units, temperatures in K (`T_room_C` is also provided in °C). U = 0.2 W/m²/K, A = 100 m², C = 5e5 J/K (air, goods and walls), Q_max = 2000 W, initial room temperature 15 °C (`T0 = 288.15`), hysteresis ±1 K.

## Tests (`tests/`)

1. `nominal.json`: pull-down from 15 °C, held within the band after 2 days.
2. `disturbance.json`: room holds -20 °C at the 35 °C ambient peak.
3. `setpoint_step.json`: constant 35 °C ambient (no swing), room still holds.
4. `limit_safety.json`: wall gain below capacity, cooling power ≤ 2000 W.
5. `fault_warm_start.json`: room starts warm at 35 °C and must recover to -20 °C within 24 h.

## How to run

Open the workspace in OpenTwin and use the Logical canvas for the wiring. Run `build_plc` to produce the browser modules (`*.js`, `*.xml`), the FMUs (`weather.fmu`, `coldroom.fmu`) and `controller.bin`, then simulate live in the console. `run_co_simulation` only handles FMUs, so the ST controller runs through the OpenPLC `.bin` and the browser modules.

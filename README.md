# Cold room digital twin

An insulated cold room (walls: U = 0.2 W/m²/K, total area 100 m², so UA = 20 W/K) is kept at **-20 °C** by a refrigeration unit while the ambient temperature swings sinusoidally between 15 °C and 35 °C over 24 h. At peak ambient the wall heat gain is 20 × 55 = 1100 W, below the 2000 W refrigeration capacity.

## Modules

| Module | Path | Kind | Role |
|---|---|---|---|
| weather | `weather.mo` | modelica | `T_amb = 298.15 + 10 sin(2πt/86400)` K (15..35 °C) |
| coldroom | `coldroom.mo` | modelica | `C dT/dt = U·A·(T_amb - T) - Q_cool`, with `Q_cool = 2000 W · cooling_cmd`; also outputs `EER` and compressor electrical power `P_el = Q_cool / EER` |
| controller | `controller.st` | structured_text | Hysteresis thermostat: ON above -19 °C, OFF below -21 °C (setpoint 253.15 K) |

| energy_meter | `energy_meter.st` | structured_text | Monitor: receives `EER` and `P_el` from coldroom, passes them through and integrates compressor electrical energy (`E_el_kWh`) |

## Connections / control loop

- `weather.T_amb` → `coldroom.T_amb`
- `coldroom.T_room` → `controller.T_room`
- `controller.cooling_cmd` → `coldroom.cooling_cmd`
- `coldroom.EER` → `energy_meter.EER_in`
- `coldroom.P_el` → `energy_meter.P_el_in`

The OpenTwin series list is built from the connections (wires), not from module outputs. An output that no wire carries is not plotted, which is why `EER` and `P_el` are wired to `energy_meter`.

## Compressor efficiency (EER)

EER = Q_cool / P_el depends linearly on ambient temperature: **4.5 at 25 °C** and **3.5 at 35 °C**, i.e. `EER = 4.5 - 0.1·(T_amb[°C] - 25)`. The ambient used by the curve is clamped to 15..45 °C (EER 5.5..2.5), and EER is floored at 1. At full load, `P_el` is 444 W at 25 °C and 571 W at 35 °C. The curve parameters are `T_ref`, `EER_ref`, `T_hot`, `EER_hot`, `T_lo`, `T_hi` and `EER_min` in `coldroom.mo`. EER and `P_el` are outputs only and do not affect the thermal behavior.

## Units and key parameters

SI units, temperatures in K (`T_room_C` is also provided in °C). U = 0.2 W/m²/K, A = 100 m², C = 5e5 J/K (air, goods and walls), Q_max = 2000 W, initial room temperature 15 °C (`T0 = 288.15`), hysteresis ±1 K.

## Tests (`tests/`)

1. `nominal.json`: pull-down from 15 °C, held within the band after 2 days; EER is 4.5 at 25 °C ambient.
2. `disturbance.json`: room holds -20 °C at the 35 °C ambient peak; EER is about 3.5.
3. `setpoint_step.json`: constant 35 °C ambient (no swing), room still holds and EER is 3.5.
4. `limit_safety.json`: wall gain below capacity, cooling power ≤ 2000 W, electrical power ≤ 600 W at 35 °C.
5. `fault_warm_start.json`: room starts warm at 35 °C and must recover to -20 °C within 24 h; compressor draws power during pull-down.

## How to run

Open the workspace in OpenTwin and use the Logical canvas for the wiring. Run `build_plc` to produce the browser modules (`*.js`, `*.xml`), the FMUs (`weather.fmu`, `coldroom.fmu`) and `controller.bin`, then simulate live in the console. `run_co_simulation` only handles FMUs, so the ST controller runs through the OpenPLC `.bin` and the browser modules.

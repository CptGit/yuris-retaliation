# Chaos Drone — Requirements

## Unit Overview
The Chaos Drone (CD) is a Yuri faction mobile vehicle that releases hallucinatory gas,
causing enemy units to turn "dissident" — attacking their own allies.
Based on the original C&C: Yuri's Revenge Chaos Drone.

---

## R1: Attack-Based Gas Release
- CD does NOT passively emit gas. Player must order CD to attack a target.
- CD does NOT auto-acquire enemies — player must manually direct it.
- Right-clicking an enemy triggers gas release as a **sustained state** — CD keeps releasing gas continuously, independent of the target (target can die, move away, etc.).
- Gas release continues until CD **moves** or receives a **stop command**.
- CD stops moving while releasing gas; moving cancels the gas release.
- Ideally the primary weapon acts as a trigger for a special power that handles the sustained gas release.

## R2: AoE Centers on CD Position
- All gas effects radiate from the CD's position, NOT the target's position.
- The target is just a trigger — the actual AoE is always around the CD.

## R3: Gas Effect — Enemies Become Dissident
- Enemies (infantry + vehicles, not airborne) within the gas radius become dissident.
- Duration: **20 seconds**.
- Dissident units must **stop attacking CD's owner** and **attack their own former allies**.

## R4: Dissident Behavior — Uncontrollable Berserk
- When a unit becomes dissident, it MUST:
  1. Stop its current action (especially stop attacking CD's owner's units).
  2. Become **uncontrollable by anyone** — neither CD's owner nor original owner can give orders.
  3. Go berserk: chase targets beyond guard range, attack buildings, attack former allies, attack each other
  4. NOT attack the CD that triggered it.
  5. NOT be targetable by original owner's units — they completely ignore the dissident, even while being attacked.
- When the effect expires (20s): stop berserk, restore player control, return to normal behavior.


## R5: Visual — Red Gas Cloud (YR Style)
- Visual effect should resemble the original YR Chaos Drone gas:
  - Multiple chunky red smoke/cloud particles burst outward from CD center.
  - Forms a rough, organic-looking ring (NOT a clean geometric circle).
  - Pulsing cycle: burst outward, fade, burst again (each weapon fire).
- Particles must be clearly visible (large enough, last long enough).
- Ring visual size should match the gas's effective range.

## R6: Red Tint on Affected Units
- Affected enemy units are tinted red while dissident.
- Tint duration must match dissident duration (20s).

---

## Status Tracker
| Requirement | Status | Notes |
|---|---|---|


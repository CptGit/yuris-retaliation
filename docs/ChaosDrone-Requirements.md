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
| R1 Attack-Based Gas Release | 🟡 Partial | Repeating 0-damage AoE weapon; attack order → drive → fire. `CanFireWhileMoving="true"` still set, so the drone does not stop to gas. Sustained-until-move design deferred (Phase 3). |
| R2 AoE Centers on CD | ✅ Done | `DamageDealtAtSelfPosition="true"` on `ChaosDroneGasAura`. |
| R3 Enemies Become Dissident | ✅ Done | Engine-side `EMOTION_DISSIDENT` via `AttributeModifier_Dissident` (20 s, auto-recovery). Reaches every combat unit through the generated `UnitOverrides.xml`. Verified in game. |
| R4 Dissident Behavior | 🟡 Partial | ✔ attacks former allies / anything nearby, ✔ drops the stale attack order (`NAMED_STOP`), ✔ auto-recovery, ✔ former allies stop targeting it (`NON_AUTOACQUIRABLE`), ✔ player can still order attacks on it. ✖ insane units no longer fight **each other** (accepted trade-off — see dev-notes "Lessons learned" #4). ✖ does not attack buildings. |
| R5 Red Gas Cloud | 🟡 Partial | `ChaosDroneGasRing` particle system loads and fires, but too faint/small vs. the YR look. |
| R6 Red Tint | 🟡 Partial | `TintObjectsNugget` (R fixed from 3 → 1). Breaks if victims change team; Phase 2 moves it onto the AttributeModifier as `Shader=`. |

---

### Where it stands (end state, verified in game)

The whole effect is driven by the nuggets of `ChaosDroneGasAura`:

1. `AttributeModifierNugget` → `AttributeModifier_Dissident`
   (`ModelConditionsSet="EMOTION_DISSIDENT"`, `ObjectStatusToSet="NON_AUTOACQUIRABLE"`,
   `Duration="20s"`). The engine flips hostility and recovers on its own; the status
   stops the victim's own side from auto-targeting it, while the player can still
   order attacks on it.
2. `TintObjectsNugget` → red tint, 0 + 18 + 2 s, refreshed on every tick.
3. `LuaEventNugget` → `BecomeDissident` → one `NAMED_STOP`, so the victim drops the
   attack order it already had. Delivered to all 80 combat units via the generated
   `Data/UnitOverrides/UnitOverrides.xml`.

`AttributeModifier` is the **only** timekeeper: both the effect and the tint last
20 s after the last gas tick. Known gaps: insane units do not attack buildings, and
they do not fight each other (engine limitation, accepted).

## M1 Experiment — engine-native dissident (Phase 1, ACTIVE)

### Why
KW's Redeemer "Rage Generator" is the shipped, working precedent for this exact
effect, and it is pure XML:

```xml
<!-- KW GlobalData/Weapon.xml ~12812-12836 -->
<WeaponTemplate id="NODWarmechRageGenerator" RadiusDamageAffects="ENEMIES NEUTRALS">
  <Nuggets>
    <DamageNugget Damage="0" Radius="500.0" ... />
    <AttributeModifierNugget AttributeModifierName="AttributeModifier_Hallucinate" Radius="500">
      <SpecialObjectFilter Rule="ANY" Include="INFANTRY VEHICLE" Exclude="AIRCRAFT" />
    </AttributeModifierNugget>
  </Nuggets>
</WeaponTemplate>

<!-- KW GlobalData/AttributeModifier.xml:146-151 -->
<AttributeModifier id="AttributeModifier_Hallucinate" Category="NONE" Duration="6s"
                  ModelConditionsSet="EMOTION_DISSIDENT" />
```

The modifier does **nothing except** set the `EMOTION_DISSIDENT` model
condition — therefore the hostility flip, the loss of player control and the
automatic recovery are **engine-side**.

RA3 keeps every part of that path but never uses it in vanilla content:

| Part | Where |
|---|---|
| `EMOTION_DISSIDENT` model condition | `Schemas/Includes/ModelState.xsd:425` |
| `ObjectDefectionHelper` on **every** object | `Xml/BaseObjects/BaseObject.xml:31-35` |
| `TEMPORARILY_DEFECTED` object status | `Schemas/Includes/ObjectStatus.xsd:71` |
| `TemporarilyDefectUpdate` (`DefectionFrameCount`) | `Schemas/Modules/TemporarilyDefectUpdate.xsd:8` |

KW attaches `TemporarilyDefectUpdate` to BaseVehicle/BaseInfantry/BaseSquad/
BaseStructure with 100–300 frames; **RA3 base objects do not have it**, so if
"auto-recovery" is needed we must add it ourselves (Phase 2a step 2).

### What changed for the experiment
| File | Change |
|---|---|
| `Data/Yuri/ChaosDrone/AttributeModifier.xml` | Added `AttributeModifier_Dissident` (variant A: model condition only, KW-identical) and `AttributeModifier_DissidentStatus` (variant B: + `TEMPORARILY_DEFECTED`). |
| `Data/Yuri/ChaosDrone/WeaponTemplate.xml` | `AttributeModifierNugget` now points at `AttributeModifier_Dissident`; `LuaEventNugget` commented out; filters tightened (`Exclude="AIRCRAFT STRUCTURE"`); tint colour `R` fixed 3 → 1. |
| `Additional/Data/Scripts/ScriptEvents.xml` | `BecomeDissident` / `RecoverFromDissident` handlers commented out so the old Lua cannot mask the engine. |

### How to test
1. `bash scripts/deploy.sh` (in WSL) → build in EALAModStudio → `bash
   scripts/fix_window.sh` → launch.
2. Skirmish vs. an AI. Build a Soviet War Factory (the `Test/` include sets its
   build time to 0 and drops the tech dependency), then build a **Chaos Drone**
   — `CommandData.xml` makes it the first item in `SovietWarFactoryCommandSet`.
3. Drive the drone next to a group of AI infantry/vehicles and **right-click
   attack** one of them.

### Acceptance checklist
| # | Question | Verdict |
|---|---|---|
| 1 | Do poisoned units **turn and attack their own side**? | ← decides M1 |
| 2 | Do their own units **stop auto-targeting** them? | |
| 3 | After 20 s, do they **recover** and resume normal AI? | |
| 4 | Do they chase far / attack buildings (R4.3)? | |
| 5 | Do they refuse to attack the drone (R4.4)? | |

Interpretation:
- **Red tint appears, no berserk** → weapon/filter is fine, the engine's
  dissident hook is what failed. Try variant B (`AttributeModifier_DissidentStatus`).
- **Neither tint nor berserk** → the weapon is not reaching the victims at all
  (attack order, range, or filter problem).
- **Works** → go to Phase 2a and delete the Lua path.

### Result log

**M1 — 2026-10-24 — WORKS (with one gap, now fixed).**

Tested build `Retaliation_1.0.big` @ 2026-10-24 21:06.

Observed: units in the gas **do** attack their own teammates, and they recover
on their own afterwards. So `ModelConditionsSet="EMOTION_DISSIDENT"` is the real
mechanism in RA3 too — KW's `AttributeModifier_Hallucinate` ports over as-is.

The single gap: a unit that had **already locked onto the CD owner before**
being gassed kept firing at it and never switched to a former ally. YR does not
behave that way. Root cause: the engine flips hostility but does **not
re-evaluate an attack order that was already issued**.

Fix (implemented):
1. `BecomeDissidentFunction` in `Scripts.lua` now only does
   `ExecuteAction("NAMED_STOP", ref)` — dropping the stale order makes the unit
   re-acquire targets. Guarded by a 20 s window table (`DissidentUntilFrame`)
   so the ~2 s gas re-application does not stop the victim over and over, which
   would prevent it from ever attacking.
2. That Lua call has to run on every possible victim, but a `ScriptedEvent`
   only reaches objects carrying a `LUAEventList`. The module
   `ModuleTag_DissidentEvents` (-> `DissidentFunctions`) is added to the mod's
   `Data/BaseObjects/BaseInfantry.xml` and `BaseVehicle.xml`, which every
   infantry/vehicle inherits — one place per category instead of overriding
   hundreds of units.
   (An earlier attempt shadowed `BaseObject` instead; that made the asset
   builder load vanilla `SageXml/BaseObjects/BaseObject.xml` as well, i.e. two
   definitions of the same asset with unclear precedence. Avoid.)
3. `DissidentFunctions` (in `ScriptEvents.xml`) contains only the
   `BecomeDissident` handler, so units with their own event list (Conscript)
   do not get duplicates.
4. The `LuaEventNugget` in `WeaponTemplate.xml` is re-enabled and sits after
   the `AttributeModifierNugget`.

Ruled out while investigating (no need to revisit):
- `UnifiedControlBehavior` — extends `CaptureBehaviorModuleData`, is about co-op
  control unification (`SAME_PLAYER` / `ALLIED_PLAYERS`), not berserk.
- No vanilla RA3 `AttributeModifier` sets `RAMPAGING` / `ENRAGED` /
  `UNCONTROLLABLE` / `TEMPORARILY_DEFECTED`, so there is no shipped precedent.
- `AttributeModifier_DissidentStatus` (MC + `TEMPORARILY_DEFECTED`) is unused —
  unnecessary now that the model condition alone works.

**Attempt 2 — 2026-10-24 (later) — Lua never ran.**

Expected: victims drop their stale order and re-acquire. Observed:
1) they do **not** drop the original target, 2) they keep attacking the player,
3) they also attack the Chaos Drone.

`LIVE_OUTPUT.txt` had **zero** `[BecomeDissident]` lines while
`[OnBaseUnitCreated]` kept logging ⇒ the handler was never invoked at all.

Cause: `BaseInfantry.xml` / `BaseVehicle.xml` already carry
`<LUAEventList id="ModuleTag_LUAEventList" EventListName="BaseScriptFunctions"/>`,
and **an object honours only one `LUAEventList` module**. The extra
`ModuleTag_DissidentEvents` -> `DissidentFunctions` was silently ignored.

Fix: `BecomeDissident` is registered in `BaseScriptFunctions` again; the extra
module and the `DissidentFunctions` list are removed.

For issue 3 (attacking the drone): `OnChaosDroneCreated` now also calls
`ObjectSetObjectStatus(self, "NON_AUTOACQUIRABLE")`. The drone already had the
`NOT_AUTOACQUIRABLE` KindOf, but the real object status is what target
acquisition respects. Deliberately **no** `UNATTACKABLE` — insane units stay
killable, they just should not pick the drone.

**Attempt 3 — 2026-10-24 — core works, two gaps.**

Confirmed: gassed units switch away from the drone and attack their own
teammates, and the log shows `[BecomeDissident] dropping order` (166 lines in one
session), so the Lua reaches essentially every victim — not just conscripts.

Gap A — anti-air units keep shooting the drone even though they ARE affected
(they turn red). NOT a range problem: raising the cloud to 250 changed nothing
and was reverted.
Cause: the weapon carried a 0-damage `DamageNugget`, so every gas tick counted as
a hit on the victim, and SAGE units **auto-retaliate** against whatever damaged
them. Retaliation ignores `NON_AUTOACQUIRABLE`, so immediately after Lua
force-stops the unit it re-picks the drone as its retaliation target.
Fix: the `DamageNugget` is gone — the other nuggets carry their own filter and
radius and do not need a damage "hit".

Gap B — with nothing to shoot, an insane unit stands idle and never attacks its
own buildings.
First attempt used `UNIT_SET_STANCE(AGGRESSIVE)`, but the stance cannot be
restored afterwards (the AttributeModifier's expiry fires no Lua event), and a
permanent stance change is an unwanted side effect — reverted.
Fix: `NAMED_HUNT` after the stop. HUNT is an *order*, not a stance: it makes the
unit seek targets (structures included) and leaves no permanent state behind.

**Attempt 4 — 2026-10-24 — "keeps shooting the drone" is a threat/hate problem.**

Correction from the author: the anti-air units DO have closer valid enemies (other
conscripts) and still keep firing at the drone, so the "nearest enemy" explanation
is wrong.

What is really going on: SAGE units hold on to whatever attacked them. `NAMED_STOP`
clears the *order*, but the target chooser immediately re-acquires, and the drone
is still a preferred target — it fired at them and is the object they were already
engaging (`ThreatLevel` and the AI's most-recent-attacker memory both feed this).
That is why the same mechanic behaves differently per unit: units that were
engaging the drone keep doing so, units that were not just pick a new target.

Tried and reverted:
- `NON_AUTOACQUIRABLE` on the drone via the upgrade route
  (`Upgrade_ChaosDroneNonAcquirable` -> `AttributeModifierUpgrade` ->
  `AttributeModifier_NonAcquirable`, granted with `ObjectGrantUpgrade`). It
  compiles (`Compiling UpgradeTemplate:Upgrade_ChaosDroneNonAcquirable`), but the
  author does **not** want the drone immune to *all* enemies — only to insane
  ones. Reverted.
- `ObjectSetObjectStatus(self, "NON_AUTOACQUIRABLE")` from Lua: no effect.

Conclusion: RA3 has no per-target "immune to these units only" primitive. The only
mechanism whose immunity applies to the insane unit alone is a change of
allegiance (team switch) — and that necessarily also makes the drone owner's whole
army safe from that unit. Open decision, see Remaining work.

Also removed `NAMED_HUNT`: it did not make insane units attack buildings, so it
only risked sending them wandering.

**Attempt 5 — 2026-10-24 — ROOT CAUSE FOUND: the event never reached the unit.**

Decoded the log: `ObjectDescription()` prints the template id in hex, and
`{-1808793811}19ab11af` → 0x19AB11AF = 430,641,583 → `StringHashes.xml` says
`SovietAntiInfantryInfantry`. **All 198 `[BecomeDissident]` lines were conscripts
— anti-air units never appeared once.**

So the anti-air units were never missing a "hate reset": they were getting the
red tint and the `EMOTION_DISSIDENT` flip (both pure-XML nuggets) but never
received the `LuaEventNugget` ScriptedEvent, so `NAMED_STOP` never ran on them.

Why: a `LUAEventList` declared on `BaseInfantry` / `BaseVehicle` is **not
inherited** by child objects. Only units that declare it themselves get events —
until now that was only the Conscript, because it is the single unit listed in
`UnitOverrides.xml`.

Fix: `Data/UnitOverrides/UnitOverrides.xml` is now **generated** for all 87
vanilla combat units in `Allied/Units`, `Soviet/Units`, `Japan/Units` (include the
vanilla asset, re-declare it with `inheritFrom="<self>"` and add one
`LUAEventList`). The asset builder accepts it and logs
`unitoverrides.xml: Compiling GameObject:SovietAntiAirShip`.

Also removed `AttributeModifier_NoAttackPulse`: confirmed in game that `NO_ATTACK`
only suppresses firing, it does not cancel the attack order — the only visible
effect was a 0.5 s stutter on each gas tick.

Everything else that was tried and disproved along the way is listed in the
earlier attempts; the short version is that no XML-only mechanism can cancel an
attack order, so a unit either receives Lua or it does not.

### Remaining work
- **RESOLVED — R4.4 (insane units must not attack the drone).** Root cause was
  never the drone or threat memory: `BecomeDissident` simply never reached the
  units (see Attempt 5), so `NAMED_STOP` never ran and the stale "attack the drone"
  order survived. With the event delivered, units drop that order themselves.
- **OPEN (accepted) — insane units vs each other.** `NON_AUTOACQUIRABLE` is what
  keeps the victim's former allies from shooting it, and that same status hides it
  from other insane units. The engine cannot express per-observer hostility, so
  this is deliberately left as-is (see dev-notes "Lessons learned" #4).
- R1: the drone does not stop to release gas (`CanFireWhileMoving="true"` is still
  set); the "sustained until move/stop" design is still open (see Phase 3 below).
- R5: gas visuals are still faint/small compared with YR (gas radius is 150 again;
  the ring was reverted with it).
- R6: tint is still `TintObjectsNugget`; move it onto the `AttributeModifier`
  (`Shader=`) so it cannot break when relationships change.
- R4 (open, low priority per the author): insane units do not attack buildings.
  `NAMED_HUNT` did not help. The remaining option is a real recovery hook — drop
  `ModelConditionsSet` from the AttributeModifier, set the model condition from
  Lua with `UNIT_SET_MODELCONDITION_FOR_DURATION` (which *does* fire
  `ModelConditionEvent`) and use that event to set/restore
  `UNIT_SET_STANCE(AGGRESSIVE)`.
- Phase 2b below is obsolete — the engine route works; kept only as history.

### Phase 2b (if M1 fails — harden the Lua route)
1. Per-victim bookkeeping keyed by `GetObj.UniqueId`, recorded **only on first
   application** (the gas re-fires every 2 s; `LIVE_OUTPUT.txt` shows duplicate
   `[BecomeDissident] ENTER` for the same object).
2. Restore path with a fallback: if the original team no longer exists, move the
   unit to a permanent per-player holding team, then
   `UNIT_AI_TRANSFER(ref, true)`. This is the likely root cause of "doesn't
   return to computer control".
3. Drive expiry from `GetFrame()` rather than `ModelConditionEvent`, so recovery
   does not depend on model-condition churn.
4. Pass real booleans: `ObjectForbidPlayerCommands(self, true)` and
   `ExecuteAction("UNIT_AI_TRANSFER", ref, true)` — the reference documents BOOL
   and `0` is truthy in Lua.

### Revert (back to the Lua implementation)
1. `WeaponTemplate.xml`: `AttributeModifierName` → `"AttributeModifier_Hallucinate"`,
   and uncomment the `LuaEventNugget` (keep it **last** — it changes the victim's team).
2. `ScriptEvents.xml`: uncomment the two handlers marked `[M1 EXPERIMENT]`.



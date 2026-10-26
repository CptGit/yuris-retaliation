## Workflow (mandatory)

**The repo is the only source of truth.** `d:\Games\RA3_modding\yuris-retaliation`
is where every change is made and reviewed. `RA3_MODSDK-X\Mods\Retaliation` is a
*generated* copy: never edit it by hand, and never let the two drift.

Order of operations for any change:

1. Edit files in the repo — `yuris-retaliation/src/Retaliation/**` for mod data,
   `docs/` + this file for notes.
2. If `Scripts.lua` changed, recompile it (`scripts/compile.sh`, or run `luac4`
   with the working directory set to
   `src/Retaliation/Additional/Data/Scripts`). The output **must** end up as
   `src/Retaliation/Additional/Data/Scripts/luac.out` — the game loads the
   compiled bytecode, so a stale `luac.out` means the Lua change does nothing.
3. Run `bash scripts/deploy.sh` (WSL). That is the step that syncs repo -> SDK.
   Do not call `copy.sh` directly.
4. Build in EALAModStudio, then `bash scripts/fix_window.sh`, then launch.

Sanity check that nothing drifted (should print `IDENTICAL`):

    wsl bash -lc "diff -r /mnt/d/Games/RA3_modding/yuris-retaliation/src/Retaliation \
                         /mnt/d/Games/RA3_modding/RA3_MODSDK-X/Mods/Retaliation"

Build outputs are disposable and are *not* source: `RA3_MODSDK-X/builtmods/**`
and `Documents\Red Alert 3\Mods\<ModName>\*.big|*.skudef`.

For a headless schema check without launching the game (run **detached**, the
builder needs a rooted path for mod.xml; a foreground poll would kill it):

    tools\BinaryAssetBuilder.exe D:\...\Mods\Retaliation\Data\mod.xml /od:builtmods /iod:builtmods ...
    # a relative path fails with: "Path for document ... is not rooted"

## Requirements

### Mind Control
Yuri's mind control ability.

SpecialPower_ActivateYurikoLureRank1, Yuriko campagin, EP1

SpecialPower_ManipulateObject, Mastermind, C&C3

### Hallucinatory Gas
Chaos Drone's ability, which causes enemies to behave violently, even against
their own forces. 

Redeemer(MODMetaUnit), KW
> `EMOTION_DISSIDENT` is defected in nature

ParalyzeType
> Pause but not cancel the unit's original operation. Intended to use this to
"patch" `EMOTION_DISSIDENT` but no use.

LUA
> In progress
Evenlist `BaseScriptFunctions` does not work for all units. We need to
insert `LUAEventList` with it for each unit if we want it to work for
every unit.
Now we need to resolve the issue of the affected unit not returning to
the original control of computer after the gas effect expires.

NON_AUTOACQUIRABLE

Some ideas for implementing the same firing effect when selecting as
 the special power firing.
- Make a dummmy main weapon that remove some ObjectStatus restriction
  for the special power weapon, such that the special power weapon
  fires immediately.
- When firing by selecting, creates an OCL at itself and fires the
  special power weapon.
- Write LUA script, where `other`(the chaos drone itself) fires the
  special power weapon.

## Issues

The first line works but the commented line does not. I believe they are
supposed to behave the same.
```lua
function ExampleFunction(self)
    ExecuteAction("NAMED_USE_COMMANDBUTTON_ABILITY", self, "Command_ToggleTargetPainter")
    -- ObjectDoSpecialPower(self, "SpecialPower_ToggleTargetPainter")
end
```

idk why but OnDamaged seems not working for guardian tanks.

Show an empty text box when I call
`ExecuteAction("SHOW_MILITARY_CAPTION", "hello", 10)`

ForbiddenTargetModelCondition does NOT work in LuaEventNugget.

## Docs

### Weapon
`FireWeaponUpdate` lets the weapon keep firing at the current position
of the owner unit. `WeaponFireSpecialAbilityUpdate` does the same
thing but along with special power triggering firing.

### LUA
`LuaEventNugget`: This nugget triggers the specified event at the
object that gets hit by the nugget ("radius" is effective, which means
triggering an event at all the objects within a range). If the
object registers an `<EvenList>` that handles the event, then it will
react.

`ScriptedEvent` is of two kinds. Parameter format is fixed: self, other and
string. See comments in `ScriptEvents.xml`.

Some ExecutionAction and EvluateCondition functions do not work for object type.
So we have to pass corresponding string reference instead.

Inherited evenlist must be put before inheriting ones in `ScriptEvents.xml`. For
example, `BaseScriptFunctions` has to be put before any other evenlist if it is
not empty.

### XML base
`xai:joinAction="Replace/Append/Remove/Overwrite"`: to be different
from parent when inheriting.

### Misc
Mod name cannot exceed 15 characters, which is one of SDK's
limitations.

---

## Findings: how "defection / dissident" really works in SAGE

### The KW Redeemer is the reference implementation
C&C3:KW's Redeemer "Rage Generator" (enemies attack their own) is **pure XML**:

- `SDKs/KanesWrathXMLFiles/GlobalData/Weapon.xml` ~12812-12836
  `NODWarmechRageGenerator` = `DamageNugget Damage="0" Radius="500"` +
  `AttributeModifierNugget AttributeModifierName="AttributeModifier_Hallucinate" Radius="500"`
  with `SpecialObjectFilter Rule="ANY" Include="INFANTRY VEHICLE" Exclude="AIRCRAFT"`.
- `SDKs/KanesWrathXMLFiles/GlobalData/AttributeModifier.xml:146-151`
  `AttributeModifier_Hallucinate` = **only** `ModelConditionsSet="EMOTION_DISSIDENT"`,
  `Duration="6s"`. No status, no modifiers, no Lua.

⇒ The hostility flip, the loss of player control and the auto-recovery are
**engine-side**, keyed off the `EMOTION_DISSIDENT` model condition. That is why
it is "defected in nature".

The ability wrapper is `SpecialPower` + `WeaponFireSpecialAbilityUpdate`
(`NOD/Units/NODMetaUnit.xml` ~2010-2027):
`SpecialPower UpdateModuleStartsAttack="true"` +
`WeaponFireSpecialAbilityUpdate SpecialWeapon=... WhichSpecialWeapon=1
WeaponSlotID=10 WeaponSlotType=SECONDARY_WEAPON BusyForDuration="1s"`.

### RA3 has the parts but never uses them
| Part | RA3 location | Used by vanilla RA3? |
|---|---|---|
| `EMOTION_DISSIDENT` | `Schemas/Includes/ModelState.xsd:425` | no |
| `ObjectDefectionHelper` | `Xml/BaseObjects/BaseObject.xml:31-35` (every object) | yes (module only) |
| `TEMPORARILY_DEFECTED` | `Schemas/Includes/ObjectStatus.xsd:71` | no |
| `TemporarilyDefectUpdate` | `Schemas/Modules/TemporarilyDefectUpdate.xsd:8` | **module not on any RA3 base object** |

KW does attach `TemporarilyDefectUpdate` (`DefectionFrameCount`=`300` on
BaseVehicle, `100` on BaseInfantry/BaseSquad/BaseStructure); 30 fps ⇒ frames ≈
seconds × 30. RA3's `BaseObject.xml` even carries the comment
"The defection system needs to be redone".

Dead ends: RA3's `EmotionTemplate` system has no `RAMPAGE` in `EmotionAIType`
(`Schemas/Includes/Emotion.xsd:24-33`) and only two CHEER templates exist in
`GlobalData/EmotionTemplates.xml`; `DefectorSpecialPower` is an empty Generals
legacy module with zero KW usage; `UnifiedControlBehavior` extends
`CaptureBehaviorModuleData` and is only about co-op control unification
(`SAME_PLAYER` / `ALLIED_PLAYERS`), not berserk.

#### VERDICT (tested in game, 2026-10-24): `EMOTION_DISSIDENT` WORKS in RA3
Setting `ModelConditionsSet="EMOTION_DISSIDENT"` on enemies via
`AttributeModifierNugget` **does** make them attack their own side, and the
engine restores them when the modifier's `Duration` expires. So KW's
`AttributeModifier_Hallucinate` approach ports to RA3 essentially as-is — the
defection code path is alive, despite the "needs to be redone" comment.

What the engine does NOT do: **re-evaluate an attack order that was already
issued**. A victim that was already shooting at player X keeps shooting player X
(and never switches to its own teammates). YR does not behave like that.
Fix: clear the order once from Lua (`ExecuteAction("NAMED_STOP", ref)`) when the
gas lands — see `BecomeDissidentFunction` in `Scripts.lua`.

Because a `ScriptedEvent` only reaches objects that carry a `LUAEventList`, that
single Lua call needs a hook on every potential victim: add
`LUAEventList -> DissidentFunctions` to the mod's `BaseInfantry.xml` and
`BaseVehicle.xml` (one place per category) instead of editing every unit.
Do **not** try to shadow `BaseObject` for this — the asset builder then also
loads vanilla `SageXml/BaseObjects/BaseObject.xml`, giving two definitions of
the same asset with unclear precedence.

⇒ Team switching (`UNIT_SET_TEAM`) is **not** needed. Keep `EMOTION_DISSIDENT`
and just drop the stale order.

### ObjectStatus numeric indices
`sage lua` `ExecuteAction("UNIT_CHANGE_OBJECT_STATUS", UNIT, INDEX, BOOL)` needs
a number, but the enums differ per game. RA3's authoritative order is
`Schemas/Includes/ObjectStatus.xsd`; **index = line number − 6** (DESTROYED is
line 6 = 0). `LUA教程/.../lists/ObjectStatusList.txt` is the **KW** order — do
not mix them.

Verified RA3 values: `NO_ATTACK`=5, `NO_SPECIAL_ABILITY`=6, `NO_AUTO_ACQUIRE`=25,
`IMMOBILE`=51, `ENRAGED`=58, `RAMPAGING`=60, `UNATTACKABLE`=63,
`TEMPORARILY_DEFECTED`=65, `STAND_GROUND`=71, `UNCONTROLLABLY_SCARED`=72,
`FORCE_ATTACKING`=142, `NON_AUTOACQUIRABLE`=178, `NO_BRIBE`=216, `SCRAMBLED`=255.

**Better: avoid indices.** `AttributeModifier` takes *names*
(`ObjectStatusToSet`, `ModelConditionsSet`) and its `Duration` expiry removes
them automatically — RA3 has no `ObjectStatusToClear` (that is a CNC4 API), so
name-based modifiers are the only index-free way to get timed statuses.

### AttributeModifier is the right place for timed states
`Schemas/AssetTypeAttributeModifier.xsd:87,93-96`: `Duration` (0 = infinite),
`ModelConditionsSet`/`ModelConditionsClear`, `ObjectStatusToSet`, `StackingLimit`
(+ `Shader`, `StartFX`, `EndFX` as used by RA3's own
`AttributeModifier_SmokeBomb` and `AttributeModifier_IronCurtain`).
Vanilla `AttributeModifier_SmokeBomb` = `ObjectStatusToSet="NON_AUTOACQUIRABLE"`
+ `Duration="10s"` is the canonical "timed status" pattern.

### Making Lua events reach *every* unit
A `ScriptedEvent` only reaches objects that carry a `LUAEventList` behaviour with
a matching `EventListName`.

**CORRECTION (tested 2026-10-24): a `LUAEventList` on `BaseInfantry` /
`BaseVehicle` is NOT inherited by the child objects.** Only units that declare the
module *themselves* receive the events. Proof: after wiring `BecomeDissident`
through `BaseScriptFunctions`, all 198 `[BecomeDissident]` lines in
`LIVE_OUTPUT.txt` belonged to one template — `19ab11af` (0x19AB11AF =
430,641,583 = `SovietAntiInfantryInfantry`, looked up in
`builtmods/StringHashes.xml`). Anti-air units were getting the red tint (pure-XML
nuggets) but never the event, so they never ran `NAMED_STOP`.

⇒ Budget for **one override per unit**, not one per base object. Generate them:
include the vanilla asset, then re-declare it with `inheritFrom="<self>"` and add
the single `LUAEventList`. `Data/UnitOverrides/UnitOverrides.xml` is generated
this way (87 units across Allied/Soviet/Japan `Units` folders) and the asset
builder accepts it without duplicate-definition errors.

Tip for identifying templates in the log: `ObjectDescription()` prints
`Object N [{mask}TEMPLATEHASH]`; the hex template id converts straight to the
decimal `Hash` in `builtmods/StringHashes.xml`.

**The mod already has that global hook, and an object honours only ONE
`LUAEventList` module.** `Data/BaseObjects/BaseInfantry.xml` and
`BaseVehicle.xml` already end with

    <LUAEventList id="ModuleTag_LUAEventList" EventListName="BaseScriptFunctions" />

so every infantry/vehicle gets `BaseScriptFunctions`. Proof: `[OnBaseUnitCreated]`
lines appear for every unit in `LIVE_OUTPUT.txt`.

⇒ **New handlers for all units must be added to `BaseScriptFunctions`, not to a
new `LUAEventList` module.** Adding a second module (e.g.
`<LUAEventList id="ModuleTag_DissidentEvents" EventListName="DissidentFunctions"/>`)
is silently ignored — the first attempt at the gas fix produced **zero**
`[BecomeDissident]` lines in the log while `[OnBaseUnitCreated]` kept logging.

Two things to avoid:
- Do **not** shadow `BaseObject` to get a global hook: the asset builder then
  also loads `SageXml/BaseObjects/BaseObject.xml`, so `BaseObject` is defined
  twice with unclear precedence. (Seen in the build log: `Compiling
  GameObject:BaseObject` immediately followed by
  `Loading '...\sagexml\baseobjects\baseobject.xml'`.)
- Do **not** expect `ModelConditionEvent` to fire for model conditions set by an
  `AttributeModifier` — only Lua-set conditions trigger it (already noted above).

### ObjectFilter details
`Schemas/Includes/ObjectFilter.xsd`: attributes `Rule` (UNPARSED/ALL/ANY/NONE),
`Relationship` (bitmask of `ALLIES`/`ENEMIES`/`NEUTRAL`/`SAME_PLAYER` —
**singular `NEUTRAL`**), `Include`/`Exclude` (KindOf bitflags),
`StatusBitFlags`/`StatusBitFlagsExclude`.
`Rule="ANY"` + `Relationship` + `Include` is the idiomatic RA3 combination
(Relationship and Include are AND-ed); vanilla `Weapon.xml` uses exactly that
shape. Pair `Include` with an `Exclude` (e.g. `Exclude="AIRCRAFT STRUCTURE"`)
or aircraft will slip through `Include="VEHICLE"`.

### Colour values
`Schemas/Includes/Base.xsd:4-17`: `RGBColor` is `xs:float` in 0..1, so
`<Color R="1" G="0" B="0"/>` — not 3.

## Lessons learned (hard-won, in the order they bit us)

### 1. `EMOTION_DISSIDENT` works in RA3 — the engine does the defection
`AttributeModifier` with `ModelConditionsSet="EMOTION_DISSIDENT"` + `Duration` is
all it takes; hostility flips and recovers automatically. This is exactly how KW's
Redeemer "Rage Generator" is implemented. No team switching, no Lua needed for the
defection itself.

### 2. A ScriptedEvent does NOT reach most vanilla units
`LUAEventList` is **not inherited** from `BaseInfantry`/`BaseVehicle`. Only units
that declare the module themselves get the event. Result: `BecomeDissident` ran
only for the Conscript (the single unit in `UnitOverrides.xml`) while every other
gassed unit got the pure-XML effects and nothing else.

⇒ `Data/UnitOverrides/UnitOverrides.xml` is **generated** by
`scripts/gen-unitoverrides.ps1` for all 80 combat units of the three factions.

### 3. Never re-declare a module with an existing id unless you mean to replace it
Module identity = `id`, so an override that adds
`<LUAEventList id="ModuleTag_LUAEventList" .../>` **replaces** the unit's own list.
The Hammer Tank ships `EventListName="SovietAntiVehicleVehicleTech1Functions"`, and
its `OnCreated` handler hides every salvaged-weapon sub-object — replacing the
module made **all secondary weapon models render at once**. The generator now
skips any unit that already declares a `LUAEventList`.

### 4. Object statuses are global, so "one-way ally" is impossible
SAGE hostility lives on the **player pair** and is symmetric; `ObjectStatus` is per
**object** and applies to every observer. Therefore:
- `UNATTACKABLE` → nobody can hit it (including your own army) — too strong.
- `NON_AUTOACQUIRABLE` → nobody *auto-targets* it, which also stops other insane
  units from fighting each other.

Accepted trade-off in this mod: `NON_AUTOACQUIRABLE` stays on (its own former
allies leave it alone, the player can still order attacks manually), and insane
units no longer fight each other. `UNIT_CONTEXT_SENSITIVE_ATTACK` between insane
units was tried to bridge that and did not work.

### 5. Do not drive one model condition from two timer sources
`AttributeModifier` re-applies `EMOTION_DISSIDENT` on every gas tick (refreshing
its 20 s), while Lua's `UNIT_SET_MODELCONDITION_FOR_DURATION` only fires once (the
debounce). The un-refreshed Lua timer expired first and cut the insanity short
while the red `TintObjectsNugget` was still fading. Let the AttributeModifier be
the only timekeeper.

### 6. Debugging: read the template out of `ObjectDescription()`
It prints `Object 247 [{-1808793811}19ab11af, owned by player 3]`. The hex block is
the template hash: `0x19AB11AF = 430641583`, and
`builtmods/StringHashes.xml` maps `430641583 -> SovietAntiInfantryInfantry`. That
single lookup is what proved the event never reached the anti-air units.

### 7. Build-tool gotchas
- `BinaryAssetBuilder` needs an **absolute** path for `mod.xml`; a relative one
  fails with `Path for document ... is not rooted`.
- Its error messages are **localized**. Grep for `参数名` / `异常` / `Exception`,
  not just "Error" — an entire build failing on missing art first looked clean
  because the messages were Chinese.
- The SDK's `Art` folder is incomplete. Instantiating a unit *variant* forces the
  builder to resolve its models, which can fail with
  `长度不能小于 0 / 参数名: length` + GB2312 decoder errors when a `.w3x` is
  missing (e.g. `SUAntiInfantryInfantry_MMCNC.w3x` for the Molotov-cocktail
  Conscript). ⇒ only override the primary unit and `_xxx` variants.
- Run the builder **detached** (`Start-Process -WindowStyle Hidden`); polling from
  the same console kills it.

### Weapon nugget schemas worth remembering
`Schemas/AssetTypeWeaponTemplate.xsd`:
- `LuaEventNugget` (:598-611) — `EventName`, `SendToEnemies`/`SendToAllies`/`SendToNeutral`,
  plus inherited `Radius` and `SpecialObjectFilter`.
- `TintObjectsNugget` (:403-416) — `PreColorTime`/`SustainedColorTime`/`PostColorTime`/`Frequency`/`Amplitude`.
- `DamageDealtAtSelfPosition` (:948) — AoE centred on the firer, not the target.


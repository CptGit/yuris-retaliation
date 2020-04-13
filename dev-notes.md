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

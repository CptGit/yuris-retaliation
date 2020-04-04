## Requirements

### Mind Control
Yuri's mind control ability.

SpecialPower_ActivateYurikoLureRank1, Yuriko campagin, EP1

SpecialPower_ManipulateObject, Mastermind, C&C3

### Hallucinatory Gas
Chaos Drone's ability, which causes enemies to behave violently, even against their own forces. 

Redeemer(MODMetaUnit), KW
> `EMOTION_DISSIDENT` is defected in nature

ParalyzeType
> Pause but not cancel the unit's original operation. Intended to use this to "patch"
`EMOTION_DISSIDENT` but no use.

LUA
> In progress


## Issues

The first line works but the commented line does not. I believe they are supposed to behave the
same.
```lua
function ExampleFunction(self)
    ExecuteAction("NAMED_USE_COMMANDBUTTON_ABILITY", self, "Command_ToggleTargetPainter")
    -- ObjectDoSpecialPower(self, "SpecialPower_ToggleTargetPainter")
end
```

idk why but OnDamaged seems not working for guardian tanks.

Show an empty text box when I call ExecuteAction("SHOW_MILITARY_CAPTION", "hello", 10)


## Docs

### LUA

`LuaEventNugget`: This nugget triggers the specified event at the
object that gets hit by the nugget ("radius" is effective, which means
triggering an event at all the objects within a range). If the
object registers an <EvenList> that handles the event, then it will
react.

`ScriptedEvent` is of two kinds. Parameter format is fixed: self, other and string.
See comments in `ScriptEvents.xml`.

### XML
`xai:joinAction="Replace/Append/Remove/Overwrite"`: to be different
from parent when inheriting.

### Misc
Mod name cannot exceed 15 characters, which is one of SDK's
limitations.

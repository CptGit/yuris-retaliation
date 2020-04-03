Mod name cannot exceed 15 characters.

### Mind Control
Yuri's mind control ability.

SpecialPower_ActivateYurikoLureRank1, Yuriko campagin, EP1

SpecialPower_ManipulateObject, Mastermind, C&C3

### Psychic Gas
Chaos Drone's ability, which causes enemies to behave violently, even against their own forces. 

Redeemer(MODMetaUnit), KW
> EMOTION_DISSIDENT is defected in nature

ParalyzeType
> pasue but not cancel the unit's original operation. No use.

LUA
> trying

### Issues

The first line works but the commented line does not. Either of them is supposed to work.
```lua
function ExampleFunction(self)
    ExecuteAction("NAMED_USE_COMMANDBUTTON_ABILITY", self, "Command_ToggleTargetPainter")
    -- ObjectDoSpecialPower(self, "SpecialPower_ToggleTargetPainter")
end
```

idk why but OnDamaged seems not working at all.

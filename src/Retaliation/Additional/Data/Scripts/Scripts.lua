--- define lua functions
function NoOp(self, source)
end


function kill(self) -- Kill unit self.
    ExecuteAction("NAMED_KILL", self);
end

function RadiateUncontrollableFear( self )
    ObjectBroadcastEventToEnemies( self, "BeUncontrollablyAfraid", 350 )
end

function RadiateGateDamageFear(self)
    ObjectBroadcastEventToAllies(self, "BeAfraidOfGateDamaged", 200)
end

function OnNeutralGarrisonableBuildingCreated(self)
    ObjectHideSubObjectPermanently( self, "ARMOR", true )
end

function OnGDITechCenterCreated(self)
    ObjectHideSubObjectPermanently( self, "UG_Boost", true )
    ObjectHideSubObjectPermanently( self, "UG_Mortar", true )
    ObjectHideSubObjectPermanently( self, "B_MortarRound_1", true )
    ObjectHideSubObjectPermanently( self, "UG_Rail", true )
    ObjectHideSubObjectPermanently( self, "UG_Scan", true )
end

function OnGDIMedicalBayCreated(self)
    ObjectHideSubObjectPermanently( self, "UG_Armor", true )
    ObjectHideSubObjectPermanently( self, "UG_StealthDetector", true )
    ObjectHideSubObjectPermanently( self, "UG_StealthDetector01", true )
    ObjectHideSubObjectPermanently( self, "UG_Injector", true )
end

function OnGDIPowerPlantCreated(self)
    ObjectHideSubObjectPermanently( self, "Turbines", true )
    ObjectHideSubObjectPermanently( self, "TurbineGlows", true )
end

function OnGDIZoneTrooperCreated(self)
    ObjectHideSubObjectPermanently( self, "UGSCANNER", true )
    ObjectHideSubObjectPermanently( self, "UGJUMP", true )
    ObjectHideSubObjectPermanently( self, "UGINJECTOR", true )
end

function OnGDIPredatorCreated(self)
    ObjectHideSubObjectPermanently( self, "UGRAIL_01", true )
end

function OnGDIMammothCreated(self)
    ObjectHideSubObjectPermanently( self, "UGRAIL_01", true )
    ObjectHideSubObjectPermanently( self, "UGRAIL_02", true )
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_02", true )
end

function OnGDIJuggernaughtCreated(self)
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_02", true )
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_03", true )

end

function OnGDIWatchTowerCreated(self)
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_02", true )
end

function OnGDIFirehawkCreated(self)
    -- bomb load by default.
    ObjectGrantUpgrade( self, "Upgrade_SelectLoad_02" )
    ObjectHideSubObjectPermanently( self, "Plane04", true )
end

function OnGDIPitbullCreated(self)
    ObjectHideSubObjectPermanently( self, "MortorTube", true )
end

function OnGDIOrcaCreated(self)
    ObjectHideSubObjectPermanently( self, "UG_PROBE", true )
end

function OnGDISniperSquadCreated(self)
    ObjectSetObjectStatus( self, "CAN_SPOT_FOR_BOMBARD" )
end

function OnGDIOrcaClipEmpty(self)
    ObjectHideSubObjectPermanently( self, "MISSILE01", true )
end

function OnGDIOrcaClipFull(self)
    ObjectHideSubObjectPermanently( self, "MISSILE01", false )
end

function OnGDIV35Ox_SummonedForVehicleCreated(self)
    ObjectHideSubObjectPermanently( self, "LOADREF", true )
end

function OnNODShredderCreated(self)

end

function OnNODRaiderTankCreated(self)
    ObjectHideSubObjectPermanently( self, "Gun_Upgrade", true )
    ObjectHideSubObjectPermanently( self, "Turret2_Gun", true )
    ObjectHideSubObjectPermanently( self, "Turret2", true )
    ObjectHideSubObjectPermanently( self, "MuzzleFlash_01", true )
    ObjectHideSubObjectPermanently( self, "DOZERBLADE", true )
end

function OnNODAvatarCreated(self)
    ObjectHideSubObjectPermanently( self, "NUBEAM", true )
    ObjectHideSubObjectPermanently( self, "FLAMETANK", true )
    ObjectHideSubObjectPermanently( self, "S_DETECTOR", true )
    ObjectHideSubObjectPermanently( self, "S_GENERATOR", true )
end

function OnNODAvatarGenericEvent(self, data)

    local str = tostring( data )

    if str == "upgrades_copied" then
        ObjectRemoveUpgrade( self, "Upgrade_Veterancy_VETERAN" );
        ObjectRemoveUpgrade( self, "Upgrade_Veterancy_ELITE" );
        ObjectRemoveUpgrade( self, "Upgrade_Veterancy_HEROIC" );
    end
end

function OnNODScorpionBuggyCreated(self)
    ObjectHideSubObjectPermanently( self, "EMP", true )
end

function OnNODVenomCreated(self)
    ObjectHideSubObjectPermanently( self, "SigGen", true )
end

function OnNODTechAssembleyPlantCreated(self)
    ObjectHideSubObjectPermanently( self, "UG_EMP", true )
    ObjectHideSubObjectPermanently( self, "UG_Lasers", true )
    ObjectHideSubObjectPermanently( self, "UG_SigGen", true )
    ObjectHideSubObjectPermanently( self, "UG_DozerBlades", true )
end

function OnNODSecretShrineCreated(self)
    ObjectHideSubObjectPermanently( self, "GLOWS", true )
    ObjectHideSubObjectPermanently( self, "ConfUpgrd", true )
end

function OnNODSecretShrinePowerOutage(self)
    if ObjectHasUpgrade( self, "Upgrade_NODConfessorUpgrade" ) == 1 then
        ObjectHideSubObjectPermanently( self, "GLOWS", true )
    end
end

function OnNODSecretShrinePowerRestored(self)
    if ObjectHasUpgrade( self, "Upgrade_NODConfessorUpgrade" ) == 1 then
        ObjectHideSubObjectPermanently( self, "GLOWS", false )
    end
end


function OnAlliedAntiVehicleInfantryGenericEvent(self, data)
    local str = tostring( data )

    if str == "laser_on" then
        ObjectHideSubObjectPermanently( self, "FX_LASER", false )
    elseif str == "laser_off" then
        ObjectHideSubObjectPermanently( self, "FX_LASER", true )
    end
end

function OnAlliedBarracksCreated(self)
    ObjectHideSubObjectPermanently( self, "Upgrade_02", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_03", true )
end

function OnAlliedConstructionYardCreated(self)
    ObjectHideSubObjectPermanently( self, "Upgrade_02", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_03", true )
end

function onCreatedControlPointFunctions(self)
    ObjectHideSubObjectPermanently( self, "TB_CP_ALN", true )
    ObjectHideSubObjectPermanently( self, "TB_CP_GDI", true )
    ObjectHideSubObjectPermanently( self, "TB_CP_NOD", true )
    ObjectHideSubObjectPermanently( self, "LIGHTSF01", true )
    ObjectHideSubObjectPermanently( self, "100", false)
    ObjectHideSubObjectPermanently( self, "75", false)
    ObjectHideSubObjectPermanently( self, "50", false)
    ObjectHideSubObjectPermanently( self, "25", false )
end

function onBuildingPowerOutage(self)
    ObjectHideSubObjectPermanently( self, "LIGHTS", true )
    ObjectHideSubObjectPermanently( self, "FXLIGHTS05", true )
    ObjectHideSubObjectPermanently( self, "FXLIGHTS", true )
    ObjectHideSubObjectPermanently( self, "FXGLOWS", true )
    ObjectHideSubObjectPermanently( self, "FLASHINGLIGHTS", true )
    ObjectHideSubObjectPermanently( self, "MESH01", true )
    ObjectHideSubObjectPermanently( self, "POWERPLANTGLOWS", true )
    ObjectHideSubObjectPermanently( self, "LIGHTL", true )
    ObjectHideSubObjectPermanently( self, "LIGHTR", true )
    ObjectHideSubObjectPermanently( self, "LIGHTS1", true )
    ObjectHideSubObjectPermanently( self, "NBCHEMICALPTE1", true )
    ObjectHideSubObjectPermanently( self, "LINKS", true )
    ObjectHideSubObjectPermanently( self, "MESH28", true )
    ObjectHideSubObjectPermanently( self, "TURBINEGLOWS", true )
    ObjectHideSubObjectPermanently( self, "GLOWS", true )
end

function onBuildingPowerRestored(self)
    ObjectHideSubObjectPermanently( self, "LIGHTS", false )
    ObjectHideSubObjectPermanently( self, "FXLIGHTS05", false )
    ObjectHideSubObjectPermanently( self, "FXLIGHTS", false )
    ObjectHideSubObjectPermanently( self, "FXGLOWS", false )
    ObjectHideSubObjectPermanently( self, "FLASHINGLIGHTS", false )
    ObjectHideSubObjectPermanently( self, "MESH01", false )
    ObjectHideSubObjectPermanently( self, "POWERPLANTGLOWS", false )
    ObjectHideSubObjectPermanently( self, "LIGHTL", false )
    ObjectHideSubObjectPermanently( self, "LIGHTR", false )
    ObjectHideSubObjectPermanently( self, "LIGHTS1", false )
    ObjectHideSubObjectPermanently( self, "NBCHEMICALPTE1", false )
    ObjectHideSubObjectPermanently( self, "LINKS", false )
    ObjectHideSubObjectPermanently( self, "MESH28", false )
    ObjectHideSubObjectPermanently( self, "TURBINEGLOWS", false )
    ObjectHideSubObjectPermanently( self, "GLOWS", false )
end







function OnGenericJapanBuildingCreated(self)
    ObjectHideSubObjectPermanently( self, "Upgrade_02", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_03", true )
end

function OnNeutralGarrisonableBuildingGenericEvent(self,data)
end

function onCreatedGDIOrcaAirstrike(self)
    ObjectForbidPlayerCommands( self, true )
end

function onCreatedAlienMCVUnpacking(self)
    ObjectForbidPlayerCommands( self, true )
end

function MakeMeAlert(self)
    ObjectEnterAlertState(self)
end

function BecomeUncontrollablyAfraid(self, other)
    if not ObjectTestCanSufferFear(self) then
        return
    end

    ObjectEnterUncontrollableCowerState(self, other)
end

function RadiateTerror(self, other)
    ObjectBroadcastEventToEnemies(self, "BeTerrified", 180)
end

function RadiateTerrorEx(self, other, terrorRange)
    ObjectBroadcastEventToEnemies(self, "BeTerrified", terrorRange)
end


function BecomeTerrified(self, other)
    ObjectEnterRunAwayPanicState(self, other)
end

function BecomeAfraidOfGateDamaged(self, other)
    if not ObjectTestCanSufferFear(self) then
        return
    end

    ObjectEnterCowerState(self,other)
end


function ChantForUnit(self) -- Used by units to broadcast the chant event to their own side.
    ObjectBroadcastEventToAllies(self, "BeginChanting", 9999)
end

function StopChantForUnit(self) -- Used by units to stop the chant event to their own side.
    ObjectBroadcastEventToAllies(self, "StopChanting", 9999)
end

function SpyMoving(self, other)
    print(ObjectDescription(self).." spying movement of "..ObjectDescription(other));
end

function OnGarrisonableCreated(self)
    ObjectHideSubObjectPermanently( self, "GARRISON01", true )
    ObjectHideSubObjectPermanently( self, "GARRISON02", true )
end

function OnRubbleDropshipCreated(self)
    ObjectHideSubObjectPermanently( self, "Loadref", true )
end

function OnSovietAntiVehicleVehicleTech1Created(self)
    ObjectHideSubObjectPermanently( self, "Upgrade_Athena_Cannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_AutoCannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Big_Cannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Cryo_Weapon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_FlakCannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_FlakMissile", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_GaussCannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Laser_Cannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_PrismCannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Small_Cannon", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_TeslaCoil", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_V4Rocket_A", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_V4Rocket_Missile", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Waveforce", true )
end

function OnAlliedInfantryFightingCreated(self)
    ObjectHideSubObjectPermanently( self, "NUBEAM", true )
    ObjectHideSubObjectPermanently( self, "FLAMETANK", true )
    ObjectHideSubObjectPermanently( self, "S_DETECTOR", true )
    ObjectHideSubObjectPermanently( self, "S_GENERATOR", true )
end


function OnAlliedBaseDefenseCreated(self)

    ObjectHideSubObjectPermanently( self, "Upgrade_Blaster_Rifles", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Engineer", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Flak", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_GoldenGun", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_MachineGun", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_MissileLauncher", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Natasha_Sniper", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Ninja_Star", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Ninja_Turret", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Plasma", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Psyonic", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Psyonic_Turret", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Shotgun", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Speakers", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Tanya_Pistols", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Tesla_Turret", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Tesla", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Turret", true )
    ObjectHideSubObjectPermanently( self, "Tanya", true )

end

function OnAlliedAntiAirVehicleTech1Created(self)

    ObjectHideSubObjectPermanently( self, "Upgrade_Blaster_Rifles", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Engineer", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Flak", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_GoldenGun", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_MachineGun", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_MissileLauncher", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Natasha_Sniper", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Ninja_Star", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Ninja_Turret", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Plasma", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Psyonic", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Psyonic_Turret", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Shotgun", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Speakers", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Tanya_Pistols", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Tesla_Turret", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Tesla", true )
    ObjectHideSubObjectPermanently( self, "Upgrade_Turret", true )
    ObjectHideSubObjectPermanently( self, "Tanya", true )

end

function OnAlliedInfantryFightingCreated(self)
    ObjectHideSubObjectPermanently( self, "NUBEAM", true )
    ObjectHideSubObjectPermanently( self, "FLAMETANK", true )
    ObjectHideSubObjectPermanently( self, "S_DETECTOR", true )
    ObjectHideSubObjectPermanently( self, "S_GENERATOR", true )
end

function OnJapanAntiStructureShipCreated(self)
    ObjectHideSubObjectPermanently( self, "Upgrade_01", true )
end

-- this function expects an eventType of 'onDisguiseAs' and checks for various assetIDs, hiding the appropriate subObjects
function OnJapanLightTransportVehicleGenericEvent(self, eventType, data)
    local eTpye = tostring( eventType )

    if not eType == "onDisguiseAs" then
        return
    end

    local str = tostring( data )

    -- this is the assetID of an AlliedAntiAirVehicleTech1
    if str == "3137747290" then
        ObjectHideSubObjectPermanently( self, "Upgrade_Blaster_Rifles", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Engineer", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Flak", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_GoldenGun", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_MachineGun", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_MissileLauncher", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Natasha_Sniper", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Ninja_Star", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Ninja_Turret", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Plasma", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Psyonic", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Psyonic_Turret", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Shotgun", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Speakers", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Tanya_Pistols", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Tesla_Turret", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Tesla", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Turret", true )
        ObjectHideSubObjectPermanently( self, "Tanya", true )
    -- this is the assetID of a SovietAntiVehicleVehicleTech1
    elseif str == "2494781707" then
        ObjectHideSubObjectPermanently( self, "Upgrade_Athena_Cannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_AutoCannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Big_Cannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Cryo_Weapon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_FlakCannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_FlakMissile", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_GaussCannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Laser_Cannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_PrismCannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Small_Cannon", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_TeslaCoil", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_V4Rocket_A", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_V4Rocket_Missile", true )
        ObjectHideSubObjectPermanently( self, "Upgrade_Waveforce", true )
    end
end

--------------------------------------------------------------------------------
------------------------------------ CUSTOM ------------------------------------
--------------------------------------------------------------------------------

-------------------------------- Global variables ------------------------------

GetObj = {}

STANCE_TYPE = {
    ["GUARD"]=0, ["AGGRESSIVE"]=1, ["HOLD_POSITION"]=2, ["HOLD_FIRE"]=3
}

----------------------------------- Configs ------------------------------------

LIVE_OUTPUT_FILE = "D:/Games/yuris-retaliation/scripts/LIVE_OUTPUT.txt"

---------------------------------- Utilities -----------------------------------

-- Print ingame
-- TODO: This is broken. Just show an empty text box without any text.
function PrintInGame(output, display_time)
    -- Set default display duration to 3s
    display_time = display_time or 3

    -- Print ingame
    ExecuteAction("SHOW_MILITARY_CAPTION",
            "\n\n\n\n" .. tostring(output) .. "\n",
            display_time)
 end

-- Print output to file with the given mode ('a' by default). Will create the
-- file if it does not exist.
function PrintToFile(output, mode, file)
    mode = mode or 'a'
    file = file or LIVE_OUTPUT_FILE
    output = tostring(output)

    local filehandle = openfile(file, mode)
    if filehandle ~= nil then
        write(filehandle, output)
    else
        local filehandle = writeto(file)
        write(filehandle, output)
    end
    flush(filehandle)
    closefile(filehandle)
end

function PrintlnToFile(output, mode, file)
    PrintToFile(output .. '\n', mode, file)
end

function PrintlnToFileWithTimeStamp(output, mode, file)
    PrintlnToFile(date() .. " " .. output, mode, file)
end

-- 单位命名并返回名称，功能来源于metamod并做了修改，名称固定为"object_123"，数字表示出现在地图的序号且唯一
-- 部分地图脚本需要名称才能使用
function GetObj.StrRefNew(object)
    local tmpdesc = ObjectDescription(object)
    local tmpstr = strsub(tmpdesc, strfind(tmpdesc,"t",1,true)+2,strfind(tmpdesc,"[",1,true)-2)
    local StrRef = "object_" .. tmpstr
    ExecuteAction("SET_UNIT_REFERENCE", StrRef, object)
    return StrRef
end

--------------------------- Ingame event functions -----------------------------

function ExposedToHallucinatoryGasFunction(self, other, str)
    local selfRef = GetObj.StrRefNew(self)
    if not EvaluateCondition("UNIT_HAS_MODELCONDITION", selfRef, "EMOTION_DISSIDENT") then
        ReactToHallucinatoryGas(selfRef)
    end

    -- TODO(minor): recover the original stance of this unit after the dissident emotion ends
    -- TODO(urgent): how to build an asymmetric enemy relation, which means the dissident unit can attack its friends but the friends cannot attack it.
    -- TODO(more urgent): how to make the dissident unit not attack the chaos drone? NON_AUTOACQUIRABLE?
end

function ReactToHallucinatoryGas(objRef)
    ExecuteAction("NAMED_STOP", objRef)
    ExecuteAction("UNIT_SET_STANCE", objRef, STANCE_TYPE["AGGRESSIVE"])
    ExecuteAction("UNIT_SET_MODELCONDITION_FOR_DURATION", objRef, "EMOTION_DISSIDENT", 20, 100)
end

-- ExecuteAction("NAMED_USE_COMMANDBUTTON_ABILITY", self, "Command_ToggleTargetPainter")
-- ObjectDoSpecialPower(self, "SpecialPower_ToggleTargetPainter") not working
-- ObjectSetObjectStatus(self, "DESTROYED")
-- kill(other)
-- PrintInGame("Killed") not working
----------------------------
-- ExecuteAction("UNIT_CHANGE_OBJECT_STATUS", self, "NON_AUTOACQUIRABLE", true)
-- ExecuteAction("UNIT_SET_MODELCONDITION_GENERIC", self, "EMOTION_DISSIDENT", 20)
-- ExecuteAction("UNIT_SET_MODELCONDITION_GENERIC", UNIT, MODEL_CONDITION, DURATION)

-- ExecuteAction("NAMED_SET_EMOTICON", UNIT, EMOTICON, REAL)
-- Unit_/ Set emoticon for duration (-1.0 permanent, otherwise duration in sec).
-- EMOTICON	= { ["EMOTION_UNCONTROLLABLY_AFRAID"]=0, ["EMOTION_TAUNTING"]=1, ["EMOTION_QUARRELSOME"]=2, ["EMOTION_POINTING"]=3, ["EMOTION_PANIC"]=4, ["EMOTION_MORALE_LOW"]=5, ["EMOTION_MORALE_HIGH"]=6, ["EMOTION_LOOK_TO_SKY"]=7, ["EMOTION_GUNG_HO"]=8, ["EMOTION_DOOM"]=9, ["EMOTION_DISSIDENT"]=10, ["EMOTION_COWER"]=11, ["EMOTION_CHEER_FOR_ABOUT_TO_CRUSH"]=12, ["EMOTION_CELEBRATING"]=13, ["EMOTION_BRACE_FOR_BEING_CRUSHED"]=14, ["EMOTION_AMUSED"]=15, ["EMOTION_ALERT"]=16, ["EMOTION_AFRAID"]=17 }

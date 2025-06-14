local UEHelpers = require("UEHelpers")
local Config = require("config")
-- local DiUtils = require("DiUtils")
-- local FindByName = DiUtils.FindByName

-- local printf = function (text, ...) DiUtils.Printf(DiUtils.ColorizeText(100, 230, 150, "SlickArchery"), text, ...) end
local printf = function (text, ...) if not text:match("\n$") then text = text .. "\n" end return print(("[SlickArchery] " .. text):format(...)) end

function FindByName(class, name)
    if name == nil then
        class, name = class:match("^(%w+) (.+)$")
    end

    if class == nil or name == nil then return CreateInvalidObject() end

    local objs = FindAllOf(class) or {}

    for i = 1, #objs, 1 do
        if objs[i]:GetFullName():match(name) then
            return objs[i]
        end
    end

    return CreateInvalidObject()
end

printf("Loading...")

RegisterHook("Function /Script/Altar.VPairedPawn:OnCombatHitTaken", function(Pawn, HitEvent)
    local Pawn = Pawn:get() ---@cast Pawn AVPairedPawn
    local HitEvent = HitEvent:get() ---@cast HitEvent FPairedOblivionHitEvent
    local damage = HitEvent.HealthDamage
    local maxDamage = nil -- If testing, you can replace this nil with the damage you're doing with a...
    --                                  fully charged arrow to get a better sense of the amount of damage dealth at different charge amounts.
    if maxDamage ~= nil then
        local ratio = damage > maxDamage and 1 or damage / maxDamage
        printf("HealthDamage: (%0.0f%%) %0.2f/%0.2f", ratio * 100, damage, maxDamage)
    else
        printf("HealthDamage: %0.2f", damage)
    end
end)

local function RevertAnimSequences(modifier)
    local revertedCount = 0
    local animSequences = FindAllOf("AnimSequence") or {} ---@cast animSequences TArray<UAnimSequence>
    if animSequences ~= nil and #animSequences > 0 then
        for i = 1, #animSequences do
            local animSequence = animSequences[i]
            local name = animSequence:GetFName():ToString()

            if Config.AnimSettings[name] ~= nil and Config.Enabled then
                animSequence.SequenceLength = animSequence.SequenceLength * modifier
                animSequence.RateScale = animSequence.RateScale / modifier
                revertedCount = revertedCount + 1
            end

            -- if DefaultAnimSequenceSettings[name] ~= nil then
            --     animSequence.SequenceLength = DefaultAnimSequenceSettings[name].SequenceLength
            --     animSequence.RateScale = DefaultAnimSequenceSettings[name].RateScale
            --     DefaultAnimSequenceSettings[name] = nil
            --     revertedCount = revertedCount + 1
            -- end
        end

        ModRef:SetSharedVariable("SlickArchery_LastAnimSequenceModifier", nil)
        -- ModRef:SetSharedVariable("SlickArchery_DefaultAnimSequenceSettings", DefaultAnimSequenceSettings)
    end

    printf("Reverted %s AnimSequences.", revertedCount)
end

LastAnimSequenceModifier = ModRef:GetSharedVariable("SlickArchery_LastAnimSequenceModifier")
-- DefaultAnimSequenceSettings = ModRef:GetSharedVariable("SlickArchery_DefaultAnimSequenceSettings") or {}

if LastAnimSequenceModifier ~= nil then
    RevertAnimSequences(LastAnimSequenceModifier)
    ModRef:SetSharedVariable("SlickArchery_LastAnimSequenceModifier", nil)
end

---@param animSequence UAnimSequence
local function UpdateAnimSequence(animSequence)
    local name = animSequence:GetFName():ToString()

    if Config.AnimSettings[name] ~= nil then
        local newSequenceLength = animSequence.SequenceLength / Config.SpeedProfile.AnimationSpeedModifier
        local newRateScale = animSequence.RateScale * Config.SpeedProfile.AnimationSpeedModifier
        printf("Adjusting animSequence %s. Length: %s -> %s, RateScale: %s -> %s", animSequence:GetFullName(), animSequence.SequenceLength, newSequenceLength, animSequence.RateScale, newRateScale)
        if Config.Enabled then
            animSequence.SequenceLength = newSequenceLength
            animSequence.RateScale = newRateScale
        end
    end
end

NotifyOnNewObject("/Script/Engine.AnimSequence", function (animSequence) ---@cast animSequence UAnimSequence
    if animSequence.SequenceLength > 0 then
        UpdateAnimSequence(animSequence)
        ModRef:SetSharedVariable("SlickArchery_LastAnimSequenceModifier", Config.SpeedProfile.AnimationSpeedModifier)
        -- ModRef:SetSharedVariable("SlickArchery_DefaultAnimSequenceSettings", DefaultAnimSequenceSettings)
    else
        ExecuteWithDelay(10, function ()
            UpdateAnimSequence(animSequence)
            ModRef:SetSharedVariable("SlickArchery_LastAnimSequenceModifier", Config.SpeedProfile.AnimationSpeedModifier)
            -- ModRef:SetSharedVariable("SlickArchery_DefaultAnimSequenceSettings", DefaultAnimSequenceSettings)
        end)
    end
end)

local animSequences = FindAllOf("AnimSequence") or {} ---@cast animSequences TArray<UAnimSequence>
if animSequences ~= nil and #animSequences > 0 then
    for i = 1, #animSequences do
        local animSequence = animSequences[i]
        if animSequence.SequenceLength > 0 then
            UpdateAnimSequence(animSequence)
            ModRef:SetSharedVariable("SlickArchery_LastAnimSequenceModifier", Config.SpeedProfile.AnimationSpeedModifier)
            -- ModRef:SetSharedVariable("SlickArchery_DefaultAnimSequenceSettings", DefaultAnimSequenceSettings)
        else
            ExecuteWithDelay(10, function ()
                UpdateAnimSequence(animSequence)
                ModRef:SetSharedVariable("SlickArchery_LastAnimSequenceModifier", Config.SpeedProfile.AnimationSpeedModifier)
                -- ModRef:SetSharedVariable("SlickArchery_DefaultAnimSequenceSettings", DefaultAnimSequenceSettings)
            end)
        end
    end

    -- ModRef:SetSharedVariable("SlickArchery_DefaultAnimSequenceSettings", DefaultAnimSequenceSettings)
end

-- printf("BowHoldPowerCurve: %s %s", bowHoldPowerCurve, bowHoldPowerCurve and bowHoldPowerCurve:IsValid())

local BowASTHooked = false
local StartedAimingLookup = {}

local function HookBowAST()
    if BowASTHooked then return end
    RegisterHook("Function /Game/Dev/StateMachine/AST_CharacterActionBowDrawShoot.AST_CharacterActionBowDrawShoot_C:Zoom", function(ast)
        ---@type UAST_CharacterActionBowDrawShoot_C
        local ast = ast:get()
        local name = ast.PairedPawn:get():GetFName():ToString()
        -- ast:PerformBowAttack()

        if Config.Enabled then
            -- ast.DrawDuration = 0.2
            if Config.AlwaysChargeUntilShot then
                ast.BowDrawInputHeldTime = ast.ThisStateTimer
            end

            -- if ast.ThisStateTimer > Config.SpeedProfile.MinimumDrawTime and StartedAimingLookup[name] and not ast.bReadyToShoot then
            local endTime = Config.SpeedProfile.MinimumDrawTime ~= nil and Config.SpeedProfile.MinimumDrawTime or (1.47 / Config.SpeedProfile.AnimationSpeedModifier)
            if ast.ThisStateTimer >= endTime and StartedAimingLookup[name] and not ast.bReadyToShoot then
            -- if ast.ThisStateTimer > Config.SpeedProfile.MinimumDrawTime and StartedAimingLookup[name] then
            -- if ast.BowDrawInputHeldTime > Config.SpeedProfile.MinimumDrawTime and StartedAimingLookup[name] then
                ast.bReadyToShoot = true
                printf("Making (%s) ready to shoot!", name)
                StartedAimingLookup[name] = false
                -- ast:PerformBowAttack()
            end
        end

        -- printf("Zoom (%s): %s BowDrawInputHeldTime:%0.2f BowDrawStartTime:%0.2f ThisStateTimer:%0.2f DrawDuration:%0.2f", name, (ast.bReadyToShoot and "Ready" or "Not Ready"), ast.BowDrawInputHeldTime, ast.BowDrawStartTime, ast.ThisStateTimer, ast.DrawDuration)
    end)

    RegisterHook("Function /Game/Dev/StateMachine/AST_CharacterActionBowDrawShoot.AST_CharacterActionBowDrawShoot_C:StartAiming", function(ast)
        ---@type UAST_CharacterActionBowDrawShoot_C
        local ast = ast:get()
        local name = ast.PairedPawn:get():GetFName():ToString()
        -- ast.DrawDuration = 0.2
        StartedAimingLookup[name] = true
        -- printf("Start Aiming: %s %s %0.2f", (ast.bReadyToShoot and "Ready" or "Not Ready"), ast.BowDrawInputHeldTime, ast.DrawDuration)
    end)

    RegisterHook("Function /Game/Dev/StateMachine/AST_CharacterActionBowDrawShoot.AST_CharacterActionBowDrawShoot_C:StopAiming", function(ast)
        ---@type UAST_CharacterActionBowDrawShoot_C
        local ast = ast:get()
        local name = ast.PairedPawn:get():GetFName():ToString()
        -- ast.DrawDuration = 0.2
        -- StartedAimingLookup[name] = true
        -- printf("Stop Aiming: %s %s %0.2f", (ast.bReadyToShoot and "Ready" or "Not Ready"), ast.BowDrawInputHeldTime, ast.DrawDuration)
    end)

    RegisterHook("Function /Game/Dev/StateMachine/AST_CharacterActionBowDrawShoot.AST_CharacterActionBowDrawShoot_C:PerformBowAttack", function(ast)
        local ast = ast:get() ---@type UAST_CharacterActionBowDrawShoot_C
        local name = ast.PairedPawn:get():GetFName():ToString()
        local heldTime = ast.BowDrawInputHeldTime
        local duration = ast.DrawDuration
        local ratio = heldTime >= duration and 1 or heldTime / duration
        printf("Fired: %0.0f%% (%0.2fs/%0.2fs)", ratio * 100, ast.BowDrawInputHeldTime, ast.DrawDuration)
    end)

    BowASTHooked = true
end

local bowDrawShootAST = FindByName("AST_CharacterActionBowDrawShoot_C", "BP_OblivionPlayerCharacter") or CreateInvalidObject()

if bowDrawShootAST:IsValid() then
    printf("Hooking Bow AST")
    HookBowAST()
else
    LoopAsync(1000, function ()
        if BowASTHooked then return true end
        printf("Checking for Bow AST...")

        local bowDrawShootAST = FindByName("AST_CharacterActionBowDrawShoot_C", "BP_OblivionPlayerCharacter") or CreateInvalidObject()

        if bowDrawShootAST:IsValid() then
            printf("Hooking Bow AST")
            HookBowAST()
        end

        return false
    end)
end

local VOblivionInitialSettings = StaticFindObject('/Script/UE5AltarPairing.Default__VOblivionInitialSettings') or CreateInvalidObject() ---@cast VOblivionInitialSettings UVOblivionInitialSettings
if VOblivionInitialSettings:IsValid() then
    printf("VOblivionInitialSettings.BowHoldCompletionPerSecond: %f -> %f", VOblivionInitialSettings.BowHoldCompletionPerSecond, Config.SpeedProfile.BowHoldCompletionPerSecond) --0.8
    printf("VOblivionInitialSettings.BowHoldMinimumCompletion: %f -> %f", VOblivionInitialSettings.BowHoldMinimumCompletion, Config.SpeedProfile.BowHoldMinimumCompletion) --0.2
    printf("VOblivionInitialSettings.ArrowInitialSpeedMultiplier: %f -> %f", VOblivionInitialSettings.ArrowInitialSpeedMultiplier, Config.ArrowInitialSpeedMultiplier) --5000
    printf("VOblivionInitialSettings.CombatDeathForceMultiplier: %f -> %f", VOblivionInitialSettings.CombatDeathForceMultiplier, Config.CombatDeathForceMultiplier) --5000
    printf("VOblivionInitialSettings.ArrowWeakSpeedMultiplier: %f -> %f", VOblivionInitialSettings.ArrowWeakSpeedMultiplier, Config.ArrowWeakSpeedMultiplier) --0.001

    if Config.Enabled then
        VOblivionInitialSettings.BowHoldCompletionPerSecond = Config.SpeedProfile.BowHoldCompletionPerSecond
        VOblivionInitialSettings.BowHoldMinimumCompletion = Config.SpeedProfile.BowHoldMinimumCompletion
        VOblivionInitialSettings.CombatDeathForceMultiplier = Config.CombatDeathForceMultiplier
        VOblivionInitialSettings.ArrowInitialSpeedMultiplier = Config.ArrowInitialSpeedMultiplier
        VOblivionInitialSettings.ArrowWeakSpeedMultiplier = Config.ArrowWeakSpeedMultiplier
    end
end

local BowHoldPowerCurve = FindByName("CurveFloat", "Curve_BowHoldPower") or CreateInvalidObject() ---@cast bowHoldPowerCurve UCurveFloat
if BowHoldPowerCurve:IsValid() then
    local originalFinalKeyTime = BowHoldPowerCurve.FloatCurve.Keys[#BowHoldPowerCurve.FloatCurve.Keys].Time
    local newFinalKeyTime = Config.SpeedProfile.BowHoldPowerCurveTime
    printf("Updated BowHoldPowerCurve from %0.2f -> %0.2f", originalFinalKeyTime, newFinalKeyTime)
    if Config.Enabled then
        BowHoldPowerCurve.FloatCurve.Keys[#BowHoldPowerCurve.FloatCurve.Keys].Time = newFinalKeyTime
    end
end

NotifyOnNewObject("CurveFloat", function (curve)
    if curve:GetFullName():match("Curve_BowHoldPower") then
        printf("Curve_BowHoldPower created!")
        local originalFinalKeyTime = BowHoldPowerCurve.FloatCurve.Keys[#BowHoldPowerCurve.FloatCurve.Keys].Time
        local newFinalKeyTime = Config.SpeedProfile.BowHoldPowerCurveTime
        printf("Updated BowHoldPowerCurve from %0.2f -> %0.2f", originalFinalKeyTime, newFinalKeyTime)
        if Config.Enabled then
            BowHoldPowerCurve.FloatCurve.Keys[#BowHoldPowerCurve.FloatCurve.Keys].Time = newFinalKeyTime
        end
    -- else
        -- printf("New CurveFloat created: %s", curve:GetFullName())
    end
end)

printf("Load complete!")
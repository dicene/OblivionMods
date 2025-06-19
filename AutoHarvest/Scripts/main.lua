local UEHelpers = require("UEHelpers")
local Config = require("config")

local printf = function (text, ...) if not text:match("\n$") then text = text .. "\n" end return print(("[AutoHarvest] " .. text):format(...)) end

local function FindByName(class, name)
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

local function ExecuteConsoleCommand(command)
    local playerController = UEHelpers.GetPlayerController() or CreateInvalidObject()
    local KismetSystemLibrary = StaticFindObject('/Script/Engine.Default__KismetSystemLibrary') or CreateInvalidObject() ---@type UKismetSystemLibrary

    if not playerController:IsValid() or not KismetSystemLibrary:IsValid() then return end

    KismetSystemLibrary:ExecuteConsoleCommand(playerController.player, command, playerController, true)
end

if Config.PrintDebugMessages then printf("Loading...") end

---@type UVFreezeInMenuSubsystem
local FreezeInMenuSubsystem = FindByName("VFreezeInMenuSubsystem", "Transient")

---@type UWBP_AltarHud_Fade_C
local AltarHudFade = FindByName("WBP_AltarHud_Fade_C", "Persistent")

NotifyOnNewObject("/Script/Altar.VFreezeInMenuSubsystem", function (subsystem)
    FreezeInMenuSubsystem = subsystem
end)

NotifyOnNewObject("/Script/Altar.VFadeWidget", function (fade)
    AltarHudFade = fade
end)

local function LoadingOrPaused()
    if not AltarHudFade:IsValid() then
        return true
    else
        if AltarHudFade:IsVisible() then
            return true
        end
    end

    if not FreezeInMenuSubsystem:IsValid() then
        return true
    else
        if FreezeInMenuSubsystem:IsFreezing() then
            return true
        end
    end

    return false
end

local commandList = {}

local function TickFunc(player)
    if LoadingOrPaused() then return end

    if commandList ~= nil and #commandList > 0 then
        for i, v in ipairs(commandList) do
            ExecuteConsoleCommand(v)
        end
    end

    commandList = {}
end

local function UpdateCommandList()
    commandList = {}

    if LoadingOrPaused() then return end

    local playerPawn = UEHelpers.GetPlayerController():IsValid() and UEHelpers.GetPlayerController():K2_GetPawn() or CreateInvalidObject
    if not playerPawn:IsValid() then return end

    local startTime

    if Config.UseSphereMethodToSearch then
        if Config.PrintDebugMessages then
            printf("Updating command list...")
            startTime = os.clock()
        end

        local playerLocation = playerPawn:K2_GetActorLocation()
        local floraClass = StaticFindObject("/Game/Dev/InteractibleObjects/BP_Flora_InteractibleObjects.BP_Flora_InteractibleObjects_C")
        local actorList = {}

        UEHelpers.GetKismetSystemLibrary():SphereOverlapActors(UEHelpers.GetWorldContextObject(), playerLocation, Config.Distance, { floraClass }, floraClass, { }, actorList)
        if Config.PrintDebugMessages then printf("NearbyActors: %s", #actorList) end

        for i = 1, #actorList do
            local flora = actorList[i]:get()
            if not flora:GetFName():ToString():match("Nirnroot") and flora:CanBePicked() then
                local form = flora.TESRefComponent.TESForm or CreateInvalidObject() ---@type UTESFlora
                if form:IsValid() and flora.TESRefComponent.FormIDInstance ~= 0 then
                    local formIDInstance = flora.TESRefComponent.FormIDInstance
                    if Config.PrintDebugMessages then printf("Attempting to harvest %s %s(0x%x)", flora:GetFName():ToString(), formIDInstance, formIDInstance) end

                    local command = string.format('"0x%x".Activate Player', formIDInstance)
                    table.insert(commandList, command)
                end
            end
        end

        if Config.PrintDebugMessages then printf("Time elapsed: %f", os.clock() - startTime) end
    else
        local startTime
        if Config.PrintDebugMessages then startTime = os.clock() end

        local floraList = FindAllOf("BP_Flora_InteractibleObjects_C") or {} ---@type TArray<ABP_Flora_InteractibleObjects_C>

        if floraList ~= nil and #floraList > 0 then
            if Config.PrintDebugMessages then printf("FloraList: %s", floraList ~= nil and #floraList or "0") end
            for i = 1, #floraList, 1 do
                local flora = floraList[i] ---@type ABP_Flora_InteractibleObjects_C
                if not flora:GetFName():ToString():match("Nirnroot") and flora:CanBePicked() then
                    local distance = flora:GetHorizontalDistanceTo(playerPawn)
                    if distance > 0 and distance < Config.Distance then
                        local form = flora.TESRefComponent.TESForm or CreateInvalidObject() ---@type UTESFlora
                        if form:IsValid() and flora.TESRefComponent.FormIDInstance ~= 0 then
                            local formIDInstance = flora.TESRefComponent.FormIDInstance
                            if Config.PrintDebugMessages then printf("Attempting to harvest %s %s(0x%x)", flora:GetFName():ToString(), formIDInstance, formIDInstance) end

                            local command = string.format('"0x%x".Activate Player', formIDInstance)
                            table.insert(commandList, command)
                        end
                    end
                end
            end
        end

        if Config.PrintDebugMessages then printf("Time elapsed: %f", os.clock() - startTime) end
    end
end

LoopAsync(Config.QueryFrequency, function () UpdateCommandList() return false end)

local pc = FindFirstOf("BP_OblivionPlayerCharacter_C") or CreateInvalidObject()
if pc:IsValid() then
    RegisterHook("Function /Game/Dev/PlayerBlueprints/BP_OblivionPlayerCharacter.BP_OblivionPlayerCharacter_C:ReceiveTick", function (player)
        TickFunc(player)
    end)
else
    NotifyOnNewObject("/Script/Altar.VOblivionPlayerCharacter", function()
        RegisterHook("Function /Game/Dev/PlayerBlueprints/BP_OblivionPlayerCharacter.BP_OblivionPlayerCharacter_C:ReceiveTick", function (player)
            TickFunc(player)
        end)
    end)
end

if Config.PrintDebugMessages then printf("Load complete.") end
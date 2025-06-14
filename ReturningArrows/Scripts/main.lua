local UEHelpers = require("UEHelpers")
local Config = require("config")

-- local printf = function (text, ...) DiUtils.Printf(DiUtils.ColorizeText(200, 180, 120, "ReturningArrows"), text, ...) end
local printf = function (text, ...) if not text:match("\n$") then text = text .. "\n" end return print(("[ReturningArrows] " .. text):format(...)) end

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
function ExecuteConsoleCommand(command)
    local playerController = UEHelpers.GetPlayerController() or CreateInvalidObject()
    local KismetSystemLibrary = StaticFindObject('/Script/Engine.Default__KismetSystemLibrary') or CreateInvalidObject()

    if not playerController:IsValid() or not KismetSystemLibrary:IsValid() then return end

    KismetSystemLibrary:ExecuteConsoleCommand(playerController.player, command, playerController, true)
end

printf("Loading...")

local ConsoleCommandQueue = {}

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

function LoadingOrPaused()
    if not AltarHudFade:IsValid() then
        return true
    else
        if AltarHudFade:IsVisible() then
            -- printf("AltarHudFade Is Visible!")
            return true
        end
    end

    if not FreezeInMenuSubsystem:IsValid() then
        return true
    else
        if FreezeInMenuSubsystem:IsFreezing() then
            -- printf("FreezeInMenuSubsystem Is Frozen!")
            return true
        end
    end

    -- printf("Attempting to harvest!")
    return false
end

function TickFunc(player)
    if LoadingOrPaused() then return end

    if ConsoleCommandQueue ~= nil and #ConsoleCommandQueue > 0 then
        for i, v in ipairs(ConsoleCommandQueue) do
            -- printf("About to run command: %s", v)
            ExecuteConsoleCommand(v)
        end
    end

    ConsoleCommandQueue = {}
end

-- LoopAsync(100, function () UpdateCommandList() end)

local PlayerTickHooked = false

local function HookPlayerTick()
    if PlayerTickHooked then return end

    local pc = FindFirstOf("BP_OblivionPlayerCharacter_C") or CreateInvalidObject()
    if pc:IsValid() then
        RegisterHook("Function /Game/Dev/PlayerBlueprints/BP_OblivionPlayerCharacter.BP_OblivionPlayerCharacter_C:ReceiveTick", function (player)
            TickFunc(player)
        end)

        PlayerTickHooked = true
    else
        NotifyOnNewObject("/Script/Altar.VOblivionPlayerCharacter", function()
            if PlayerTickHooked then return end

            RegisterHook("Function /Game/Dev/PlayerBlueprints/BP_OblivionPlayerCharacter.BP_OblivionPlayerCharacter_C:ReceiveTick", function (player)
                TickFunc(player)
            end)

        PlayerTickHooked = true
        end)
    end
end

HookPlayerTick()

if Config.InstantRetrieve then
    RegisterHook("Function /Script/Altar.VAmmunition:OnBounce", function(arrow, impactResult, impactVelocity)
        ---@type AVAmmunition
        local arrow = arrow:get()
        ---@type FHitResult
        local impactResult = impactResult:get()
        ---@type FVector
        local impactVelocity = impactVelocity:get()
        -- printf("arrow bounced: %s, %s, %s", arrow:GetFName():ToString(), impactResult, impactVelocity)
        -- printf("%s, %s", impactResult.bStartPenetrating, (impactResult.BoneName ~= nil and impactResult.BoneName:ToString() or "N/A"))
        local formIDInstance = arrow.TESRefComponent.FormIDInstance
        if formIDInstance ~= nil and impactResult.BoneName == nil or impactResult.BoneName:ToString():match("None") then
            local roll = math.random(1, 100) / 100
            printf("ArrowBreak roll %0.2f vs %0.2f", roll, Config.ArrowBreakChance)
            if roll <= Config.ArrowBreakChance then
                printf("Destroying arrow!")
                arrow:Despawn()
            else
                printf("Taking arrow instance: %s", formIDInstance)
                table.insert(ConsoleCommandQueue, string.format('obvConsole "0x%x".Activate Player', formIDInstance))
            end
            -- ExecuteConsoleCommand(string.format('obvConsole "0x%x".Activate Player', formIDInstance))
            -- printf("Finished taking arrow.")
        end
    end)
elseif Config.ArrowMagnetEnabled then
    LoopAsync(Config.MagnetFrequency, function()
        -- if true then return end
        ExecuteInGameThread(function ()
        local arrows = FindAllOf("VAmmunition")

        if arrows ~= nil then
            -- printf("Arrows: %s", #arrows)
            local player = UEHelpers:GetPlayerController().Pawn
            for i = 1, #arrows, 1 do
                ---@type AVAmmunition
                local arrow = arrows[i]
                if arrow ~= nil and arrow:IsValid() and not arrow.bActorIsBeingDestroyed and true then
                    -- printf("Getting distance at beginning of check for arrow %s", i)
                    local distance = arrow:GetDistanceTo(player)
                    -- arrow:GetDistanceTo(UEHelpers:GetPlayerController().Pawn)
                    -- printf("%s arrow: %s, %0.3f", i, arrow:GetFName():ToString(), distance)
                    if distance > 100000 then
                        -- printf("Destroying distant arrow %s", i)
                        -- arrow:K2_DestroyActor()
                        -- arrow:SetLifeSpan(0.5)
                        -- arrow:Despawn()
                    elseif distance < Config.MagnetAutoPickupRange and distance > 1 then
                        -- arrow:SetLifeSpan(0.5)
                        if arrow ~= nil and arrow:IsValid() and not arrow.bActorIsBeingDestroyed then
                            -- printf("Grabbing ids from arrow %s", i)
                            local itemID = arrow.TESRefComponent.TESForm.m_formID
                            local formIDInstance = arrow.TESRefComponent.FormIDInstance
                            -- printf("Grabbing close arrow %s %s", i, formIDInstance)

                            if formIDInstance ~= nil then
                                printf("Valid: Grabbing arrow: 0x%x", formIDInstance)
                                -- printf("        %s, %s", type(itemID), tostring(itemID))
                                -- printf("        %x(%s)", itemID, itemID)
                                -- ExecuteConsole(string.format("player.additem %x 1", formIDInstance))
                                table.insert(ConsoleCommandQueue, string.format('obvConsole "0x%x".Activate Player', formIDInstance))
                                printf("Arrow grabbed!")
                            else
                                printf("Invalid formIDInstance! 0x%x", formIDInstance)
                                -- printf("        %s", formIDInstance:GetFullName())
                            end
                        
                            -- arrow:K2_DestroyActor()
                            -- printf("Destroyed!")

                            -- ExecuteConsoleAlreadyInGameThread(string.format('obvConsole "0x%x".Activate Player', formIDInstance))
                        else
                            printf("Skipping grabbing arrow, no longer valid!")
                        end
                        
                        -- Execute
                        -- arrow:Despawn()
                    elseif distance > 0 then
                        -- printf("Calculating distances of arrow %s before applying velocity...", i)
                        local distanceX = player:K2_GetActorLocation().X - arrow:K2_GetActorLocation().X
                        local distanceY = player:K2_GetActorLocation().Y - arrow:K2_GetActorLocation().Y
                        local distanceZ = player:K2_GetActorLocation().Z - arrow:K2_GetActorLocation().Z - 50
                        local result = {}
                        local modifier = 5
                        -- local distanceX = arrow:K2_GetActorLocation().X - player:K2_GetActorLocation().X
                        -- local distanceY = arrow:K2_GetActorLocation().Y - player:K2_GetActorLocation().Y
                        -- local distanceZ = arrow:K2_GetActorLocation().Z - player:K2_GetActorLocation().Z
                        -- arrow.ProjectileMovementComponent:SetVelocityInLocalSpace({X=0,Y=0,Z=-1000})
                        -- printf("Arrow: Threshold %s, IsUnder %s", arrow.ProjectileMovementComponent.BounceVelocityStopSimulatingThreshold, arrow.ProjectileMovementComponent.IsVelocityUnderSimulationThreshold())
                        -- printf("Arrow: Velocity %s, %s, %s", arrow.ProjectileMovementComponent.Velocity.X, arrow.ProjectileMovementComponent.Velocity.Y, arrow.ProjectileMovementComponent.Velocity.Z)
                        -- arrow:K2_AddActorWorldOffset({X=0,Y=0,Z=100}, false, result, true)
                        -- arrow.ProjectileMovementComponent.bIsActive = true
                        -- arrow.ProjectileMovementComponent.bSimulationEnabled = true
                        -- arrow.ProjectileMovementComponent:ReceiveBeginPlay()
                            if arrow ~= nil and arrow:IsValid() and not arrow.bActorIsBeingDestroyed then
                                arrow:BeginPlay()
                                -- printf("ProjectileGravityScale: %s", arrow.ProjectileMovementComponent.ProjectileGravityScale)
                                -- arrow.ProjectileMovementComponent.ProjectileGravityScale = 0.1
                                -- printf("ProjectileGravityScale: %s", arrow.ProjectileMovementComponent.ProjectileGravityScale)
                                arrow.ProjectileMovementComponent.bRotationFollowsVelocity = true
                                arrow.ProjectileMovementComponent.bRotationRemainsVertical = false
                                -- arrow.PhysicsControllerComponent:SetActive(true, true)
                                -- printf("TransformPairingComponent.bIsActive: %s", arrow.TransformPairingComponent.bIsActive)
                                -- arrow:ShootAmunition(UEHelpers:GetPlayerController().Pawn, {X=0,Y=1,Z=1}, 200)
                                -- arrow.ProjectileMovementComponent.Velocity = {X=100,Y=100,Z=100}
                                -- arrow.PhysicsControllerComponent.PhysicsControlSettingsOverride.PhysicsSimulationBehaviour = 1
                                local currentVelocity = arrow:GetVelocity()
                                if distanceZ > -50 and currentVelocity.Z < 10 then
                                    printf("launching arrow up some")
                                    arrow.StaticMeshComponent:SetAllPhysicsLinearVelocity({X=distanceX * 2,Y=distanceY * 2,Z=currentVelocity.Z+1200}, false)
                                else
                                    arrow.StaticMeshComponent:SetAllPhysicsLinearVelocity({X=distanceX * 2,Y=distanceY * 2,Z=currentVelocity.Z}, false)
                                end
                                -- arrow.StaticMeshComponent:SetAllPhysicsLinearVelocity({X=distanceX * 2,Y=distanceY * 2,Z=distanceZ + 150}, true)
                                -- printf("Arrow %s's velocity updated!", i)
                            else
                                printf("Almost modified invalid arrow %s!", i)
                            end
                        -- printf("Arrow: Threshold %s, IsUnder %s", arrow.ProjectileMovementComponent.BounceVelocityStopSimulatingThreshold, arrow.ProjectileMovementComponent.IsVelocityUnderSimulationThreshold())
                        -- printf("Arrow: Velocity %s, %s, %s", arrow.ProjectileMovementComponent.Velocity.X, arrow.ProjectileMovementComponent.Velocity.Y, arrow.ProjectileMovementComponent.Velocity.Z)
                        -- arrow.ReplicatedMovement.LinearVelocity = {X=100,Y=100,Z=-100}
                        -- arrow.ReplicatedMovement.AngularVelocity = {X=0,Y=0,Z=-100}
                        -- printf("Arrow: LinearVelocity %s, %s, %s", arrow.ReplicatedMovement.LinearVelocity.X, arrow.ReplicatedMovement.LinearVelocity.Y, arrow.ReplicatedMovement.LinearVelocity.Z)
                        -- printf("Arrow: LinearVelocity %s, %s, %s", arrow.ReplicatedMovement.LinearVelocity.X, arrow.ReplicatedMovement.LinearVelocity.Y, arrow.ReplicatedMovement.LinearVelocity.Z)
                        -- printf("\n\n")
                        -- arrow.ReplicatedMovement.LinearVelocity.Z = -100
                        -- arrow.ProjectileMovementComponent:MoveInterpolationTarget(player.K2_GetActorLocation(), player.K2_GetActorRotation())
                        -- arrow.ProjectileMovementComponent.HomingTargetComponent:set(player.K2_GetRootComponent())
                        -- arrow.ProjectileMovementComponent.bIsHomingProjectile = true
                        -- arrow:K2_AddActorWorldOffset({X=(distanceX / modifier),Y=(distanceY / modifier),Z=(distanceZ / modifier)}, false, result, true)
                        -- arrow:ShootAmunition(UEHelpers:GetPlayerController().Pawn, {X=0,Y=0,Z=-1}, 10)
                        -- if arrow
                    end

                    -- printf("Finished handling arrow %s!", i)
                end
            end
        else
            -- printf("No arrows")
        end
        -- function ReadPlayerLocation()
        --UEHelpers:GetPlayerController().Pawn
    --     local FirstPlayerController = UEHelpers:GetPlayerController()
    --     local Pawn = FirstPlayerController.Pawn
    --     local test = FindFirstOf("AltarVWeapon")
    --     local Location = Pawn:K2_GetActorLocation()
    -- 	local Rotation = Pawn:K2_GetActorRotation()
    --     print(string.format("[MyLuaMod] Player location: {X=%.3f, Y=%.3f, Z=%.3f}\n", Location.X, Location.Y, Location.Z))
        end)
    end)
end

printf("Loaded.")
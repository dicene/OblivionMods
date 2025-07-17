local UEHelpers = require("UEHelpers")
local ConsoleUtils = {}

local PrintDebugInfo = false

local printf = function(s,...) if PrintDebugInfo then if not s:match("\n$") then s = "[ConsoleUtils] " .. s .. "\n" end return print(s:format(...)) end end

printf("Loading...")

local ConsoleInstance = CreateInvalidObject()
local LastConsoleCount = 0
local CommandQueue = {}
local ConsoleCommandCallbacks = {}

local function ExecuteConsoleCommand(command)
    local playerController = UEHelpers.GetPlayerController() or CreateInvalidObject() ---@cast playerController APlayerController
    local kismetSystemLibrary = StaticFindObject('/Script/Engine.Default__KismetSystemLibrary') ---@cast kismetSystemLibrary UKismetSystemLibrary

    if not playerController:IsValid() or kismetSystemLibrary == nil then return end

    printf("Executing command (%s)", command)
    local success, error = pcall(function ()
        -- kismetSystemLibrary:ExecuteConsoleCommand(playerController.player, command, playerController)
        kismetSystemLibrary:ExecuteConsoleCommand(playerController.player, command, playerController, false)
    end)

    if not success then
        -- kismetSystemLibrary:ExecuteConsoleCommand(playerController.player, command, playerController, false)
        kismetSystemLibrary:ExecuteConsoleCommand(playerController.player, command, playerController)
    end
end

PropertyTypes.ArrayProperty.Size = 0x10

RegisterCustomProperty({
    ["Name"] = "OutputBuffer",
    ["Type"] = PropertyTypes.ArrayProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x50,
    ["ArrayProperty"] = {
        ["Type"] = PropertyTypes.StrProperty
    }
})

RegisterCustomProperty({
    ["Name"] = "OutputBufferSize",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x58
})

RegisterCustomProperty({
    ["Name"] = "OutputBufferCurrentMaxSize",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x5C
})

RegisterCustomProperty({
    ["Name"] = "OutputBufferBottomElement",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x60
})

RegisterCustomProperty({
    ["Name"] = "ConsoleOpenMode",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0xD8
})

local function OnConsoleBlockCompleted(command, result)
    printf("OnConsoleBlockCompleted: Command: (%s), Result: (%s)", command, result)
    if command:match("ID:%d+") then
        local id = command:match("ID:(%d+)")

        if ConsoleCommandCallbacks[id] then
            ConsoleCommandCallbacks[id](result)
            ConsoleCommandCallbacks[id] = nil
        else
            printf("No callback for %s", id)
        end
    end
end

RegisterConsoleCommandHandler("LogToConsole", function (command, parameters, outputDevice)
    local text = command:match("LogToConsole (.+)")
    if text then
        printf("LogToConsole: %s", text)
        outputDevice:Log(text)
    end
    return true
end)

local function UpdateConsoleEntries()
    if not ConsoleInstance:IsValid() then
        ConsoleInstance = FindFirstOf("Console") or CreateInvalidObject()
        printf("Found instance of Console. 0x%x", ConsoleInstance:GetAddress())
    end

    if not ConsoleInstance:IsValid() then return end

    local newConsoleCount = ConsoleInstance.OutputBufferSize

    if LastConsoleCount > 0 and newConsoleCount > LastConsoleCount then
        local newConsoleEntries = {}
        printf("New console entries: %s", newConsoleCount - LastConsoleCount)

        for i = LastConsoleCount, newConsoleCount - 1 do
            local text = ConsoleInstance.OutputBuffer[i+1]:ToString()

            if string.len(text) > 0 then
                table.insert(newConsoleEntries, text)
            end
            -- printf("Console entry %s: (%s)", i, ConsoleInstance.OutputBuffer[i+1]:ToString())
        end

        local currentBlock = nil
        local blockContents = {}
        local gagLines = false

        for i = 1, #newConsoleEntries do
            local text = newConsoleEntries[i]
            -- printf("Line %s: %s", i, text)

            if currentBlock == nil and text:match("GameSetting Start {.+} >> NOT FOUND") then
                currentBlock = text:match("GameSetting Start {.+} >> NOT FOUND")
            elseif currentBlock ~= nil then
                if text:match("GameSetting End >> NOT FOUND") then
                    OnConsoleBlockCompleted(currentBlock, blockContents)
                    -- OnConsoleBlockCompleted(currentBlock, table.concat(blockContents, ", "))
                    gagLines = true
                    blockContents = {}
                    currentBlock = nil
                else
                    table.insert(blockContents, text)
                end
            end
        end

        if gagLines then
            printf("Size: %s, BottomElement: %s", ConsoleInstance.OutputBufferSize, ConsoleInstance.OutputBufferBottomElement)
            ConsoleInstance.OutputBufferSize = ConsoleInstance.OutputBufferSize - #newConsoleEntries
            ConsoleInstance.OutputBufferBottomElement = ConsoleInstance.OutputBufferBottomElement - #newConsoleEntries
            printf("Size: %s, BottomElement: %s", ConsoleInstance.OutputBufferSize, ConsoleInstance.OutputBufferBottomElement)
        end
    end

    LastConsoleCount = ConsoleInstance.OutputBufferSize
end

local function TickFunc(player)
    if #CommandQueue > 0 then
        for i, command in ipairs(CommandQueue) do
            LastCommand = command
            printf("Executing command (%s)", command)
            ExecuteConsoleCommand(command)
        end

        CommandQueue = {}

        -- Alternate method of processing one command per tick
        -- local commandRan = false
        -- for i, command in ipairs(CommandQueue) do
        --     if not commandRan then
        --         LastCommand = command
        --         ExecuteConsoleCommand(command)
        --         commandRan = true
        --     end
        -- end
        -- table.remove(CommandQueue, 1)
    end

    UpdateConsoleEntries()
end

function ConsoleUtils.IsConsoleOpen()
    if not ConsoleInstance:IsValid() then
        ConsoleInstance = FindFirstOf("Console") or CreateInvalidObject()
        printf("Found instance of Console. 0x%x", ConsoleInstance:GetAddress())
    end

    if not ConsoleInstance:IsValid() then return false end

    return ConsoleInstance.ConsoleOpenMode > 0
end

function ConsoleUtils.IsFullConsoleOpen()
    if not ConsoleInstance:IsValid() then
        ConsoleInstance = FindFirstOf("Console") or CreateInvalidObject()
        printf("Found instance of Console. 0x%x", ConsoleInstance:GetAddress())
    end

    if not ConsoleInstance:IsValid() then return false end

    return ConsoleInstance.ConsoleOpenMode == 0x8B2E
end

function ConsoleUtils.IsMiniConsoleOpen()
    if not ConsoleInstance:IsValid() then
        ConsoleInstance = FindFirstOf("Console") or CreateInvalidObject()
        printf("Found instance of Console. 0x%x", ConsoleInstance:GetAddress())
    end

    if not ConsoleInstance:IsValid() then return false end

    return ConsoleInstance.ConsoleOpenMode == 0x8B2A
end

function ConsoleUtils.OpenFullConsole()
    if not ConsoleInstance:IsValid() then
        ConsoleInstance = FindFirstOf("Console") or CreateInvalidObject()
        printf("Found instance of Console. 0x%x", ConsoleInstance:GetAddress())
    end

    if not ConsoleInstance:IsValid() then return end

    ConsoleInstance.ConsoleOpenMode = 0x8B2E
end

function ConsoleUtils.OpenMiniConsole()
    if not ConsoleInstance:IsValid() then
        ConsoleInstance = FindFirstOf("Console") or CreateInvalidObject()
        printf("Found instance of Console. 0x%x", ConsoleInstance:GetAddress())
    end

    if not ConsoleInstance:IsValid() then return end

    ConsoleInstance.ConsoleOpenMode = 0x8B2A
end

function ConsoleUtils.ExecuteConsoleCommand(command)
    table.insert(CommandQueue, command)
end

function ConsoleUtils.ExecuteConsoleCommandWithCallback(command, callback)
    local randomID = math.random(999999999)
    table.insert(CommandQueue, string.format('GetGS "Start {ID:%s}"', randomID))
    table.insert(CommandQueue, command)
    table.insert(CommandQueue, 'GetGS "End"')
    printf("Setting up callback for %s", randomID)
    ConsoleCommandCallbacks[tostring(randomID)] = callback
end

function ConsoleUtils.LogToConsole(text)
    ConsoleUtils.ExecuteConsoleCommand("LogToConsole " .. text)
end

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

printf("Load complete!")

return ConsoleUtils

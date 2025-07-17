local UEHelpers = require("UEHelpers")
local ConsoleUtils = require("ConsoleUtils")
local AIPackageList = {
    [0] = "EXPLORE (or Find)",
    [1] = "FOLLOW",
    [2] = "ESCORT",
    [3] = "EAT",
    [4] = "SLEEP",
    [5] = "COMBAT",
    [6] = "DIALOGUE",
    [7] = "ACTIVATE",
    [8] = "ALARM",
    [9] = "SPECTATOR",
    [10] = "FLEE",
    [11] = "TRESPASS",
    [12] = "GREET",
    [13] = "WANDER",
    [14] = "TRAVEL",
    [15] = "ACCOMPANY",
    [16] = "USEITEMAT",
    [17] = "AMBUSH",
    [18] = "FLEE_NON_COMBAT",
    [19] = "CAST_MAGIC",
    [20] = "COMBAT_LOW",
    [21] = "GET_UP",
    [22] = "MOUNT_HORSE",
    [23] = "DISMOUNT_HORSE",
    [24] = "DO_NOTHING",
    [25] = "CAST_TARGET_SPELL",
    [26] = "CAST_TOUCH_SPELL",
    [27] = "VAMPIRE_FEED",
    [28] = "SURFACE",
    [29] = "SEARCH_FOR_ATTACKER",
    [30] = "CLEAR_MOUNT_POSITION",
    [31] = "SUMMON_CREATURE_DEFEND",
    [32] = "MOVEMENT_BLOCKED",
}
local AIProcedureList = {
    [0] = "TRAVEL",
    [1] = "ACTIVATE",
    [2] = "AQUIRE",
    [3] = "WAIT",
    [4] = "DIALOGUE",
    [5] = "GREET",
    [6] = "GREET_DEAD",
    [7] = "WANDER",
    [8] = "SLEEP",
    [9] = "OBSERVE_COMBAT",
    [10] = "EAT",
    [11] = "FOLLOW",
    [12] = "ESCORT",
    [13] = "COMBAT",
    [14] = "ALARM",
    [15] = "PURSUE",
    [16] = "FLEE",
    [17] = "DONE",
    [18] = "YIELD",
    [19] = "TRAVEL_TARGET",
    [20] = "CREATE_FOLLOW",
    [21] = "GET_UP",
    [22] = "MOUNT_HORSE",
    [23] = "DISMOUNT_HORSE",
    [24] = "DO_NOTHING",
    [25] = "CAST_SPELL",
    [26] = "AIM",
    [27] = "ACCOMPANY",
    [28] = "USE_ITEM_AT",
    [29] = "VAMPIRE_FEED",
    [30] = "WAIT_AMBUSH",
    [31] = "SURFACE",
    [32] = "WAIT_FOR_SPELL",
    [33] = "CHOOSE_CAST",
    [34] = "FLEE_NON_COMBAT",
    [35] = "REMOVE_WORN_ITEMS",
    [36] = "SEARCH",
    [37] = "CLEAR_MOUNT_POSITION",
    [38] = "SUMMON_DEFEND",
    [39] = "MOVEMENT_BLOCKED_WAIT",
}

local printf = function(s,...) s = "[ConsoleUtilsMain] " .. s if not s:match("\n$") then s = s .. "\n" end return print(s:format(...)) end

printf("Loading...")

-- RegisterKeyBind(Key.R, function()
--     printf("Running stuff")
--     -- ConsoleUtils.ExecuteConsoleCommand("Player.PushActorAway Player 0")
--     local pairedPawns = FindAllOf("BP_Generic_NPC_C") or {} ---@type TArray<ABP_Generic_NPC_C>
--     local pawnIDList = {}
--     for i, pawn in ipairs(pairedPawns) do
--         if pawn:IsValid() and pawn:GetFullName():match("Persistent") then
--             if pawn.TESRefComponent:IsValid() then
--                 table.insert(pawnIDList, pawn.TESRefComponent.FormIDInstance)
--             end
--         end
--     end
--     for i, pawn in ipairs(pairedPawns) do
--         if pawn:IsValid() and pawn:GetFullName():match("Persistent") then
--             if pawn.TESRefComponent:IsValid() then
--                 local pawnID = pawn.TESRefComponent.FormIDInstance
--                 local pawnName = pawn.ActorValuesPairingComponent.ObjectRefComponent.TESForm.FullName:ToString() or "UnknownName"
--                 local spellID = 694250
--                 local target = string.format("%x", pawnIDList[math.random(#pawnIDList)])
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddSpell %x', pawnID, spellID))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".MoveTo Player', pawnID))
--                 ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".RemoveScriptPackage', pawnID))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage 6bdbc', pawnID)) --Follow player
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage 2d0c8', pawnID)) --Attack Player
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage a3499', pawnID)) --Bandit Attack Player
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage 29fef', pawnID)) --Bandit Attack Player
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage 983cc', pawnID)) --Beg IC
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage 262df', pawnID)) --Ambush Player
--                 ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage a1fd', pawnID)) --Eat
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage 71092', pawnID))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".AddScriptPackage aed42', pawnID)) --Fan Greet
                
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".Say GREETING', pawnID))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".Say GREETING', pawnID))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".PlayGroup Equip 1', pawnID))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".SetAv Magicka 10000', pawnID))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format('"%x".Cast %x %s', pawnID, spellID, target))
--                 -- ConsoleUtils.ExecuteConsoleCommand(string.format("Player.PushActorAway %x -100", pawnID))
--             end
--         end
--     end
-- end)

-- RegisterKeyBind(Key.K, {ModifierKey.CONTROL}, function()
--     local pairedPawns = FindAllOf("BP_Generic_NPC_C") or {} ---@type TArray<ABP_Generic_NPC_C>
--     for i, pawn in ipairs(pairedPawns) do
--         if pawn:IsValid() and pawn:GetFullName():match("Persistent") then
--             if pawn.TESRefComponent:IsValid() then
--                 local pawnID = pawn.TESRefComponent.FormIDInstance
--                 local pawnName = pawn.ActorValuesPairingComponent.ObjectRefComponent.TESForm.FullName:ToString() or "UnknownName"
--                 -- print(string.format("Checking pawn: %s (0x%x)\n", pawnName, pawnID))

--                 ConsoleUtils.ExecuteConsoleCommandWithCallback(string.format('"%x".IsInCombat', pawnID), function (results)
--                     if results[1]:match("is not in combat") then
--                         printf("%s IS NOT in combat.\n", pawnName)
--                     else
--                         printf("%s IS in combat.", pawnName)
--                     end
--                 end)

--                 ConsoleUtils.ExecuteConsoleCommandWithCallback(string.format('"%x".GetBarterGold', pawnID), function (results)
--                     local barterGold = results[1]:match("has (%d+) barter gold currently")
--                     printf("%s has %s barter gold.", pawnName, barterGold)
--                 end)

--                 ConsoleUtils.ExecuteConsoleCommandWithCallback(string.format('"%x".GetCurrentAIPackage', pawnID), function (results)
--                     local package = tonumber(results[1]:match("Current Process >> ([0-9]+)%.[0-9]+"))
--                     if package ~= nil then
--                         printf("%s current AI package: %s", pawnName, AIPackageList[package])
--                     else
--                         printf("Failed to get AI package for %s", pawnName)
--                     end
--                 end)

--                 ConsoleUtils.ExecuteConsoleCommandWithCallback(string.format('"%x".GetCurrentAIProcedure', pawnID), function (results)
--                     local procedure = tonumber(results[1]:match("Procedure >> ([0-9]+)%.[0-9]+"))
--                     if procedure ~= nil then
--                         printf("%s current AI procedure: %s", pawnName, AIProcedureList[procedure])
--                     else
--                         printf("Failed to get AI procedure for %s", pawnName)
--                     end
--                 end)
--             end
--         end
--     end
-- end)

-- RegisterKeyBind(Key.L, {ModifierKey.CONTROL}, function()
--     printf("Attempting to log directly to console...")
--     -- ConsoleUtils.ExecuteConsoleCommand("LogToConsole Logging this text directly to the console.")
--     ConsoleUtils.LogToConsole("Logging this text directly to the console.")
-- end)

-- RegisterKeyBind(Key.J, function()
--     printf("Console is %s", (ConsoleUtils.IsConsoleOpen() and "Open" or "Closed"))
--     printf("FullConsole is %s", (ConsoleUtils.IsFullConsoleOpen() and "Open" or "Closed"))
--     printf("MiniConsole is %s", (ConsoleUtils.IsMiniConsoleOpen() and "Open" or "Closed"))
-- end)

-- RegisterKeyBind(Key.K, function()
--     ConsoleUtils.OpenFullConsole()
-- end)

-- RegisterKeyBind(Key.L, function()
--     ConsoleUtils.OpenMiniConsole()
-- end)

printf("Load complete!")

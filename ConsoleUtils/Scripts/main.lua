local UEHelpers = require("UEHelpers")
local ConsoleUtils = require("ConsoleUtils")

local printf = function(s,...) if not s:match("\n$") then s = "[ConsoleUtils] " .. s .. "\n" end return print(s:format(...)) end

printf("Loading...")

RegisterKeyBind(Key.K, {ModifierKey.CONTROL}, function()
    local pairedPawns = FindAllOf("BP_Generic_NPC_C") or {} ---@type TArray<ABP_Generic_NPC_C>
    for i, pawn in ipairs(pairedPawns) do
        if pawn:IsValid() and pawn:GetFullName():match("Persistent") then
            if pawn.TESRefComponent:IsValid() then
                local pawnID = pawn.TESRefComponent.FormIDInstance
                local pawnName = pawn.ActorValuesPairingComponent.ObjectRefComponent.TESForm.FullName:ToString() or "UnknownName"

                ConsoleUtils.ExecuteConsoleCommandWithCallback(string.format('"%x".IsInCombat', pawnID), function (results)
                    if results[1]:match("is not in combat") then
                        print(string.format("%s IS NOT in combat.\n", pawnName))
                    else
                        print(string.format("%s IS in combat.\n", pawnName))
                    end
                end)

                ConsoleUtils.ExecuteConsoleCommandWithCallback(string.format('"%x".GetBarterGold', pawnID), function (results)
                    local barterGold = results[1]:match("has (%d+) barter gold currently")
                    print(string.format("%s has %s barter gold.\n", pawnName, barterGold))
                end)
            end
        end
    end
end)

RegisterKeyBind(Key.L, {ModifierKey.CONTROL}, function()
    printf("Attempting to log directly to console...")
    -- ConsoleUtils.ExecuteConsoleCommand("LogToConsole Logging this text directly to the console.")
    ConsoleUtils.LogToConsole("Logging this text directly to the console.")
end)

printf("Load complete!")

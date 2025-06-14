local Config = {
    ArrowMagnetEnabled = false, --Flings your arrows back at you and automatically grab them when they get close enough to you
    MagnetFrequency = 1000, --Frequency of arrow pulls in ms
    MagnetAutoPickupRange = 160, --Max distance in which arrows near you will get grabbed while ArrowMagnet is enabled
    InstantRetrieve = true, --Instantly pick up arrows when they hit a surface that is not a body part of a creature/npc/player
    ArrowBreakChance = 0.25, --Determines how likely your arrow is to break instead of returning to your inventory (for use InstantRetrieve). 0 to 1 = 0% to 100%
}

return Config
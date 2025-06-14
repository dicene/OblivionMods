local NormalProfile = {
    AnimationSpeedModifier = 1,             -- Amount to increase animation speed and reduce animation length
    MinimumDrawTime = 1.47,                 -- Default: 1.47
    BowHoldCompletionPerSecond = 0.8,       -- Default: The speed at which shot power is increased
    BowHoldMinimumCompletion = 0.2,         -- Default: 0.2, Sets the minimum power of a shot
    BowHoldPowerCurveTime = 1,              -- Default: 1.0
}

local SomewhatFastProfile = {
    AnimationSpeedModifier = 1.18,          -- Amount to increase animation speed and reduce animation length
    MinimumDrawTime = 1.20,                 -- 0.98     1       Default: 1.47
    -- MinimumDrawTime = 1.24,                 -- 0.98     1       Default: 1.47
    BowHoldCompletionPerSecond = 0.57,     -- 0.53     0.35    Default: 0.8    The speed at which shot power is increased
    -- BowHoldCompletionPerSecond = 0.831,     -- 0.53     0.35    Default: 0.8    The speed at which shot power is increased
    BowHoldMinimumCompletion = 0.31,       -- 0.13     0.0     Default: 0.2    Sets the minimum power of a shot
    -- BowHoldMinimumCompletion = 0.169,       -- 0.13     0.0     Default: 0.2    Sets the minimum power of a shot
    BowHoldPowerCurveTime = 1,              -- 0.66     0.5     Default: 1.0
    -- BowHoldPowerCurveTime = 0.847,          -- 0.66     0.5     Default: 1.0
}

local FastProfile = {
    AnimationSpeedModifier = 1.25,           -- Amount to increase animation speed and reduce animation length
    MinimumDrawTime = 0.90,                 -- 0.98     1       Default: 1.47
    -- MinimumDrawTime = 1.13,                 -- 0.98     1       Default: 1.47
    BowHoldCompletionPerSecond = 0.56,     -- 0.53     0.35    Default: 0.8    The speed at which shot power is increased
    -- BowHoldCompletionPerSecond = 0.56,     -- 0.53     0.35    Default: 0.8    The speed at which shot power is increased
    -- BowHoldCompletionPerSecond = 0.847,     -- 0.53     0.35    Default: 0.8    The speed at which shot power is increased
    BowHoldMinimumCompletion = 0.27,       -- 0.13     0.0     Default: 0.2    Sets the minimum power of a shot
    -- BowHoldMinimumCompletion = 0.153,       -- 0.13     0.0     Default: 0.2    Sets the minimum power of a shot
    BowHoldPowerCurveTime = 1,              -- 0.66     0.5     Default: 1.0
    -- BowHoldPowerCurveTime = 0.769,          -- 0.66     0.5     Default: 1.0
}

local FasterProfile = {
    AnimationSpeedModifier = 1.5,           -- Amount to increase animation speed and reduce animation length
    MinimumDrawTime = 0.64,                 -- 0.98     1       Default: 1.47
    -- MinimumDrawTime = 0.98,                 -- 0.98     1       Default: 1.47
    BowHoldCompletionPerSecond = 0.53,      -- 0.53     0.35    Default: 0.8    The speed at which shot power is increased
    -- BowHoldCompletionPerSecond = 0.87,      -- 0.53     0.35    Default: 0.8    The speed at which shot power is increased
    BowHoldMinimumCompletion = 0.41,        -- 0.13     0.0     Default: 0.2    Sets the minimum power of a shot
    -- BowHoldMinimumCompletion = 0.13,        -- 0.13     0.0     Default: 0.2    Sets the minimum power of a shot
    BowHoldPowerCurveTime = 1,              -- 0.66     0.5     Default: 1.0
    -- BowHoldPowerCurveTime = 0.66,           -- 0.66     0.5     Default: 1.0
}

local EvenFasterProfile = {
    AnimationSpeedModifier = 2,             -- Amount to increase animation speed and reduce animation length
    MinimumDrawTime = 0.52,                -- 0.735    Default: 1.47
    BowHoldCompletionPerSecond = 0.52,       -- 0.4      Default: The speed at which shot power is increased
    -- BowHoldCompletionPerSecond = 0.9,       -- 0.4      Default: The speed at which shot power is increased
    BowHoldMinimumCompletion = 0.49,         -- 0.1      Default: 0.2, Sets the minimum power of a shot
    -- BowHoldMinimumCompletion = 0.1,         -- 0.1      Default: 0.2, Sets the minimum power of a shot
    BowHoldPowerCurveTime = 1,              -- 0.5      Default: 1.0
    -- BowHoldPowerCurveTime = 0.5,            -- 0.5      Default: 1.0
}

local FastestProfile = {
    AnimationSpeedModifier = 2.5,           -- Amount to increase animation speed and reduce animation length
    MinimumDrawTime = 0.36,                -- 0.588    Default: 1.47
    BowHoldCompletionPerSecond = 0.6,      -- 0.32     Default: The speed at which shot power is increased
    -- BowHoldCompletionPerSecond = 0.92,      -- 0.32     Default: The speed at which shot power is increased
    BowHoldMinimumCompletion = 0.55,        -- 0.08     Default: 0.2, Sets the minimum power of a shot
    -- BowHoldMinimumCompletion = 0.08,        -- 0.08     Default: 0.2, Sets the minimum power of a shot
    BowHoldPowerCurveTime = 1,              -- 0.4      Default: 1.0
    -- BowHoldPowerCurveTime = 0.4,            -- 0.4      Default: 1.0
}

local Config = {
    Enabled = true,

    -- SpeedProfile = NormalProfile,
    -- SpeedProfile = SomewhatFastProfile,
    -- SpeedProfile = FastProfile,
    SpeedProfile = FasterProfile,
    -- SpeedProfile = EvenFasterProfile,
    -- SpeedProfile = FastestProfile,
    CombatDeathForceMultiplier = 2000,      -- Default: 400
    ArrowInitialSpeedMultiplier = 10000,    -- Default: 5000
    ArrowWeakSpeedMultiplier = 0.05,        -- Default: 0.001
    AlwaysChargeUntilShot = true,          -- Causes draw power to increase the entire time you're in the draw animation, regardless of if you released the shoot key

    AnimSettings = {
        ["A_Humanoid_Bow_Attack_Start"] = true,-- ["A_Humanoid_Bow_Attack_Start"] = {["SequenceLength"] = 0.977778, ["RateScale"] = 1.5 * 2,},
        ["A_Humanoid_Bow_Attack_Start_FP"] = true,-- ["A_Humanoid_Bow_Attack_Start_FP"] = {["SequenceLength"] = 0.911111333333333 / 3, ["RateScale"] = 1.5 * 2,},
        ["A_Humanoid_Bow_Attack_Loop"] = true,-- ["A_Humanoid_Bow_Attack_Loop"] = {["SequenceLength"] = 0.555555333333333, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Attack_Loop_FP"] = true,-- ["A_Humanoid_Bow_Attack_Loop_FP"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Attack_Release"] = true,-- ["A_Humanoid_Bow_Attack_Release"] = {["SequenceLength"] = 0.488888666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Attack_Release_FP"] = true,-- ["A_Humanoid_Bow_Attack_Release_FP"] = {["SequenceLength"] = 0.444444666666667, ["RateScale"] = 1.5,},
        
        ["A_Humanoid_Bow_Block_Idle"] = true,-- ["A_Humanoid_Bow_Block_Idle"] = {["SequenceLength"] = 2, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Block_Idle_FP"] = true,-- ["A_Humanoid_Bow_Block_Idle_FP"] = {["SequenceLength"] = 2, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Block_Hit"] = true,-- ["A_Humanoid_Bow_Block_Hit"] = {["SequenceLength"] = 0.244444666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Block_Hit_FP"] = true,-- ["A_Humanoid_Bow_Block_Hit_FP"] = {["SequenceLength"] = 0.2, ["RateScale"] = 1.5,},
        
        ["A_Humanoid_Bow_Equip"] = true,-- ["A_Humanoid_Bow_Equip"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Equip_FP"] = true,-- ["A_Humanoid_Bow_Equip_FP"] = {["SequenceLength"] = 0.533333333333333, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Unequip"] = true,-- ["A_Humanoid_Bow_Unequip"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Unequip_FP"] = true,-- ["A_Humanoid_Bow_Unequip_FP"] = {["SequenceLength"] = 0.444444666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Swim_Bow_Equip_FP"] = true,-- ["A_Humanoid_Swim_Bow_Equip_FP"] = {["SequenceLength"] = 0.533333333333333, ["RateScale"] = 1.5,},
        ["A_Humanoid_Swim_Bow_Unequip_FP"] = true,-- ["A_Humanoid_Swim_Bow_Unequip_FP"] = {["SequenceLength"] = 0.533333333333333, ["RateScale"] = 1.5,},
        
        ["A_Humanoid_Bow_Stagger"] = true,-- ["A_Humanoid_Bow_Stagger"] = {["SequenceLength"] = 1.35555533333333, ["RateScale"] = 1.5,},
        ["A_Humanoid_Bow_Stagger_FP"] = true,-- ["A_Humanoid_Bow_Stagger_FP"] = {["SequenceLength"] = 1.35555533333333, ["RateScale"] = 1.5,},

        ["A_Humanoid_Sneak_Bow_Attack_Start"] = true,-- ["A_Humanoid_Sneak_Bow_Attack_Start"] = {["SequenceLength"] = 1, ["RateScale"] = 1.5,},
        ["A_Humanoid_Sneak_Bow_Attack_Start_FP"] = true,-- ["A_Humanoid_Sneak_Bow_Attack_Start_FP"] = {["SequenceLength"] = 0.911111333333333, ["RateScale"] = 1.5,},
        ["A_Humanoid_Sneak_Bow_Attack_Loop"] = true,-- ["A_Humanoid_Sneak_Bow_Attack_Loop"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Sneak_Bow_Attack_Loop_FP"] = true,-- ["A_Humanoid_Sneak_Bow_Attack_Loop_FP"] = {["SequenceLength"] = 0.733333333333333, ["RateScale"] = 1.5,},
        ["A_Humanoid_Sneak_Bow_Attack_Release"] = true,-- ["A_Humanoid_Sneak_Bow_Attack_Release"] = {["SequenceLength"] = 0.488888666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Sneak_Bow_Attack_Release_FP"] = true,-- ["A_Humanoid_Sneak_Bow_Attack_Release_FP"] = {["SequenceLength"] = 0.444444666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Sneak_Bow_Equip"] = true,-- ["A_Humanoid_Sneak_Bow_Equip"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        ["A_Humanoid_Sneak_Bow_Equip_FP"] = true,-- ["A_Humanoid_Sneak_Bow_Equip_FP"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},

        ["A_Bow_Humanoid_Bow_Attack_Start"] = true,-- ["A_Bow_Humanoid_Bow_Attack_Start"] = {["SequenceLength"] = 0.866666666666667, ["RateScale"] = 1.5 * 2,},
        ["A_Bow_Humanoid_Bow_Attack_Loop"] = true,-- ["A_Bow_Humanoid_Bow_Attack_Loop"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        ["A_Bow_Humanoid_Bow_Attack_Release"] = true,-- ["A_Bow_Humanoid_Bow_Attack_Release"] = {["SequenceLength"] = 0.355555333333333, ["RateScale"] = 1.5,},
        ["A_Bow_Goblin_Bow_Attack_Start"] = true,-- ["A_Bow_Goblin_Bow_Attack_Start"] = {["SequenceLength"] = 0.888888666666667, ["RateScale"] = 1.5,},
        ["A_Bow_Goblin_Bow_Attack_Loop"] = true,-- ["A_Bow_Goblin_Bow_Attack_Loop"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},
        ["A_Bow_Goblin_Bow_Attack_Release"] = true,-- ["A_Bow_Goblin_Bow_Attack_Release"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},

        -- ["A_Humanoid_HandToHand_Block_Hit"] = true,-- ["A_Humanoid_HandToHand_Block_Hit"] = {["SequenceLength"] = 0.2, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_HandToHand_Block_Hit_FP"] = true,-- ["A_Humanoid_HandToHand_Block_Hit_FP"] = {["SequenceLength"] = 0.177778, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_HandToHand_Equip"] = true,-- ["A_Humanoid_HandToHand_Equip"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_HandToHand_Equip_FP"] = true,-- ["A_Humanoid_HandToHand_Equip_FP"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_HandToHand_Recoil"] = true,-- ["A_Humanoid_HandToHand_Recoil"] = {["SequenceLength"] = 0.555555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_HandToHand_Recoil_FP"] = true,-- ["A_Humanoid_HandToHand_Recoil_FP"] = {["SequenceLength"] = 0.622222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_HandToHand_Unequip"] = true,-- ["A_Humanoid_HandToHand_Unequip"] = {["SequenceLength"] = 0.333333333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_HandToHand_Unequip_FP"] = true,-- ["A_Humanoid_HandToHand_Unequip_FP"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_OneHand_Block_Hit"] = true,-- ["A_Humanoid_OneHand_Block_Hit"] = {["SequenceLength"] = 0.2, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_OneHand_Block_Hit_FP"] = true,-- ["A_Humanoid_OneHand_Block_Hit_FP"] = {["SequenceLength"] = 0.2, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Onehand_Equip"] = true,-- ["A_Humanoid_Onehand_Equip"] = {["SequenceLength"] = 0.555555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_OneHand_Equip_FP"] = true,-- ["A_Humanoid_OneHand_Equip_FP"] = {["SequenceLength"] = 0.422222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Onehand_Unequip"] = true,-- ["A_Humanoid_Onehand_Unequip"] = {["SequenceLength"] = 0.711111333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_OneHand_Unequip_FP"] = true,-- ["A_Humanoid_OneHand_Unequip_FP"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Shield_Block_Attack_FP"] = true,-- ["A_Humanoid_Shield_Block_Attack_FP"] = {["SequenceLength"] = 0.466666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Shield_Block_Hit"] = true,-- ["A_Humanoid_Shield_Block_Hit"] = {["SequenceLength"] = 0.266666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Shield_Block_Hit_FP"] = true,-- ["A_Humanoid_Shield_Block_Hit_FP"] = {["SequenceLength"] = 0.133333333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_ShieldBash"] = true,-- ["A_Humanoid_ShieldBash"] = {["SequenceLength"] = 0.577778, ["RateScale"] = 1.5,},

        -- ["A_Humanoid_Sneak_HandToHand_Equip"] = true,-- ["A_Humanoid_Sneak_HandToHand_Equip"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_HandToHand_Equip_FP"] = true,-- ["A_Humanoid_Sneak_HandToHand_Equip_FP"] = {["SequenceLength"] = 0.266666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_HandToHand_Unequip"] = true,-- ["A_Humanoid_Sneak_HandToHand_Unequip"] = {["SequenceLength"] = 0.333333333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_HandToHand_Unequip_FP"] = true,-- ["A_Humanoid_Sneak_HandToHand_Unequip_FP"] = {["SequenceLength"] = 0.2, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_OneHand_Equip"] = true,-- ["A_Humanoid_Sneak_OneHand_Equip"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_OneHand_Equip_FP"] = true,-- ["A_Humanoid_Sneak_OneHand_Equip_FP"] = {["SequenceLength"] = 0.844444666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_OneHand_Unequip"] = true,-- ["A_Humanoid_Sneak_OneHand_Unequip"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_OneHand_Unequip_FP"] = true,-- ["A_Humanoid_Sneak_OneHand_Unequip_FP"] = {["SequenceLength"] = 0.8, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_Staff_Equip"] = true,-- ["A_Humanoid_Sneak_Staff_Equip"] = {["SequenceLength"] = 0.711111333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_Staff_Equip_FP"] = true,-- ["A_Humanoid_Sneak_Staff_Equip_FP"] = {["SequenceLength"] = 0.733333333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_Staff_Unequip"] = true,-- ["A_Humanoid_Sneak_Staff_Unequip"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_Staff_Unequip_FP"] = true,-- ["A_Humanoid_Sneak_Staff_Unequip_FP"] = {["SequenceLength"] = 0.622222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_TwoHand_Equip"] = true,-- ["A_Humanoid_Sneak_TwoHand_Equip"] = {["SequenceLength"] = 0.755555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_TwoHand_Equip_FP"] = true,-- ["A_Humanoid_Sneak_TwoHand_Equip_FP"] = {["SequenceLength"] = 0.755555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_TwoHand_Unequip"] = true,-- ["A_Humanoid_Sneak_TwoHand_Unequip"] = {["SequenceLength"] = 0.622222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Sneak_TwoHand_Unequip_FP"] = true,-- ["A_Humanoid_Sneak_TwoHand_Unequip_FP"] = {["SequenceLength"] = 0.622222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Staff_Equip"] = true,-- ["A_Humanoid_Staff_Equip"] = {["SequenceLength"] = 0.733333333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Staff_Equip_FP"] = true,-- ["A_Humanoid_Staff_Equip_FP"] = {["SequenceLength"] = 0.916666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Staff_Unequip"] = true,-- ["A_Humanoid_Staff_Unequip"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Staff_Unequip_FP"] = true,-- ["A_Humanoid_Staff_Unequip_FP"] = {["SequenceLength"] = 0.622222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_HandToHand_Equip_FP"] = true,-- ["A_Humanoid_Swim_HandToHand_Equip_FP"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_HandToHand_Unequip_FP"] = true,-- ["A_Humanoid_Swim_HandToHand_Unequip_FP"] = {["SequenceLength"] = 0.4, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_OneHand_Equip_FP"] = true,-- ["A_Humanoid_Swim_OneHand_Equip_FP"] = {["SequenceLength"] = 0.422222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_OneHand_Unequip_FP"] = true,-- ["A_Humanoid_Swim_OneHand_Unequip_FP"] = {["SequenceLength"] = 0.666666666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_Staff_Equip_FP"] = true,-- ["A_Humanoid_Swim_Staff_Equip_FP"] = {["SequenceLength"] = 0.888888666666667, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_Staff_Unequip_FP"] = true,-- ["A_Humanoid_Swim_Staff_Unequip_FP"] = {["SequenceLength"] = 0.777778, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_TwoHand_Equip_FP"] = true,-- ["A_Humanoid_Swim_TwoHand_Equip_FP"] = {["SequenceLength"] = 0.755555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_Swim_TwoHand_Unequip_FP"] = true,-- ["A_Humanoid_Swim_TwoHand_Unequip_FP"] = {["SequenceLength"] = 0.755555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_TwoHand_Equip"] = true,-- ["A_Humanoid_TwoHand_Equip"] = {["SequenceLength"] = 0.755555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_TwoHand_Equip_FP"] = true,-- ["A_Humanoid_TwoHand_Equip_FP"] = {["SequenceLength"] = 0.755555333333333, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_TwoHand_Unequip"] = true,-- ["A_Humanoid_TwoHand_Unequip"] = {["SequenceLength"] = 0.622222, ["RateScale"] = 1.5,},
        -- ["A_Humanoid_TwoHand_Unequip_FP"] = true,-- ["A_Humanoid_TwoHand_Unequip_FP"] = {["SequenceLength"] = 0.622222, ["RateScale"] = 1.5,},
    }
}

return Config
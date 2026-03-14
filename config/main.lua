Config = Config or {}


Config.Core = {
    Framework = 'qbx', -- Framework: 'qb' (QB-Core) | 'qbx' (QBX Core) | 'abx' (ABX Core) | 'ox' (OX Core) | 'esx' (ESX)
    Debug = true,
}

Config.Integrations = {
    Inventory = { Type = 'ox' },   -- 'ox' | 'qb' | 'qs' 
    Target = { Type = 'ox_target' }, -- 'ox_target' | 'qb-target' 
    Notify = { Type = 'ox' },      -- 'ox' | 'qb' | 'esx' | 'brutal' 
    Progress = { Type = 'qb' },    -- 'ox' | 'qb' 
}

Config.Mining = Config.Mining or {}
Config.Mining.Zones = {
    [1] = {
        models = { 'prop_rock_2_a' }, 
        level = 1,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'coal_ore', min = 8, max = 12 },
        },
        xp = { min = 205, max = 228 },
        respawn = 30000,
        ores = {
            [1] = vector3(2930.86, 2788.05, 38.79),
            [2] = vector3(2932.66, 2784.21, 38.3),
            [3] = vector3(2938.83, 2785.46, 38.74),
            [4] = vector3(2938.33, 2788.84, 39.04),
            [5] = vector3(2935.33, 2789.37, 39.03),
            [6] = vector3(2932.97, 2790.01, 39.06),
            [7] = vector3(2934.75, 2793.31, 39.45),
            [8] = vector3(2939.74, 2792.74, 39.42),
            [9] = vector3(2941.77, 2789.77, 39.2),
            [10] = vector3(2942.53, 2787.26, 39.0),
            [11] = vector3(2944.84, 2786.11, 38.96),
            [12] = vector3(2946.22, 2789.55, 39.4),
            [13] = vector3(2948.14, 2787.09, 39.62),
            [14] = vector3(2946.2, 2784.02, 38.86),
            [15] = vector3(2946.67, 2781.54, 38.57),
            [16] = vector3(2949.69, 2781.75, 38.89),
            [17] = vector3(2951.69, 2779.61, 38.82),
            [18] = vector3(2949.7, 2776.76, 38.29),
            [19] = vector3(2951.25, 2774.73, 38.22),
            [20] = vector3(2953.29, 2776.18, 38.52),
            [21] = vector3(2955.13, 2774.97, 38.68),
            [22] = vector3(2952.94, 2771.95, 37.99),
            [23] = vector3(2947.01, 2792.31, 39.59),
            [24] = vector3(2948.18, 2796.46, 39.78),
            [25] = vector3(2946.59, 2798.33, 39.92),
            [26] = vector3(2943.62, 2799.32, 39.95),
            [27] = vector3(2947.6, 2792.36, 39.63),
            [28] = vector3(2948.84, 2788.65, 39.82),
            [29] = vector3(2950.35, 2785.23, 39.75),
            [30] = vector3(2952.42, 2781.03, 39.25),
            [31] = vector3(2954.52, 2777.26, 38.93),
            [32] = vector3(2955.66, 2774.04, 38.65)
        }
    },
    [2] = {
        models = { 'prop_rock_2_a' }, 
        level = 15,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'ls_copper_ore', min = 8, max = 12 },
        },
        xp = { min = 228, max = 259 },
        respawn = 25000,
        ores = {
            [1] = vector3(2926.25, 2796.31, 39.9),
            [2] = vector3(2928.98, 2798.46, 40.06),
            [3] = vector3(2931.1, 2800.22, 40.18),
            [4] = vector3(2933.46, 2802.11, 40.35),
            [5] = vector3(2935.63, 2803.58, 40.48),
            [6] = vector3(2937.83, 2804.92, 40.59),
            [7] = vector3(2936.54, 2806.68, 40.93),
            [8] = vector3(2933.61, 2805.82, 40.93),
            [9] = vector3(2931.59, 2803.24, 40.61),
            [10] = vector3(2928.36, 2801.27, 40.49),
            [11] = vector3(2926.18, 2799.85, 40.37),
            [12] = vector3(2922.96, 2800.61, 40.49),
            [13] = vector3(2922.49, 2802.79, 41.01),
            [14] = vector3(2924.59, 2804.28, 41.25),
            [15] = vector3(2928.59, 2806.52, 41.47),
            [16] = vector3(2930.08, 2808.89, 41.89),
            [17] = vector3(2932.32, 2812.58, 42.59),
            [18] = vector3(2929.28, 2813.01, 43.2),
            [19] = vector3(2925.56, 2809.7, 42.46),
            [20] = vector3(2922.59, 2808.57, 42.38),
            [21] = vector3(2921.28, 2805.64, 41.8),
            [22] = vector3(2919.41, 2804.42, 41.66),
        }
    },
    [3] = {
        models = { 'prop_rock_2_a' }, 
        level = 30,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'iron_ore', min = 8, max = 12 },
        },
        xp = { min = 259, max = 278 },
        respawn = 30000,
        ores = {
            [1] = vector3(2952.97, 2794.22, 39.79),
            [2] = vector3(2953.58, 2791.71, 39.95),
            [3] = vector3(2955.17, 2788.3, 40.48),
            [4] = vector3(2957.34, 2785.28, 40.08),
            [5] = vector3(2958.95, 2781.62, 39.59),
            [6] = vector3(2960.13, 2776.84, 38.96),
            [7] = vector3(2963.07, 2775.95, 38.63),
            [8] = vector3(2963.05, 2779.41, 38.68),
            [9] = vector3(2961.51, 2783.65, 39.09),
            [10] = vector3(2960.4, 2786.64, 39.47),
            [11] = vector3(2958.21, 2792.16, 39.6),
            [12] = vector3(2957.04, 2796.56, 39.96),
            [13] = vector3(2956.46, 2798.94, 40.28),
            [14] = vector3(2960.19, 2800.33, 40.4)
        }
    },
    [4] = {
        models = { 'prop_rock_2_a' }, 
        level = 20,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'silver_ore', min = 8, max = 12 },
        },
        xp = { min = 259, max = 279 },
        respawn = 30000,
        ores = {
            [1] = vector3(2905.54, 2763.89, 41.61),
            [2] = vector3(2906.45, 2758.18, 41.2),
            [3] = vector3(2907.32, 2748.43, 40.45),
            [4] = vector3(2906.66, 2745.34, 40.22),
            [5] = vector3(2906.24, 2742.65, 40.04),
            [6] = vector3(2905.4, 2736.91, 39.61),
            [7] = vector3(2903.99, 2733.6, 39.42),
            [8] = vector3(2902.78, 2730.2, 39.23),
            [9] = vector3(2907.9, 2725.46, 39.12),
            [10] = vector3(2911.35, 2722.98, 38.97),
            [11] = vector3(2914.03, 2722.96, 38.84),
            [12] = vector3(2898.91, 2725.54, 39.13),
            [13] = vector3(2896.07, 2722.38, 39.09),
            [14] = vector3(2890.25, 2719.11, 39.08),
            [15] = vector3(2885.96, 2716.29, 39.09),
            [16] = vector3(2880.89, 2712.67, 39.09),
            [17] = vector3(2879.16, 2711.58, 39.09),
            [18] = vector3(2881.39, 2711.49, 39.09),
        }
    },
    [5] = {
        models = { 'prop_rock_2_a' }, 
        level = 40,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'gold_ore', min = 8, max = 12 },
        },
        xp = { min = 259, max = 279 },
        respawn = 30000,
        ores = {
            [1] = vector3(2776.27, 2536.69, 47.02),
            [2] = vector3(2777.68, 2541.2, 46.93),
            [3] = vector3(2784.57, 2550.9, 46.25),
            [4] = vector3(2794.37, 2563.53, 45.06),
            [5] = vector3(2807.55, 2583.36, 43.08),
            [6] = vector3(2816.8, 2606.17, 41.14),
            [7] = vector3(2820.45, 2622.58, 39.87),
            [8] = vector3(2823.69, 2639.59, 38.76),
            [9] = vector3(2824.85, 2656.14, 37.91),
            [10] = vector3(2824.76, 2673.43, 37.08),
            [11] = vector3(2829.92, 2703.09, 38.35)
        }
    },
    [6] = {
        models = { 'prop_rock_2_a' }, 
        level = 50,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'uncut_ruby', min = 8, max = 12 },
        },
        xp = { min = 259, max = 279 },
        respawn = 30000,
        ores = {
            [1] = vector3(2779.39, 2536.47, 47.06),
            [2] = vector3(2779.4, 2544.54, 46.74),
            [3] = vector3(2787.21, 2554.6, 45.82),
            [4] = vector3(2798.19, 2568.2, 44.57),
            [5] = vector3(2809.96, 2588.2, 42.52),
            [6] = vector3(2817.8, 2611.49, 40.6),
            [7] = vector3(2821.82, 2628.31, 39.34),
            [8] = vector3(2823.66, 2645.26, 38.45),
            [9] = vector3(2825.02, 2662.41, 37.63),
            [10] = vector3(2828.02, 2687.18, 37.86),
            [11] = vector3(2830.54, 2706.9, 38.41)
        }
    },
    [7] = {
        models = { 'prop_rock_2_a' }, 
        level = 60,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'uncut_sapphire', min = 8, max = 12 },
        },
        xp = { min = 259, max = 279 },
        respawn = 30000,
        ores = {
            [1] = vector3(2776.27, 2536.69, 47.02),
            [2] = vector3(2777.68, 2541.2, 46.93),
            [3] = vector3(2784.57, 2550.9, 46.25),
            [4] = vector3(2794.37, 2563.53, 45.06),
            [5] = vector3(2807.55, 2583.36, 43.08),
            [6] = vector3(2816.8, 2606.17, 41.14),
            [7] = vector3(2820.45, 2622.58, 39.87),
            [8] = vector3(2823.69, 2639.59, 38.76),
            [9] = vector3(2824.85, 2656.14, 37.91),
            [10] = vector3(2824.76, 2673.43, 37.08),
            [11] = vector3(2829.92, 2703.09, 38.35)
        }
    },
    [8] = {
        models = { 'prop_rock_2_a' }, 
        level = 70,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'uncut_diamond', min = 8, max = 12 },
        },
        xp = { min = 259, max = 279 },
        respawn = 30000,
        ores = {
            [1] = vector3(2782.05, 2547.82, 46.5),
            [2] = vector3(2781.27, 2538.61, 46.93),
            [3] = vector3(2790.84, 2559.19, 45.51),
            [4] = vector3(2805.45, 2578.8, 43.49),
            [5] = vector3(2815.93, 2601.14, 41.54),
            [6] = vector3(2819.04, 2617.23, 40.27),
            [7] = vector3(2823.18, 2634.51, 39.06),
            [8] = vector3(2824.21, 2650.37, 38.08),
            [9] = vector3(2824.79, 2667.71, 37.42),
            [10] = vector3(2828.46, 2690.74, 37.95),
            [11] = vector3(2831.4, 2710.7, 38.48)
        }
    },
    [9] = {
        models = { 'prop_rock_2_a' }, 
        level = 45,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'sulfur_chunk', min = 4, max = 8 },
        },
        xp = { min = 325, max = 400 },
        respawn = 30000,
        ores = {
            [1] = vec3(2153.99, 6109.24, 56.58),
            [2] = vec3(2156.93, 6106.98, 56.73),
            [3] = vec3(2160.89, 6104.37, 56.79),
        }
    },
    [10] = {
        models = { 'prop_rock_2_a' }, 
        level = 60,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'tungsten', min = 4, max = 8 },
        },
        xp = { min = 325, max = 400 },
        respawn = 30000,
        ores = {
            [1] = vec3(-1015.13, 4403.29, 14.5),
            [2] = vec3(-1017.9, 4405.17, 14.82),
        }
    },
    [11] = {
        models = { 'prop_rock_2_a' }, -- standard GTA 5 rock
        level = 60,
        duration = { min = 15000, max = 20000 },
        reward = {
            { item = 'lead', min = 4, max = 7 },
        },
        xp = { min = 325, max = 400 },
        respawn = 20000,
        ores = {
            [1] = vec3(4290.3, -4485.46, 3.32),
            -- [2] = vector3(2829.18, 2788.52, 37.31),
            -- [3] = vector3(2832.66, 2787.86, 37.42)
        }
    },
}

Config.Mining.Tools = {
    { item = 'WEAPON_PICKAXE', weapon = 'WEAPON_PICKAXE', level = 0, bonus = { min = 0, max = 0 } },
    { item = 'WEAPON_COPPERPICKAXE', weapon = 'WEAPON_COPPERPICKAXE', level = 25, bonus = { min = 1, max = 2 } },
    { item = 'WEAPON_SILVERPICKAXE', weapon = 'WEAPON_SILVERPICKAXE', level = 75, bonus = { min = 2, max = 3 } },
    { item = 'WEAPON_GOLDPICKAXE', weapon = 'WEAPON_GOLDPICKAXE', level = 100, bonus = { min = 3, max = 4 } },
}

Config.Mining.XP = {
    Enabled = true,
    Table = {},
    BonusItems = {"mining_crate"},
    UseXPBomb = true,
}

Config.Mining.Cooldowns = {
    Node = 60,
    Global = 0,
}

Config.Animations = {
    Mining = {
        dict = 'melee@large_wpn@streamed_core',
        clip = 'ground_attack_on_spot',
        flag = 1,
        duration = 5000,
    },
    Pickup = {
        dict = '',
        clip = '',
        flag = 49,
        duration = 2000,
    },
}

Config.UI = {
    Leaderboard = {
        Enabled = true,
        Command = 'miningleaderboard',
        Keybind = nil,
        DefaultSort = 'xp',
        Limit = 50,
    },
}


Config.Mining.Tasks = {
    Enabled = true,
    OreItems = { 'coal_ore', 'ls_copper_ore', 'silver_ore', 'gold_ore' },
    List = {
        [1]  = { label = 'Coal 800',   requirements = { { item = 'coal_ore',      amount = 800 } },  xp = 400 },
        [2]  = { label = 'Coal 1500',  requirements = { { item = 'coal_ore',      amount = 1500 } }, xp = 800 },
        [3]  = { label = 'Coal 3000',  requirements = { { item = 'coal_ore',      amount = 3000 } }, xp = 1600 },
        [4]  = { label = 'Copper 800', requirements = { { item = 'ls_copper_ore',  amount = 800 } },  xp = 500 },
        [5]  = { label = 'Copper 1500',requirements = { { item = 'ls_copper_ore',  amount = 1500 } }, xp = 1000 },
        [6]  = { label = 'Copper 3000',requirements = { { item = 'ls_copper_ore',  amount = 3000 } }, xp = 2000 },
        [7]  = { label = 'Silver 800', requirements = { { item = 'silver_ore',  amount = 800 } },  xp = 600 },
        [8]  = { label = 'Silver 1500',requirements = { { item = 'silver_ore',  amount = 1500 } }, xp = 1200 },
        [9]  = { label = 'Silver 3000',requirements = { { item = 'silver_ore',  amount = 3000 } }, xp = 2400 },
        [10] = { label = 'Gold 800',   requirements = { { item = 'gold_ore',    amount = 800 } },  xp = 700 },
        [11] = { label = 'Gold 1500', requirements = { { item = 'gold_ore',    amount = 1500 } }, xp = 1400 },
        [12] = { label = 'Gold 3000', requirements = { { item = 'gold_ore',    amount = 3000 } }, xp = 2800 },
    },
    GlobalXpBoostExport = nil,
}

local function normalizeType(value, allowed, fallback)
    if value == nil then
        return fallback
    end
    value = string.lower(tostring(value))
    for _, item in ipairs(allowed) do
        if value == item then
            return value
        end
    end
    return fallback
end

Config.Core.Framework = normalizeType(Config.Core.Framework, { 'qb', 'qbx', 'abx', 'ox', 'esx' }, 'qb')
Config.Integrations.Inventory.Type = normalizeType(Config.Integrations.Inventory.Type, { 'ox', 'qb', 'qs', 'esx' }, 'qb')
Config.Integrations.Target.Type = normalizeType(Config.Integrations.Target.Type, { 'ox_target', 'qb-target', 'qtarget' }, 'qb-target')
Config.Integrations.Notify.Type = normalizeType(Config.Integrations.Notify.Type, { 'ox', 'qb', 'esx', 'brutal', 'custom' }, 'qb')
Config.Integrations.Progress.Type = normalizeType(Config.Integrations.Progress.Type, { 'ox', 'qb', 'custom' }, 'qb')
Config.UI.Leaderboard.DefaultSort = normalizeType(Config.UI.Leaderboard.DefaultSort, { 'xp', 'total_ores', 'nodes_mined' }, 'xp')

return Config

Config = {}

Config.Debug = true

Config.Framework = 'qb' -- Framework you use - 'qb' / 'esx'

Config.Target = 'ox_target' -- Target type currently only - 'ox_target'

Config.DisplayDistance = 150 -- Distance where the peds get created at

Config.Cooldown = 1200 -- Cooldown before a player can ask for food or a drink again - in seconds

Config.CookLocations = { --Locations of cooks,
    { model = "s_m_m_linecook", coords = vector4(-107.4215, 881.6157, 236.1359, 44.2659) },

    -- { model = "s_m_m_linecook", coords = vector4(1, 2, 3, 4) },
}


Config.TargetDistance = 3 -- Interact distance on target
Config.TargetLabel = 'Ask For Food' -- Target Label
Config.TargetIcon = 'fa-solid fa-utensils' -- Icon on the target
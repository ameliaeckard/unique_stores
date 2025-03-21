-- store_config.lua

Config = {}

Config.Stores = {

    Valentine = {
        storetype = "general",
        isDeactivated = false,
        useRandomLocation = false,
        possibleLocations = {
            OpenMenu = { vector3(-324.628, 803.9818, 116.88) },
            Npcs = { vector4(-324.628, 803.9818, 116.88, -81.17) },
        },
        Blip = { Allowed = true, Name = "Valentine Store", sprite = 1475879922, Pos = vector3(-324.628, 803.9818, 116.88) },
        Npc = { Allowed = true, Pos = vector4(-324.628, 803.9818, 116.88, -81.17), distanceRemoveNpc = 20.0, Model = "U_M_M_NbxGeneralStoreOwner_01" },
        storeName = "Valentine General Store",
        PromptName = "General Store",
        AllowedJobs = {},
        JobGrade = 0,
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,
        distanceOpenStore = 3.0,
    },

    Rhodes = {
        storetype = "general",
        isDeactivated = false,
        useRandomLocation = false,
        possibleLocations = {
            OpenMenu = { vector3(1330.227, -1293.41, 76.021) },
            Npcs = { vector4(1330.227, -1293.41, 76.021, 68.88) },
        },
        Blip = { Allowed = true, Name = "Rhodes Store", sprite = 1475879922, Pos = vector3(1330.227, -1293.41, 76.021) },
        Npc = { Allowed = true, Pos = vector4(1330.227, -1293.41, 76.021, 68.88), distanceRemoveNpc = 20.0, Model = "S_M_M_UNIBUTCHERS_01" },
        storeName = "Rhodes General Store",
        PromptName = "General Store",
        AllowedJobs = {},
        JobGrade = 0,
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,
        distanceOpenStore = 3.0,
    },

    WeaponStore = {
        storetype = "weapon",
        isDeactivated = false,
        useRandomLocation = false,
        possibleLocations = {
            OpenMenu = { vector3(2947.246, 1319.698, 44.88) },
            Npcs = { vector4(2947.246, 1319.698, 44.88, 72.38) },
        },
        Blip = { Allowed = true, Name = "Weapon Store", sprite = 1475879922, Pos = vector3(2947.246, 1319.698, 44.88) },
        Npc = { Allowed = true, Pos = vector4(2947.246, 1319.698, 44.88, 72.38), distanceRemoveNpc = 20.0, Model = "U_M_M_NbxGeneralStoreOwner_01" },
        storeName = "Weapon Store",
        PromptName = "Weapon Store",
        AllowedJobs = {},
        JobGrade = 0,
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,
        distanceOpenStore = 3.0,
    }

}

return Config

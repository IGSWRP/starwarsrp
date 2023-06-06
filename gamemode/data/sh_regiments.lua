IG = IG or {}

IG.Regiments = {
    ["RECRUIT"] = {
        name = "Recruit",
        colour = Color(255,255,255),
        models = { "models/nada/armytrooper_black_m.mdl" },
        health = 100,
        ranks = {
            [1] = { name = "Recruit", cl = 0 }
        },
        weapons = {
            "rw_sw_trd_e11"
        }
    },
    ["ST"] = {
        name = "439th Stormtrooper",
        colour = Color(200,200,200),
        models = { "models/banks/ig/imperial/st/st_trooper/st_trooper.mdl", "models/player/sono/starwars/snowtrooper.mdl" },
        health = 100,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25, weapons = { "rw_sw_dlt19" } },
            [3] = { health = 25, weapons = { "rw_sw_rk3" }, models = { "models/nada/pms/male/army.mdl", "models/nada/pms/female/army.mdl" } },
            [4] = { health = 25, models = { "models/banks/ig/imperial/st/st_commander/st_commander.mdl" } }
        },
        classes = {
            ["HEAVY"] = { name = "Heavy", weapons = { "ven_riddick_dlt23v", "rw_sw_nade_thermal" }, models = { "models/banks/ig/imperial/st/st_heavy/st_heavy.mdl" }, health = 150 },
            ["SCOUT"] = { name = "Scout", weapons = { "rw_sw_e11s", "rw_sw_dc17" } , models = { "models/banks/ig/imperial/275th/scout/275th_scout_trooper/275th_scout_trooper.mdl" }, health = 125 }
        },
        weapons = {
            "ven_e11",
        }
    },
    ["BH"] = { -- This is shitty test data, cbf finding the right models and weapons
        name = "Bounty Hunter",
        colour = Color(200,128,0),
        models = { "" },
        health = 100,
        ranks = {
            [1] = { cl = 0 }
        },
        classes = {
            ["BLACK"] = { name = "Black Krrsantan", weapons = { }, models = { }, health = 100 },
            ["BOBA"] = { name = "Boba Fett", weapons = { }, models = { }, health = 100 },
            ["BOSSK"] = { name = "Bossk", weapons = { }, models = { }, health = 100 },
            ["CAD"] = { name = "Cad Bane", weapons = { }, models = { }, health = 100 },
            ["HK47"] = { name = "HK-47", weapons = { }, models = { }, health = 100 },
            ["HK51"] = { name = "HK-51", weapons = { }, models = { }, health = 100 },
            ["ZUCK"] = { name = "HK-51", weapons = { }, models = { }, health = 100 },
        },
        weapons = {
            ""
        },
    },
    ["EVENT"] = {
        enabled = false, -- we don't want people setting persistent characters to this
        name = "Event",
        colour = Color(0,128,128),
        models = {},
        health = 100,
        ranks = {
            [1] = { cl = 0 }
        },
        weapons = {}
    }
}
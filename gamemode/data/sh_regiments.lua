IG = IG or {}

IG.Regiments = {
    ["RECRUIT"] = {
        name = "Recruit",
        colour = Color(255,255,255),
        models = { "models/banks/ig/imperial/31st/31st_trooper/31st_trooper.mdl" },
        health = 100,
        ranks = {
            [1] = { name = "Recruit", cl = 0 }
        },
        weapons = {
            "rw_sw_trd_dc15a"
        }
    },
    ["ST"] = {
        name = "439th Stormtrooper",
        colour = Color(200,200,200),
        models = { "models/banks/ig/imperial/st/st_trooper/st_trooper.mdl" },
        health = 150,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [1] = { health = 25 },
            [2] = { health = 25, weapons = { "rw_sw_bino_dark" } },
            [3] = { health = 25, models = { "blah_male.mdl", "blah_female.mdl" } },
            [4] = { health = 25, models = { "models/banks/ig/imperial/st/st_commander/st_commander.mdl" } }
        },
        classes = {
            ["HEAVY"] = { name = "Heavy", models = { "models/banks/ig/imperial/st/st_heavy/st_heavy.mdl" }, weapons = { "ven_riddick_dlt23v" } }
        },
        weapons = {
            "ven_e11",
            "rw_sw_nade_thermal"
        }
    }
}
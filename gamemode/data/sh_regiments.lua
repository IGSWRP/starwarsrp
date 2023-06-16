IG = IG or {}

IG.Regiments = {
    ["RECRUIT"] = {
        name = "Recruit",
        colour = Color(255,255,255),
        models = { "models/nada/armytrooper_black_m.mdl" },
        health = 100,
        ranks = {
            [1] = { name = "Recruit", cl = 0 },
        },
        weapons = {
            "rw_sw_trd_e11"
        },
    },
    ["ST"] = {
        name = "Stormtrooper Corps",
        colour = Color(200,200,200),
        models = { "models/banks/ig/imperial/st/st_trooper/st_trooper.mdl", "models/player/sono/starwars/snowtrooper.mdl" },
        health = 150,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25, weapons = { "rw_sw_dlt19", "rw_sw_e10", "rw_sw_se14r", "stryker_adrenaline" } },
            [3] = { health = 25, weapons = { "weapon_rpw_binoculars_nvg", "rw_sw_rk3_officer" }, models = { "models/nada/pms/male/trooper.mdl", "models/nada/pms/female/trooper.mdl" } },
            [4] = { health = 25, models = { "models/banks/ig/imperial/st/st_commander/st_commander.mdl" } },
        },
        classes = {
            ["HEAVY"] = { name = "Heavy", weapons = { "ven_riddick_dlt23v", "deployable_shield", "rw_ammo_distributor", "rw_sw_nade_thermal", "rw_sw_e11_noscope" }, models = { "models/banks/ig/imperial/st/st_heavy/st_heavy.mdl" }, health = 225 },
            ["SCOUT"] = { name = "Scout", weapons = { "rw_sw_dual_e11", "str_sw_e11s_mr", "weapon_grapplehook_m6h", "weapon_rpw_binoculars_nvg" }, models = { "models/banks/ig/imperial/275th/scout/275th_scout_trooper/275th_scout_trooper.mdl" }, health = 125 },
            ["SAPPER"] = { name = "Sapper", weapons = { "mortar_range_finder", "mortar_constructor", "rw_sw_e22", "fort_datapad", "fort_datapad_admin" }, models = { "models/banks/ig/imperial/275th/trooper/275th_t_trooper/275th_t_trooper.mdl" }, health = 200 },
        },
        weapons = {
            "rw_sw_e11",
            "rw_sw_e11s",
            "rw_sw_dlt19s",
        },
    },
    ["SK"] = {
        name = "Shock Division",
        colour = Color(255,0,0),
        models = { "models/banks/ig/imperial/shock/shock_trooper/shock_trooper.mdl" },
        health = 200,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25 },
            [3] = { health = 25, models = { "models/nada/pms/male/trooper.mdl", "models/nada/pms/female/trooper.mdl" } },
            [4] = { health = 25, models = { "models/player/bunny/imperial_shock/shock_commander.mdl" } },
        },
        classes = {},
        weapons = {},
    },
    ["RT"] = {
        name = "Riot Squad",
        colour = Color(193, 0, 0),
        models = { "models/banks/ig/imperial/riot/riot_trooper/riot_trooper.mdl", "models/nada/pms/male/trooper.mdl", "models/nada/pms/female/trooper.mdl", "models/banks/ig/imperial/riot/riot_commander/riot_commander.mdl", "models/banks/ig/imperial/custom/shock_patrol/shock_patrol.mdl" },
        health = 150,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25 },
            [3] = { health = 25 },
            [4] = { health = 25 },
        },
        classes = {

        },
        weapons = {

        },
    },
    ["VF"] = {
        name = "501st Legion",
        colour = Color(25, 78, 183),
        models = { "models/banks/ig/imperial/vf/vf_trooper/vf_trooper.mdl" },
        health = 150,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 50 },
        },
        classes = {},
        weapons = {},
    },
    ["MT"] = {
        name = "Medical Troopers",
        colour = Color(255,2,191),
        models = { "models/banks/ig/imperial/medic/medic_trooper/medic_trooper.mdl" },
        health = 100,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 50 },
            [3] = { health = 50, models = { "models/nada/pms/male/trooper.mdl", "models/nada/pms/female/trooper.mdl" } },
            [4] = { health = 100, models = { "models/banks/ig/imperial/medic/medic_commander/medic_commander.mdl" } },
        },
        classes = {},
        weapons = {},
    },
    ["SU"] = {
        name = "Shadow Troopers",
        colour = Color(0,0,0),
        models = { "models/banks/ig/imperial/shadow/shadow_trooper/shadow_trooper.mdl" },
        health = 150,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 50 },
            [3] = { health = 25, models = { "models/banks/ig/imperial/shadow/shadow_commander/shadow_commander.mdl" }},
            [4] = { health = 25 },
        },
        weapons = {

        },
    },
    ["JT"] = {
        name = "Jump Troopers",
        colour = Color(0,208,255),
        models = { "models/nada/rogueonesky.mdl" },
        health = 175,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25, models = {"models/nada/rogueonesky2.mdl" } },
            [3] = { health = 25, models = {"models/nada/rogueonesky4.mdl", "models/nada/rogueonesky5.mdl" } },
            [4] = { health = 25 },
        },
        classes = {},
        weapons = {},
    },
    ["EVO"] = {
        name = "Environmental Troopers",
        colour = Color(127,95,0),
        models = { "models/player/sample/evo1/evo.mdl" },
        health = 175,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25 },
            [3] = { health = 25, models = { "models/nada/pms/male/trooper.mdl", "models/nada/pms/female/trooper.mdl" } },
        },
        classes = {},
        weapons = {},

    },
    ["SCAR"] = {
        name = "SCAR Troopers",
        colour = Color(222,136,38),
        models = { "models/banks/ig/imperial/arc/scar/scar_trooper.mdl" },
        health = 100,
        ranks = IG.Ranks["army"],
        classes = {
            ["SUPPORT"] = { name = "Support", weapons = { "rw_sw_nade_bacta", "weapon_bactainjector", "hideyoshi_ig_defibs", "deployable_shield", "rw_sw_z2"}, models = { "models/banks/ig/imperial/arc/scar/scar_trooper.mdl" }, health = 200 },
            ["HEAVY"] = { name = "Heavy", weapons = { "rw_ammo_distributor", "rw_sw_fwmb10v", "rw_sw_rk3", "rw_sw_e22" }, models = { "models/banks/ig/imperial/st/st_heavy/st_heavy.mdl" }, health = 500 },
            ["ENG"] = { name = "Engineer", weapons = { "alydus_fortificationbuildertablet", "rw_sw_e10", "rw_sw_se14r", "rw_sw_nade_incendiary" }, models = { "models/banks/ig/imperial/arc/scar/scar_trooper.mdl" }, health = 250 },
            ["KREEL"] = { name = "Kreel", weapons = { "weapon_lightsaber", "rw_sw_tl50", "rw_sw_se14r", "weapon_jew_det" }, models = { "models/banks/ig/imperial/arc/scar/scar_trooper.mdl" }, health = 300 },
        },
        weapons = {},
    },
    ["ARC"] = {
        name = "ARC Troopers",
        colour = Color(143,0,255),
        models = { "models/halves/imparc/trp.mdl" },
        health = 200,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 100 },
        },
        classes = {},
        weapons = {},
    },
    ["NOVA"] = {
        name = "NOVA Company",
        colour = Color(255,191,0),
        models = { "models/banks/ig/imperial/nova/nova_trooper/nova_trooper.mdl" },
        health = 175,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25 },
            [3] = { health = 25 },
        },
        classes = {},
        weapons = {},
    },
    ["NC"] = {
        name = "Naval Commando",
        colour = Color(127,63,111),
        models = { "models/player/rising/navcom.mdl" },
        health = 175,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            
        },
        classes = {},
        weapons = {},
    },
    ["NAVY"] = {
        name = "Imperial Navy",
        colour = Color(90, 150, 90),
        models = { "models/nada/pms/male/bridgecrew.mdl", "models/nada/pms/female/bridgecrew.mdl" },
        health = 100,
        ranks = IG.Ranks["navy"],
        level_bonuses = {
            [2] = { health = 25 },
            [3] = { health = 50, models = { "models/nada/pms/male/naval_officer.mdl", "models/nada/pms/female/naval_officer.mdl" } },
        },
        classes = {},
        weapons = {},
        flags = {
            ["defcon"] = true,
        }
    },
    ["DT"] = {
        name = "Death Trooper",
        colour = Color(60, 80, 60),
        models = { "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl", "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_02/deathtrooper_02_male_mesh.mdl", "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl", "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl" },
        health = 300,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 50 },
            [3] = { health = 50 },
        },
        classes = {},
        weapons = {},
    },
    ["PT"] = {
        name = "Purge Trooper",
        colour = Color(75,0,0),
        models = { "models/sw1_purgetrooper.mdl" },
        health = 250,
        ranks = IG.Ranks["army"],
        level_bonuses = {
            [2] = { health = 25 },
            [3] = { health = 25 },
        },
    },
    ["BH"] = { -- This is shitty test data, cbf finding the right models and weapons
        name = "Bounty Hunter",
        colour = Color(200,128,0),
        models = { "" },
        health = 100,
        ranks = {
            [1] = { cl = 0 },
        },
        classes = {
            ["BLACK"] = { name = "Black Krrsantan", weapons = { }, models = { }, health = 100 },
            ["BOBA"] = { name = "Boba Fett", weapons = { }, models = { "models/nada/esb_bobafett.mdl" }, health = 100 },
            ["BOSSK"] = { name = "Bossk", weapons = { }, models = { }, health = 100 },
            ["CAD"] = { name = "Cad Bane", weapons = { }, models = { }, health = 100 },
            ["HK47"] = { name = "HK-47", weapons = { }, models = { }, health = 100 },
            ["HK51"] = { name = "HK-51", weapons = { }, models = { }, health = 100 },
            ["ZUCK"] = { name = "HK-51", weapons = { }, models = { }, health = 100 },
        },
        weapons = {
            "",
        },
    },
    ["DROID"] = {
        name = "Imperial Droid",
        colour = Color(193,68,31),
        models = { "" },
        health = 100,
        ranks = {
            [1] = { cl = 0 },
        },
        classes = {},
        weapons = {},
    },
    ["EVENT"] = {
        enabled = false, -- we don't want people setting persistent characters to this
        name = "Event",
        colour = Color(0,128,128),
        models = {"models/player/alyx.mdl"},
        health = 100,
        ranks = {
            [1] = { cl = 0 },
        },
        weapons = {},
    },
}

IG.LastRegimentRefresh = os.time()

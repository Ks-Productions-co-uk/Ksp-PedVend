Config = {}
Config.ShowBlips = true -- Toggle this to true or false to show/hide blips
Config.SellCooldown = 60 -- Cooldown in seconds
Config.SellLocations = {
    {
        object = 'prop_food_van_02',
        coords = vector4(-895.93, -2035.28, 9.3, 18.48), -- Ferrari Dealer
        blip = {
            sprite = 680, -- blip icon
            color = 2, -- blip color
            scale = 0.8, -- blip scale
            label = "Ped Vend LTD" -- Blip name
        }
    },
    {
        object = 'prop_food_van_01',
        coords = vector4(-899.07, -2038.96, 9.3, 39.84), -- Ferrari Dealer
        blip = {
            sprite = 680, -- blip icon
            color = 2, -- blip color
            scale = 0.8, -- blip scale
            label = "Ped Vend LTD" -- Blip name
        }
    },
    -- Add more locations as needed
}

Config.Items = {
    Drugs = {
        {name = "joint", icon = "fa-cannabis", label = "Joint", price = 25},
        {name = "coke_brick", icon = "fa-snowflake", label = "Coke Brick", price = 300},
        {name = "weed_brick", icon = "fa-leaf", label = "Weed Brick", price = 150},
        {name = "coke_small_brick", icon = "fa-snowflake", label = "Small Coke Brick", price = 100},
        {name = "oxy", icon = "fa-pills", label = "Oxy", price = 50},
        {name = "meth_package", icon = "fa-flask", label = "Meth Package", price = 200},
        {name = "weed_whitewidow", icon = "fa-leaf", label = "White Widow 2g", price = 10},
        {name = "weed_skunk", icon = "fa-leaf", label = "Skunk 2g", price = 10},
        {name = "weed_purplehaze", icon = "fa-leaf", label = "Purple Haze 2g", price = 10},
        {name = "weed_ogkush", icon = "fa-leaf", label = "OG Kush 2g", price = 10},
        {name = "weed_amnesia", icon = "fa-leaf", label = "Amnesia 2g", price = 10},
        {name = "weed_ak47", icon = "fa-leaf", label = "AK47 2g", price = 10},
    },
    Weapons = {
        {name = "weapon_bat", icon = "fa-baseball-bat", label = "Bat", price = 30},
        {name = "weapon_bottle", icon = "fa-wine-bottle", label = "Broken Bottle", price = 10},
        {name = "weapon_crowbar", icon = "fa-crowbar", label = "Crowbar", price = 40},
        {name = "weapon_flashlight", icon = "fa-flashlight", label = "Flashlight", price = 20},
        {name = "weapon_golfclub", icon = "fa-golf-club", label = "Golfclub", price = 25},
        {name = "weapon_hammer", icon = "fa-hammer", label = "Hammer", price = 15},
        {name = "weapon_hatchet", icon = "fa-hatchet", label = "Hatchet", price = 30},
        {name = "weapon_machete", icon = "fa-knife", label = "Machete", price = 40},
        {name = "weapon_switchblade", icon = "fa-knife", label = "Switchblade", price = 35},
        {name = "weapon_nightstick", icon = "fa-baton", label = "Nightstick", price = 50},
        {name = "weapon_wrench", icon = "fa-wrench", label = "Wrench", price = 15},
        {name = "weapon_battleaxe", icon = "fa-axe", label = "Battle Axe", price = 100},
        {name = "weapon_handcuffs", icon = "fa-handcuffs", label = "Handcuffs", price = 40},
        {name = "weapon_stone_hatchet", icon = "fa-axe", label = "Stone Hatchet", price = 20},
        {name = "weapon_candycane", icon = "fa-candy-cane", label = "Candy Cane", price = 10},
        {name = "weapon_pistol", icon = "fa-gun", label = "Walther P99", price = 500},
        {name = "weapon_combatpistol", icon = "fa-gun", label = "Combat Pistol", price = 600},
        {name = "weapon_appistol", icon = "fa-gun", label = "AP Pistol", price = 700},
        {name = "weapon_stungun", icon = "fa-bolt", label = "Taser", price = 300},
        {name = "weapon_pistol50", icon = "fa-gun", label = "Pistol .50", price = 800},
        {name = "weapon_snspistol", icon = "fa-gun", label = "SNS Pistol", price = 350},
        {name = "weapon_heavypistol", icon = "fa-gun", label = "Heavy Pistol", price = 750},
        {name = "weapon_vintagepistol", icon = "fa-gun", label = "Vintage Pistol", price = 400},
        {name = "weapon_flaregun", icon = "fa-bolt", label = "Flare Gun", price = 200},
        {name = "weapon_marksmanpistol", icon = "fa-gun", label = "Marksman Pistol", price = 650},
        {name = "weapon_revolver", icon = "fa-gun", label = "Revolver", price = 700},
        {name = "weapon_revolver_mk2", icon = "fa-gun", label = "Violence", price = 900},
        {name = "weapon_doubleaction", icon = "fa-gun", label = "Double Action Revolver", price = 750},
        {name = "weapon_snspistol_mk2", icon = "fa-gun", label = "SNS Pistol Mk II", price = 400},
        {name = "weapon_raypistol", icon = "fa-gun", label = "Up-n-Atomizer", price = 1000},
        {name = "weapon_ceramicpistol", icon = "fa-gun", label = "Ceramic Pistol", price = 850},
        {name = "weapon_navyrevolver", icon = "fa-gun", label = "Navy Revolver", price = 950},
        {name = "weapon_gadgetpistol", icon = "fa-gun", label = "Perico Pistol", price = 1200},
        {name = "weapon_pistolxm3", icon = "fa-gun", label = "Pistol XM3", price = 1100},
    },
    Items = {
        {name = "goldbar", icon = "fa-coins", label = "Gold Bar", price = 1000},
        {name = "diamond", icon = "fa-gem", label = "Diamond", price = 500},
        {name = "phone", icon = "fa-mobile-alt", label = "Phone", price = 200},
        {name = "radio", icon = "fa-walkie-talkie", label = "Radio", price = 100},
        {name = "whiskey", icon = "fa-whiskey-glass", label = "Whiskey", price = 15},
        {name = "vodka", icon = "fa-vial", label = "Vodka", price = 10},
        {name = "rolex", icon = "fa-watch", label = "Golden Watch", price = 250},
        {name = "diamond_ring", icon = "fa-ring", label = "Diamond Ring", price = 300},
        {name = "goldchain", icon = "fa-necklace", label = "Golden Chain", price = 400},
        {name = "parachute", icon = "fa-parachute-box", label = "Parachute", price = 150},
        {name = "binoculars", icon = "fa-binoculars", label = "Binoculars", price = 20},
    },
    Materials = {
        {name = "aluminum", icon = "fa-cogs", label = "Aluminum", price = 100},
        {name = "copper", icon = "fa-cogs", label = "Copper", price = 75},
        {name = "glass", icon = "fa-cogs", label = "Glass", price = 50},
        {name = "iron", icon = "fa-cogs", label = "Iron", price = 80},
        {name = "plastic", icon = "fa-cogs", label = "Plastic", price = 60},
        {name = "rubber", icon = "fa-cogs", label = "Rubber", price = 70},
        {name = "steel", icon = "fa-cogs", label = "Steel", price = 90},
        {name = "metalscrap", icon = "fa-cogs", label = "Metal Scrap", price = 50},
        {name = "aluminumoxide", icon = "fa-cogs", label = "Aluminium Powder", price = 30},
    }

    -- Add more categories here
}

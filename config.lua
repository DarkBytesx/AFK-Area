Config = {}

Config['StartAFK'] = "F"   
Config['StopAFK'] = "L"    
Config['HideAFK'] = "Tab"

Config.Font = 'Arial' 
Config.Time =  5  
Config.OpenBonus = true

Config.Zone = { 
    [1] = {
        coords = { x = -419.697, y = 1143.284, z = 325.85 },
        range = 50, 
        ItemData = {
            ['Item'] = 'bread',     
            ['amount'] = 1           
		    },
        OpenBonus = false,
        ItemBonus = {
            -- {
            --   ['Item'] = 'money',     -- ของที่จะได้
            --   ['amount'] = {3000, 5000},            -- จำนวน
            --   ['Percent'] = 10          -- %
            -- },
            -- {
            --   ['Item'] = 'black_money',     -- ของที่จะได้
            --   ['amount'] = {4000, 6000},            -- จำนวน
            --   ['Percent'] = 50          -- %
            -- },
        }
    },
}

function RadiusAlpha() 
  ---##start
	local Alpha = AddBlipForRadius(-419.697, 1143.284, 325.85, 50.0) 
	SetBlipColour(Alpha,2) 
	SetBlipAlpha(Alpha,200)	 
  ---##end	
end

Config.blip = {
    [1] = {
        title = "AFK ZONE",
        id = 494,
        colour = 0,
		x = -419.697, y = 1143.284, z = 325.85
    },
}

---------------------โซนค่าStatus----------------------

Config['Godmode'] = true 
Config['Status'] = true 
Config.status1 = 'hunger'
Config.status2 = 'thirst'
Config.status3 = 'stress'
Config.status4 = nil
Config.status5 = nil


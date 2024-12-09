ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("cat-AFKZONE:additem")
AddEventHandler("cat-AFKZONE:additem", function(item, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem(item, count)

    if Config.OpenBonus then
        for k, v in pairs(Config.Zone) do
            for k2, v2 in pairs(v.ItemBonus) do
                local randompercent = math.random(1, 100)
                if randompercent <= v2['Percent'] then
                    local xItemCount = math.random(v2['amount'][1], v2['amount'][2])
                    xPlayer.addInventoryItem(v2['Item'], xItemCount)
                end
            end
        end
    end
end)

RegisterNetEvent("cat-AFKZONE:SetStatus")
AddEventHandler("cat-AFKZONE:SetStatus", function(value)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

end)

RegisterNetEvent("cat-AFKZONE:removestatus")
AddEventHandler("cat-AFKZONE:removestatus", function(value)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

end)
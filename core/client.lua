Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX = exports["es_extended"]:getSharedObject()
local startscript,inzone,showup,statusTEXT = false
local loop = 0
local token = nil
local Status = {}

local requiredItems = {"bread", "water", "money"} 
local inzone = false
local outzone = false
local startscript = false
local active = false
local inzone = false
local outzone = false
local startscript = false
local active = false
local playerDistances = {}

local sleep = nil
local stress = nil
local dirty = nil
local hunger = nil
local thirst = nil

RegisterKeyMapping("AFKZONE", "Start AFK", "keyboard", Config['StartAFK'])
RegisterKeyMapping("HideAfk", "Hide AFK", "keyboard", Config['HideAFK'])

RegisterCommand("AFKZONE", function()
  if inzone then
      if not startscript then
          local hasItem = false
          for _, itemName in ipairs(requiredItems) do
              local item = exports.ox_inventory:Search('count', itemName)
              if item > 0 then
                  hasItem = true
                  break
              end
          end

          if hasItem then
              Save_Status()
              startscript = true
              active = true
              SendNUIMessage({
                  type = "start-menu",
                  time = Config.Time
              })
              lib.notify({
                  title = "AFK Zone",
                  description = "You have started AFK Mode",
                  type = "success",
                  position = 'top'
              })
          else
              lib.notify({
                  title = "AFK Zone",
                  description = "You Need AFK Card 1 Day / 7 Days or Permanent.",
                  type = "error",
                  position = 'top'
              })
          end
      end
  elseif outzone then
      lib.notify({
          title = "AFK Zone",
          description = "You are not in the AFK zone.",
          type = "error",
          position = 'top'
      })
  end
end, false)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(15000) 
      if startscript and inzone then
          local hasItem = false
          for _, itemName in ipairs(requiredItems) do
              local item = exports.ox_inventory:Search('count', itemName)
              if item > 0 then
                  hasItem = true
                  break 
              end
          end

          if not hasItem then
              startscript = false
              active = false
              SendNUIMessage({
                  type = "Exit"
              })
              lib.notify({
                  title = "AFK Zone",
                  description = "You Have Drop the AFK Card From Your Inventory",
                  type = "error",
                position = 'top'
              })
          end
      end
  end
end)

RegisterCommand("HideAfk", function()
  if startscript then
  if not showup  then 
    showup = true
    SendNUIMessage({
      type = "hide-menu",
      status = true
    });
  else
    showup = false
    SendNUIMessage({
      type = "hide-menu",
      status = false
    });
    end
  end
end, false)


local hasGreeted = false
local hasWarned = true

Citizen.CreateThread(function()
    while true do  
        Citizen.Wait(1000)
        local Ped = PlayerPedId()
        for i, v in ipairs(Config.Zone) do 
            local MyCoords = GetEntityCoords(Ped)
            local ActiveZone = vector3(v.coords.x, v.coords.y, v.coords.z)
            local Distance = math.floor(#(ActiveZone - MyCoords))

            if Distance < v.range then
                inzone = true
                outzone = false

                if not hasGreeted then
                    lib.notify({
                        title = "AFK Zone",
                        description = "Welcome to the AFK Zone!",
                        type = "success",
                        position = 'top'
                    })
                    hasGreeted = true
                    hasWarned = false
                end

                if not active then 
                    SendNUIMessage({
                        type = "first-menu",
                        status = true
                    })
                else 
                    SendNUIMessage({
                        type = "first-menu",
                        status = false
                    })
                end
            else
                outzone = true
                inzone, startscript, active, statusTEXT = false
                if not hasWarned then
                    lib.notify({
                        title = "AFK Zone",
                        description = "You have left the AFK Zone!",
                        type = "error",
                        position = 'top'
                    })
                    hasWarned = true
                    hasGreeted = false
                end
                SendNUIMessage({
                    type = "Exit"
                })

                CloseScreen()
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
    if active then
      if IsControlJustPressed(0, Keys[Config['StopAFK']]) then   --[X] กดยกเลิก (เพิ่มฟังชั่นต่อจากนี้)

        inzone,startscript,active,statusTEXT = false
        SendNUIMessage({
          type = "Exit",
        });
        TriggerServerEvent('cat-AFKZONE:removestatus',"")
        statusTEXT = false
        canuse = false
        CloseScreen()
        ClearPedTasksImmediately(GetPlayerPed(-1))
        Citizen.Wait(5000)
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(5000)
      local ped = PlayerPedId()
      local playerped = GetPlayerPed(-1)

      if inzone and startscript then
          if Config['Godmode'] then
              NetworkSetPlayerIsPassive(true)
              NetworkSetFriendlyFireOption(false)
              SetPedCanRagdoll(ped, false)
              SetEntityInvincible(playerped, true)
          end

          if Config['Status'] == true then
              if hunger ~= nil then
                  TriggerEvent("esx_status:set", Config.status1, hunger)
              end
              if thirst ~= nil then
                  TriggerEvent("esx_status:set", Config.status2, thirst)
              end
              if stress ~= nil then
                  TriggerEvent("esx_status:set", Config.status3, stress)
              end
              if sleep ~= nil then
                  TriggerEvent('esx_status:set', Config.status4, sleep)
              end
              if dirty ~= nil then
                  TriggerEvent('esx_status:set', Config.status5, dirty)
              end
          end
      else
          if Config['Godmode'] then
              NetworkSetFriendlyFireOption(true)
              SetPedCanRagdoll(ped, true)
              SetEntityInvincible(playerped, false)
              NetworkSetPlayerIsPassive(false)
          end
      end
  end
end)

function Save_Status()
	TriggerEvent('esx_status:getStatus', Config.status1, function(status)
		hunger = status.val
	end)
	TriggerEvent('esx_status:getStatus', Config.status2, function(status)
		thirst = status.val
	end)	
	TriggerEvent('esx_status:getStatus', Config.status3, function(status)
		stress = status.val
	end)	
  TriggerEvent('esx_status:getStatus', Config.status4, function(status)
		sleep = status.val
	end)
	TriggerEvent('esx_status:getStatus', Config.status5, function(status)
		dirty = status.val
	end)

end

RegisterNetEvent"cat-AFKZONE:getstatus"
AddEventHandler("cat-AFKZONE:getstatus", function(element)
	Status = element
end)


function OpenScreen()
  AnimpostfxPlay("MenuMGSelectionIn", 1000, true)
  SetNuiFocus(true, true)
end


function CloseScreen()
  SetNuiFocus(false,false)
  AnimpostfxStop("MenuMGSelectionIn")
end


RegisterFontFile(Config.Font)
fontId = RegisterFontId(Config.Font)

local function DrawText3D(position, text, r,g,b) 
  local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1.12)
  local dist = #(GetGameplayCamCoords()-position)

  local scale = (1/dist)*2
  local fov = (1/GetGameplayCamFov())*100
  local scale = scale*fov
 
  if onScreen then
          SetTextScale(0.0*scale, 0.55*scale)
      end
        SetTextFont(fontId)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
end

CreateThread(function()
    for k, info in pairs(Config.blip) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 1.0)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

RegisterNUICallback("cat-AFK-ITEM", function()
  for i, v in ipairs(Config.Zone) do
      TriggerServerEvent("cat-AFKZONE:additem", v.ItemData['Item'], v.ItemData['amount'])
  end
end)

RegisterNUICallback("cat-START-AFK", function()
  PressOpenStart()
end)

RegisterNUICallback("cat-AFK-BOX", function(data)
  local value = data.value
  if active  then 
    if data.value ~= "nil" then
      statusTEXT = true
      TriggerServerEvent('cat-AFKZONE:SetStatus',data.value)
      CloseScreen()
    else
      
      TriggerServerEvent('cat-AFKZONE:removestatus',"")
      statusTEXT = false
      CloseScreen()
    end
  end
end)

RegisterNUICallback("cat-AFK-CLOSE", function()
  if active then 
    CloseScreen()
  end
end)


Citizen.CreateThread(function()
	Citizen.Wait(5000)
    RadiusAlpha()
	Citizen.Wait(5000)
end)
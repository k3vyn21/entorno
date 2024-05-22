ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		PlayerData = ESX.GetPlayerData()
	end
end)



RegisterCommand('entorno', function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        streetName = GetStreetNameFromHashKey(streetName)
	local msg = rawCommand:sub(8)
	local emergency = 'entorno'
	TriggerEvent('chatMessage', "(OOC)", {128, 128, 128}, "^7 Se ha enviado una llamada de rol de entorno a la policia")
    TriggerServerEvent('esx_jobChat:911',{
        x = ESX.Math.Round(playerCoords.x, 1),
        y = ESX.Math.Round(playerCoords.y, 1),
        z = ESX.Math.Round(playerCoords.z, 1)
    }, msg, streetName, emergency)
end, false)

RegisterNetEvent('esx_jobChat:Send')
AddEventHandler('esx_jobChat:Send', function(messageFull, job)
    if PlayerData.job.name == job then
		TriggerEvent('chat:addMessage', messageFull)
    end
end)

RegisterNetEvent('esx_jobChat:EmergencySend')
AddEventHandler('esx_jobChat:EmergencySend', function(messageFull)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'pdi' then
		TriggerEvent('chat:addMessage', messageFull)
    end
end)

RegisterNetEvent('esx_jobChat:911Marker')
AddEventHandler('esx_jobChat:911Marker', function(targetCoords, type)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'pdi' then
        local alpha = 250
        local call = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite (call, 304)
		SetBlipDisplay(call, 4)
		SetBlipScale  (call, 1.2)
        SetBlipAsShortRange(call, true)
        SetBlipAlpha(call, alpha)

        SetBlipHighDetail(call, true)
		SetBlipAsShortRange(call, true)

		if type == 'entorno' then
			SetBlipColour (call, 3)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString('Entorno')
	    	EndTextCommandSetBlipName(call)
		else
			SetBlipColour (call, 64)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString('Entorno')
	    	EndTextCommandSetBlipName(call)
		end

		while alpha ~= 0 do
			Citizen.Wait(100 * 4)
			alpha = alpha - 1
			SetBlipAlpha(call, alpha)

			if alpha == 0 then
				RemoveBlip(call)
				return
			end
        end
    end
end)
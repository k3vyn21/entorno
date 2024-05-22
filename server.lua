ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

RegisterServerEvent('esx_jobChat:chat')
AddEventHandler('esx_jobChat:chat', function(job, msg)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local pName= getIdentity(source)
	fal = pName.firstname .. " " .. pName.lastname
	jobName = string.upper(job)
	local messageFull = {
        template = '<div style="padding: 8px; margin: 8px; background-color: rgba(0, 153, 51, 0.9); border-radius: 25px;"><i class="far fa-building"style="font-size:15px"></i> [{0}] {1} : {2}</font></i></b></div>',
        args = {jobName, fal, msg}
    }
    TriggerClientEvent('esx_jobChat:Send', -1, messageFull, job)
end)

RegisterServerEvent('esx_jobChat:911')
AddEventHandler('esx_jobChat:911', function(targetCoords, msg, streetName, emergency)
    local _source = source
    local xPlayers = ESX.GetPlayers()
	local messageFull
	fal = GetPlayerName(source)
	if emergency == '911' then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == "police" or xPlayer.job.name == "pdi" then
				TriggerClientEvent("pNotify:SendNotification", xPlayers[i], {text = "<center><strong><b style='color:#026b14'>Carabineros anuncia entorno</b><strong><br /> <br /> "..msg.."<center>", type = "info", queue = "global", timeout = 10000, layout = "centerRight" })
			end
		end
	else
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == "police" or xPlayer.job.name == "pdi" then
				TriggerClientEvent("pNotify:SendNotification", xPlayers[i], {text = "<center><strong><b style='color:#026b14'>Carabineros anuncia entorno</b><strong><br /> <br /> "..msg.."<center>", type = "info", queue = "global", timeout = 10000, layout = "centerRight" })
			end
		end
	end
	TriggerClientEvent('esx_jobChat:911Marker', -1, targetCoords, emergency)
    TriggerClientEvent('esx_jobChat:EmergencySend', -1, msg)
end)
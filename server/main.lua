ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('zF5:server:getGroup', function(source, cb)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local plyGroup = xPlayer.getGroup()
	cb(plyGroup)
end)


ESX.RegisterServerCallback('KorioZ-PersonalMenu:Bill_getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback("zF5:server:getInventory", function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local plyInventory = xPlayer.getInventory()
	cb(plyInventory)
end)

RegisterServerEvent('esx_menu:Admin_Cash')
AddEventHandler('esx_menu:Admin_Cash', function(money)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)   

	bandata = {}
	bandata.reason = 'VICE CITY PRIVATE ANTICHEAT | INJECTION DETECTED FOR CASH GIVE'-- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
	xPlayer.addMoney(money)
		TriggerClientEvent('esx:showAdvancedNotification', source, '~g~zF5', '~r~Modération Money', 'Give de ~g~ '..money.. "$", 'CHAR_TREVOR', 3)
end)

RegisterServerEvent('esx_menu:Admin_Bank')
AddEventHandler('esx_menu:Admin_Bank', function(money)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)   

	bandata = {}
	bandata.reason = 'SymphoniaLife PRIVATE ANTICHEAT | INJECTION DETECTED FOR BANK GIVE' -- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
		xPlayer.addAccountMoney('bank', money)
		TriggerClientEvent('esx:showAdvancedNotification', source, '~g~zF5', '~r~Modération Money', 'Give de ~g~ '..money.. "$ en banque", 'CHAR_TREVOR', 3)
end)

RegisterServerEvent('esx_menu:Admin_DirtyMoney')
AddEventHandler('esx_menu:Admin_DirtyMoney', function(money)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)   
	xPlayer.addAccountMoney('black_money', money)
	TriggerClientEvent('esx:showAdvancedNotification', source, '~g~zF5', '~r~Modération Money', 'Give de ~g~ '..money.. "$ en sale", 'CHAR_TREVOR', 3)

end)

--Argent banque
ESX.RegisterServerCallback("zF5:GetMoney", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local bankmoney = xPlayer.getAccount('bank')
	cb(bankmoney)
end)

---- Twt 

RegisterNetEvent("twt:send")
AddEventHandler("twt:send",function(TweetText, SenderTweet)
    local name = GetPlayerName(source)
    local xPlayers	= ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('tweet:sendtweet', xPlayers[i], SenderTweet, TweetText, name)
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Twitter', 'Notiffication ['..SenderTweet..']','Contenue : '..TweetText, 'CHAR_STRETCH', 0)
		print('^7[^3zF5^7] Nom Utilisateur : \''..SenderTweet..'\' a tweet : '..TweetText)
    end
end)


ESX.RegisterServerCallback('krz_personalmenu:Bill_getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result do
			bills[#bills + 1] = {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			}
		end

		cb(bills)
	end)
end)


--- Menu Gestion Organisation/Entreprise

local function makeTargetedEventFunction(fn)
	return function(target, ...)
		if tonumber(target) == -1 then return end
		fn(target, ...)
	end
end

function getMaximumGrade(jobName)
	local p = promise.new()

	MySQL.Async.fetchScalar('SELECT grade FROM job_grades WHERE job_name = @job_name ORDER BY `grade` DESC', { ['@job_name'] = jobName }, function(result)
		p:resolve(result)
	end)

	local queryResult = Citizen.Await(p)

	return tonumber(queryResult)
end


RegisterServerEvent('zF5:Boss_promouvoirplayer')
AddEventHandler('zF5:Boss_promouvoirplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob = targetXPlayer.getJob()

		if sourceJob.name == targetJob.name then
			local newGrade = tonumber(targetJob.grade) + 1

			if newGrade ~= getMaximumGrade(targetJob.name) then
				targetXPlayer.setJob(targetJob.name, newGrade)

				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~promu %s~w~.'):format(targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~promu par %s~w~.'):format(sourceXPlayer.name))
			else
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation ~r~Gouvernementale~w~.')
			end
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre entreprise.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('zF5:Boss_destituerplayer')
AddEventHandler('zF5:Boss_destituerplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob = targetXPlayer.getJob()

		if sourceJob.name == targetJob.name then
			local newGrade = tonumber(targetJob.grade) - 1

			if newGrade >= 0 then
				targetXPlayer.setJob(targetJob.name, newGrade)

				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~rétrogradé %s~w~.'):format(targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~r~rétrogradé par %s~w~.'):format(sourceXPlayer.name))
			else
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ d\'avantage.')
			end
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('zF5:Boss_recruterplayer')
AddEventHandler('zF5:Boss_recruterplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)

		targetXPlayer.setJob(sourceJob.name, 0)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~recruté %s~w~.'):format(targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~embauché par %s~w~.'):format(sourceXPlayer.name))
	end
end))

RegisterServerEvent('zF5:Boss_virerplayer')
AddEventHandler('zF5:Boss_virerplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob = targetXPlayer.getJob()

		if sourceJob.name == targetJob.name then
			targetXPlayer.setJob('unemployed', 0)
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~viré %s~w~.'):format(targetXPlayer.name))
			TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~viré par %s~w~.'):format(sourceXPlayer.name))
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre entreprise.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('zF5:Boss_promouvoirplayer2')
AddEventHandler('zF5:Boss_promouvoirplayer2', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob2 = sourceXPlayer.getJob2()

	if sourceJob2.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob2 = targetXPlayer.getJob2()

		if sourceJob2.name == targetJob2.name then
			local newGrade = tonumber(targetJob2.grade) + 1

			if newGrade ~= getMaximumGrade(targetJob2.name) then
				targetXPlayer.setJob2(targetJob2.name, newGrade)

				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~promu %s~w~.'):format(targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~promu par %s~w~.'):format(sourceXPlayer.name))
			else
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation ~r~Gouvernementale~w~.')
			end
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('zF5:Boss_destituerplayer2')
AddEventHandler('zF5:Boss_destituerplayer2', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob2 = sourceXPlayer.getJob2()

	if sourceJob2.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob2 = targetXPlayer.getJob2()

		if sourceJob2.name == targetJob2.name then
			local newGrade = tonumber(targetJob2.grade) - 1

			if newGrade >= 0 then
				targetXPlayer.setJob2(targetJob2.name, newGrade)

				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~rétrogradé %s~w~.'):format(targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~r~rétrogradé par %s~w~.'):format(sourceXPlayer.name))
			else
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ d\'avantage.')
			end
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('zF5:Boss_recruterplayer2')
AddEventHandler('zF5:Boss_recruterplayer2', makeTargetedEventFunction(function(target, grade2)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob2 = sourceXPlayer.getJob2()

	if sourceJob2.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)

		targetXPlayer.setJob2(sourceJob2.name, 0)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~recruté %s~w~.'):format(targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~embauché par %s~w~.'):format(sourceXPlayer.name))
	end
end))

RegisterServerEvent('zF5:Boss_virerplayer2')
AddEventHandler('zF5:Boss_virerplayer2', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob2 = sourceXPlayer.getJob2()

	if sourceJob2.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob2 = targetXPlayer.getJob2()

		if sourceJob2.name == targetJob2.name then
			targetXPlayer.setJob2('unemployed2', 0)
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~viré %s~w~.'):format(targetXPlayer.name))
			TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~viré par %s~w~.'):format(sourceXPlayer.name))
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))



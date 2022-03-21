ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)



function Keyboardput(TextEntry, ExampleText, MaxStringLength) -- Texte par joueur
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local noclip = false
local noclip_speed = 1.0
local timems = 14400000


function zNoClip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- activé
    SetEntityInvincible(ped, true)
	SetEntityVisible(ped, false, false)
	invisible = true
  ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'No-Clip ~g~ON', 'CHAR_TREVOR', 3)
    Visual.Subtitle("~r~↓ ~y~zDéveloppement ~r~↓~n~ ~b~Grade : ~g~ "..zName, timems)

  else -- désactivé
    SetEntityInvincible(ped, false)
	SetEntityVisible(ped, true, false)
	invisible = false
  ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'No-Clip ~r~OFF', 'CHAR_TREVOR', 3)
    Visual.Subtitle("", 0)
  end
end


function zInvinsible()
  zdev = not zdev
  local ped = GetPlayerPed(-1)
  if zdev then -- activé
    SetEntityInvincible(ped, true)
	SetEntityVisible(ped, false, false)
	invisible = true
    Visual.Subtitle("~r~↓ ~y~zDéveloppement ~r~↓~n~ ~b~Grade : ~g~ "..zName.."~n~ ~r~Invisible", timems)

  else -- désactivé
    SetEntityInvincible(ped, false)
	SetEntityVisible(ped, true, false)
	invisible = false
    Visual.Subtitle("", 0)
  end
end


function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end


function getCamDirection()
    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
    local pitch = GetGameplayCamRelativePitch()
  
    local x = -math.sin(heading*math.pi/180.0)
    local y = math.cos(heading*math.pi/180.0)
    local z = math.sin(pitch*math.pi/180.0)
  
    local len = math.sqrt(x*x+y*y+z*z)
    if len ~= 0 then
      x = x/len
      y = y/len
      z = z/len
    end
  
    return x,y,z
  end
  
  function isNoclip()
    return noclip
  end

  Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if noclip then
		local ped = GetPlayerPed(-1)
		local x,y,z = getPosition()
		local dx,dy,dz = getCamDirection()
		local speed = noclip_speed
  
		-- reset du velocity
		SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
  
		-- aller vers le haut
		if IsControlPressed(0,32) then -- MOVE UP
		  x = x+speed*dx
		  y = y+speed*dy
		  z = z+speed*dz
		end
  
		-- aller vers le bas
		if IsControlPressed(0,269) then -- MOVE DOWN
		  x = x-speed*dx
		  y = y-speed*dy
		  z = z-speed*dz
		end
  
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
	  end
	end
  end)


  
  function admin_mode_fantome()
    invisible = not invisible
  
    if invisible then
      local plyped = GetPlayerPed(-1)
      SetEntityVisible(plyPed, false, false)
    else
      SetEntityVisible(plyPed, true, false)
    end
  end

  function admin_tp_toplayer()
    local plyId = Keyboardput("ID DU JOUEUR", "ID", 15)
  
    if plyId ~= nil then
      plyId = tonumber(plyId)
      
      if type(plyId) == 'number' then
        local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
        SetEntityCoords(plyPed, targetPlyCoords)
      end
    end
  end

function admin_vehicle_repair()
  local plyPed = PlayerPedId()
	local car = GetVehiclePedIsIn(plyPed, false)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end

function admin_tp_pos()
	local pos = Keyboardput("X Y Z", nil, 15)
  local plyPed = PlayerPedId()

	if pos ~= nil and pos ~= '' then
		local _, _, x, y, z = string.find(pos, '([%d%.]+) ([%d%.]+) ([%d%.]+)')
				
		if x ~= nil and y ~= nil and z ~= nil then
			SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
		end
	end
end

function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(0)
		end

		ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', '~b~Tp ~g~Effectuer', 'CHAR_TREVOR', 3)
	else
		ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', '~b~Marker Non ~r~Définis', 'CHAR_TREVOR', 3)
	end
end


function FullVehicleBoost()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		SetVehicleModKit(vehicle, 0)
		SetVehicleMod(vehicle, 14, 0, true)
		SetVehicleNumberPlateTextIndex(vehicle, 5)
		ToggleVehicleMod(vehicle, 18, true)
		SetVehicleColours(vehicle, 0, 0)
		SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
		SetVehicleModColor_2(vehicle, 5, 0)
		SetVehicleExtraColours(vehicle, 111, 111)
		SetVehicleWindowTint(vehicle, 2)
		ToggleVehicleMod(vehicle, 22, true)
		SetVehicleMod(vehicle, 23, 11, false)
		SetVehicleMod(vehicle, 24, 11, false)
		SetVehicleWheelType(vehicle, 12) 
		SetVehicleWindowTint(vehicle, 3)
		ToggleVehicleMod(vehicle, 20, true)
		SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
		LowerConvertibleRoof(vehicle, true)
		SetVehicleIsStolen(vehicle, false)
		SetVehicleIsWanted(vehicle, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetCanResprayVehicle(vehicle, true)
		SetPlayersLastVehicle(vehicle)
		SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleTyresCanBurst(vehicle, false)
		SetVehicleWheelsCanBreak(vehicle, false)
		SetVehicleCanBeTargetted(vehicle, false)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		SetVehicleHasStrongAxles(vehicle, true)
		SetVehicleDirtLevel(vehicle, 0)
		SetVehicleCanBeVisiblyDamaged(vehicle, false)
		IsVehicleDriveable(vehicle, true)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleStrong(vehicle, true)
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
		SetPedRagdollOnCollision(PlayerPedId(), false)
		ResetPedVisibleDamage(PlayerPedId())
		ClearPedDecorations(PlayerPedId())
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
        SetVehicleNumberPlateText("Dev")
		for i = 0,14 do
			SetVehicleExtra(veh, i, 0)
		end
		SetVehicleModKit(veh, 0)
		for i = 0,49 do
			local custom = GetNumVehicleMods(veh, i)
			for j = 1,custom do
                SetVehicleMod(veh, i, math.random(1,j), 1)
			end
		end
	end
end

-- GIVE DE L'ARGENT
function admin_give_money()
	local amount = Keyboardput("Money Cash", "Money", 15)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('esx_menu:Admin_Cash', amount)
		end
	end
end

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	local amount = Keyboardput("Money Bank", "Money", 15)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('esx_menu:Admin_Bank', amount)
		end
	end
end

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	local amount = Keyboardput("Money Sale", "Money", 15)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('esx_menu:Admin_DirtyMoney', amount)
		end
	end
end


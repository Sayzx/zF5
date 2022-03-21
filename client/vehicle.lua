ESX = nil

StateEngine = true
DisplayStateEngine = "~g~Allumé"
local door, opened, BaseSpeedLimit, ActualSpeedLimit = 1, {}, 1, "~g~Indéfinie"
local LimitList, LimitSpeedList = {}, {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function LoadLimitList()
    LimitList = LimitSpeedList
end

CreateThread(function()
    local tempnumber = 0
    while tempnumber ~= 200 do
        Wait(0)
        tempnumber = tempnumber + 1
        LimitSpeedList[tempnumber] = {Name = tempnumber, Value = tempnumber}
    end

    LoadLimitList()

    while true do 
        Wait(1)
        
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsUsing(ped)

        if StateEngine then
            DisplayStateEngine = "~g~Allumé"
            SetVehicleEngineOn(vehicle, true, false, true)
        else
            DisplayStateEngine = "~r~Éteint"
            SetVehicleEngineOn(vehicle, false, false, true)
        end
    end
end)


opennedVehMainMenu = false
local MainVehMenu = RageUI.CreateMenu("Gestion Voiture", "Gestion Voiture")
MainVehMenu.Closed = function()
    opennedVehMainMenu = false
    LimitList =  {}
end
local SpeedLimitMenu = RageUI.CreateSubMenu(MainVehMenu, Config.Text["SpeedLimitMenu"], Config.Text["SpeedLimitMenuSub"])
SpeedLimitMenu.Closed = function()
    LimitList =  {}
end



RegisterKeyMapping("OpenVehMainMenu", "Ouvrir votre menu gestions véhicule", 'keyboard', 'F10')

RegisterCommand("OpenVehMainMenu", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)

    local InVehicule = IsVehicleSeatFree(vehicle, 1)

    if InVehicule then 
        OpenVehMainMenuInVehicule()
    end
end)

function OpenVehMainMenuInVehicule()
    if opennedVehMainMenu then
        opennedVehMainMenu = false
        RageUI.Visible(MainVehMenu, false)
    else
        opennedVehMainMenu = true
        RageUI.Visible(MainVehMenu, true)

        LoadLimitList()

        CreateThread(function()
            local tempnumber = 0

            while opennedVehMainMenu do
                Wait(1)

                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsUsing(ped)

                local InVehicule = IsPedSittingInAnyVehicle(ped)

                if InVehicule then

                    RageUI.IsVisible(MainVehMenu, function()
                        RageUI.Separator("↓ ~b~"..Config.Text["NameMain"].."~s~ ↓")

                        RageUI.Separator("↓ Moteur ↓")
                        RageUI.Checkbox("Status Moteur : "..DisplayStateEngine, "Gérer le status de votre moteur", StateEngine, {RightLabel = ""}, {
                            onChecked = function()
                                StateEngine = true
                            end,
                            onUnChecked = function()
                                StateEngine = false
                            end
                        })

                        RageUI.Separator("↓ ~b~Portes~s~ ↓")
                        RageUI.List("Ouvrir :", Config.Doors, door, "Ouvrir la porte selectioné", {}, true, {
                            onListChange = function(Index)
                                door = Index;
                            end,

                            onSelected = function(Index)

                                if Index == 1 then
                                    if not Config.DoorsStatus.opennedBeforeDoorLeft then
                                        Config.DoorsStatus.opennedBeforeDoorLeft = true
                                        Config.DoorsStatus.closedBeforeDoorLeft = false
                                        SetVehicleDoorOpen(vehicle, 0, false, false)
                                    elseif not closedBeforeDoorLeft then
                                        Config.DoorsStatus.closedBeforeDoorLeft = true
                                        Config.DoorsStatus.opennedBeforeDoorLeft = false
                                        SetVehicleDoorShut(vehicle, 0, false)
                                    end
                                end

                                if Index == 2 then
                                    if not Config.DoorsStatus.opennedBeforeDoorRight then
                                        Config.DoorsStatus.opennedBeforeDoorRight = true
                                        Config.DoorsStatus.closedBeforeDoorRight = false
                                        SetVehicleDoorOpen(vehicle, 1, false, false)
                                    elseif not Config.DoorsStatus.closedBeforeDoorRight then
                                        Config.DoorsStatus.closedBeforeDoorRight = true
                                        Config.DoorsStatus.opennedBeforeDoorRight = false
                                        SetVehicleDoorShut(vehicle, 1, false)
                                    end
                                end

                                if Index == 3 then
                                    if not Config.DoorsStatus.opennedBackDoorLeft then
                                        Config.DoorsStatus.opennedBackDoorLeft = true
                                        Config.DoorsStatus.closedBackDoorLeft = false
                                        SetVehicleDoorOpen(vehicle, 2, false, false)
                                    elseif not Config.DoorsStatus.closedBackDoorLeft then
                                        Config.DoorsStatus.closedBackDoorLeft = true
                                        Config.DoorsStatus.opennedBackDoorLeft = false
                                        SetVehicleDoorShut(vehicle, 2, false)
                                    end
                                end

                                if Index == 4 then
                                    if not Config.DoorsStatus.opennedBackDoorRight then
                                        Config.DoorsStatus.opennedBackDoorRight = true
                                        Config.DoorsStatus.closedBackDoorRight = false
                                        SetVehicleDoorOpen(vehicle, 3, false, false)
                                    elseif not Config.DoorsStatus.closedBackDoorRight then
                                        Config.DoorsStatus.closedBackDoorRight = true
                                        Config.DoorsStatus.opennedBackDoorRight = false
                                        SetVehicleDoorShut(vehicle, 3, false)
                                    end 
                                end

                                if Index == 5 then
                                    if not Config.DoorsStatus.opennedCapot then
                                        Config.DoorsStatus.opennedCapot = true
                                        Config.DoorsStatus.closedCapot = false
                                        SetVehicleDoorOpen(vehicle, 4, false, false)
                                    elseif not closedCapot then
                                        Config.DoorsStatus.closedCapot = true
                                        Config.DoorsStatus.opennedCapot = false
                                        SetVehicleDoorShut(vehicle, 4, false)
                                    end 
                                end

                                if Index == 6 then
                                    if not Config.DoorsStatus.opennedCoffre then
                                        Config.DoorsStatus.opennedCoffre = true
                                        Config.DoorsStatus.closedCoffre = false
                                        SetVehicleDoorOpen(vehicle, 5, false, false)
                                    elseif not Config.DoorsStatus.closedCoffre then
                                        Config.DoorsStatus.closedCoffre = true
                                        Config.DoorsStatus.opennedCoffre = false
                                        SetVehicleDoorShut(vehicle, 5, false)
                                    end 
                                end
                            end
                        })
                        RageUI.Separator("↓ ~o~Gestions Vitesse ~s~↓")
                        RageUI.Button(Config.Text["SpeedLimitMenu"], Config.Text["SpeedLimitMeuSub"], {RightLabel = "→→"}, true, {}, SpeedLimitMenu)
                    end)

                    RageUI.IsVisible(SpeedLimitMenu, function()
                        RageUI.Separator("↓ ~b~"..Config.Text["SpeedLimitMenu"].." ↓")
                        RageUI.Separator("↓ ~b~"..Config.Text["AnonceSpeedLimit"]..ActualSpeedLimit.." ↓")

                        if ActualSpeedLimit ~= "~g~Indéfinie" then
                            RageUI.Separator("")
                            RageUI.Separator(Config.Text["DisableDesc"])
                            RageUI.Button(Config.Text["Disable"], Config.Text["DisableDesc"], {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    ActualSpeedLimit = "~g~Indéfinie"
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
                                end
                            })
                            RageUI.Separator("")
                        else
                            RageUI.Separator("")
                            RageUI.List(Config.Text["SpeedLimitName"], LimitList, BaseSpeedLimit, Config.Text["SpeedLimitDesc"], {RightLabel = ""}, true, {
                                onListChange = function(Index)
                                    BaseSpeedLimit = Index
                                end,

                                onSelected = function(Index)
                                    ActualSpeedLimit = Index
                                    ESX.ShowNotification("Votre limitateur de Vitesse a été définie sur "..ActualSpeedLimit)
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), ActualSpeedLimit/3.7)
                                end
                            })
                            RageUI.Button(Config.Text["NewValue"], Config.Text["NewValueDesc"], {RightLabel = "→→"}, true, {
                                onSelected = function()

                                    local NewValue = Keyboardput("Selectioner la valeur de votre vitesse", nil, 5)
                                    if NewValue <= "200" or NewValue > "0" then
                                        ActualSpeedLimit = NewValue
                                        ESX.ShowNotification("Votre limitateur de Vitesse a été définie sur "..ActualSpeedLimit)
                                        SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), ActualSpeedLimit/3.7)
                                    else
                                        ESX.ShowNotification("Value invalid")
                                    end
                                end
                            })
                            RageUI.Separator("")
                        end
                    end)
                else
                    RageUI.CloseAll()
                    opennedVehMainMenu = false
                    LimitList =  {}
                end
            end
        end)
    end
end

function Keyboardput(TextEntry, ExampleText, MaxStringLength) -- Menu pour entrer une valeur string
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
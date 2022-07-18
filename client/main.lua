ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.InitBossESX, function(obj) ESX = obj end)
        Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

local Style = {
    Line = { 0, 0, 255, 70 }
}
local newsStyle = Style

personalmenu = {}
local PlayerGroup = "user"
local CanOpenAdmin = false
local AdminStatuMode = "Désactiver"
local Index = {}
local menumap = true
local billing = {}


isMenuOpen = false
local F5MainMenu = RageUI.CreateMenu("", "dsc.gg/zdev",0, 0, 'banner', 'interaction_bgd')
F5MainMenu.Closed = function()
    isMenuOpen = false
    ESX.TriggerServerCallback("zF5:server:getGroup", function(group) 
        PlayerGroup = group
        if PlayerGroup ~= "user"then 
            CanOpenAdmin = true
        end
    end)
end


-- Inventaire
local F5InvetoryMenu = RageUI.CreateSubMenu(F5MainMenu, "", "Inventaire",0, 0, 'banner', 'interaction_bgd')

-- Portefeuille
local F5WalletMenu = RageUI.CreateSubMenu(F5MainMenu, "", "Voici votre portefeuille",0, 0, 'banner', 'interaction_bgd')
local F5WalletDropMenu = RageUI.CreateSubMenu(F5WalletMenu, "", "Drop",0, 0, 'banner', 'interaction_bgd')
local F5WalletDropSaleMenu = RageUI.CreateSubMenu(F5WalletMenu, "", "Drop Sale", 0, 0, 'banner', 'interaction_bgd')
local F5BillingMenu = RageUI.CreateSubMenu(F5WalletMenu, "", "Voici une liste de vos Factures",0, 0, 'banner', 'interaction_bgd')

-- Divers
local F5DiversMenu = RageUI.CreateSubMenu(F5MainMenu, "", "Menu Divers",0, 0, 'banner', 'interaction_bgd')

-- Admin
local F5AdminMenu =  RageUI.CreateSubMenu(F5MainMenu, "", "Mode Administration ~y~zDev",0, 0, 'banner', 'interaction_bgd')

-- Gestion
local F5EntrepriseMenu =  RageUI.CreateSubMenu(F5MainMenu, "", "~y~zDev",0, 0, 'banner', 'interaction_bgd')
local F5GangsMenu =  RageUI.CreateSubMenu(F5MainMenu, "", "~y~zDev", 0, 0, 'banner', 'interaction_bgd')


RegisterKeyMapping("saydev", "Ouvrir votre menu personel", "keyboard", "F5") -- Changer la touche du Menu


function OpenNewsF5Menu()
    if isMenuOpen then
        isMenuOpen = false
        RageUI.Visible(F5MainMenu, false)
    else 
        isMenuOpen = true 
        OpenF5Menu = 1
        RageUI.Visible(F5MainMenu, true)
        CreateThread(function()

            ESX.TriggerServerCallback('zF5:Bill_getBills', function(bills)
                billing = bills
                ESX.PlayerData = ESX.GetPlayerData()
            end)

            invItem = {}
            local invCount = {}
            
            ESX.TriggerServerCallback('zF5:GetMoney',function(money)
                ArgentBanque = money
            end)

            ESX.TriggerServerCallback("zF5:server:getGroup", function(group) 
                PlayerGroup = group
                if PlayerGroup ~= "user" then 
                    CanOpenAdmin = true
                elseif PlayerGroup == "user" then
                    CanOpenAdmin = false
                end
            end)


            while isMenuOpen do
                Wait(interval)



                RageUI.IsVisible(F5MainMenu, function()
                    RageUI.Separator("~r~↓ ~b~zDev - F5  ~r~↓")
                    RageUI.Button("~b~→→ ~s~Inventaire", "Inventaire", {RightLabel = "→→"}, true, {}, F5InvetoryMenu)
                    RageUI.Button("~b~→→ ~s~Portefeuille", "Portefeuille", {RightLabel = "→→"}, true, {}, F5WalletMenu)
                    if Config.Emplacement.Factures == "Main" then
                        RageUI.Button("~b~→→ ~s~Factures", "Factures", {RightLabel = "→→"}, true, {
                            onSelected = function()
                                
                            end
                        }, F5BillingMenu)
                    end
                    
                    
                    
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
                        RageUI.Button("~b~→→ ~s~Gestion Entreprise", "Divers", {RightLabel = "→→"}, true, {}, F5EntrepriseMenu)
                     end
                    
                    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == "boss" then
                        RageUI.Button("~b~→→ ~s~Gestion Organisation", "Divers", {RightLabel = "→→"}, true, {}, F5GangsMenu)
                     end
                    
                     local ped = PlayerPedId()
                     local vehicle = GetVehiclePedIsUsing(ped)
 
                     local InVehicule = IsPedSittingInAnyVehicle(ped)
 
                     if InVehicule then 
                         RageUI.Button("~b~→→ ~s~Action Véhicule", "Divers", {RightLabel = "→→"}, true, {
                             onSelected = function()
                                 RageUI.CloseAll()
                                 isMenuOpen = false
 
                                 local vehicle = GetVehiclePedIsUsing(ped)
 
                                 local InVehicule = IsPedSittingInAnyVehicle(ped)
 
                                 if InVehicule then 
                                     OpenVehMainMenuInVehicule()
                                 end
                             end
                         })
 
                     end
                   
                    RageUI.Button("~b~→→ ~s~Divers", "Divers", {RightLabel = "→→"}, true, {}, F5DiversMenu)                 
                    RageUI.Button("~g~→→ ~r~Administration", "Divers", {RightLabel = "→→"}, CanOpenAdmin, {}, F5AdminMenu)
                end)
                
                RageUI.IsVisible(F5InvetoryMenu, function()
                    ESX.TriggerServerCallback("zF5:server:getInventory", function(InventaireJoueur) 
                        InventoryPlayer = InventaireJoueur
                    end)

                    for i=1, #ESX.PlayerData.inventory, 1 do
                        local count = ESX.PlayerData.inventory[i].count
                
                        if count > 0 then
                            local label	    = ESX.PlayerData.inventory[i].label
                            local count	    = ESX.PlayerData.inventory[i].count
                            local value	    = ESX.PlayerData.inventory[i].name
                            local usable	= ESX.PlayerData.inventory[i].usable
                            local canRemove = ESX.PlayerData.inventory[i].canRemove
                            local quantity  = index
                
                            invCount = {}

                            for i = 1, count, 1 do
                                table.insert(invCount, i)
                            end
                            
                            table.insert(invItem, value)

                            if Index[i] == nil then
                                Index[i] = 1
                            end
                            
                            if usable then
                                RageUI.List("~b~→→ ~s~"..label.." ("..count..")", {"Utiliser", "Donner", "Jeter"}, Index[i], "Inventaire", {}, true, {
                                    onListChange = function(IndexList) 
                                        Index[i] = IndexList
                                    end,
                                    onSelected = function(Index)
                                        if Index == 1 then -- UTILISER UN ITEM
                                            if usable then
                                                TriggerServerEvent('esx:useItem', value)
                                            else
                                                ESX.ShowNotification(label.." n'est pas utilisable")
                                            end
                                        elseif Index == 2 then -- DONNER UN ITEM
                                            local foundPlayers = false
                                            personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
        
                                            if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
                                                foundPlayers = true
                                            end
        
                                            if foundPlayers == true then
                                                local closestPed = GetPlayerPed(personalmenu.closestPlayer)
                                                quantity = Keyboardput("Quantité", 0, 10)
                                
                                                    if quantity ~= nil and count > 0 then
                                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_standard', value, tonumber(quantity))
                                                        RageUI.CloseAll()
                                                    else
                                                        ESX.ShowNotification("Montant invalide")
                                                    end
                                        
                                            else
                                                ESX.ShowNotification("Vous n'avez personne autours de vous")
                                            end
                                        elseif Index == 3 then-- JETTER UN ITEM 
                                            if canRemove then
                                                if not IsPedSittingInAnyVehicle(plyPed) then
                                                    quantity = Keyboardput("Quantité", 0, 10)
                                                    if quantity ~= nil then
                                                        
                                                        TriggerServerEvent('esx:removeInventoryItem', 'item_standard', value, tonumber(quantity))
                                                       
                                                    else
                                                        ESX.ShowNotification("Montant invalide")
                                                    end
                                                else
                                                    ESX.ShowNotification("Vous ne pouvez jetter '"..label.."' en voiture")
                                                end
                                            else
                                                ESX.ShowNotification(label.." n'est pas jetable !")
                                            end
                                        end  
                                    end
                                })
                            else
                                RageUI.List("~b~→→ ~s~"..label.." ("..count..")", {"Donner", "Jeter"}, Index[i], "Inventaire", {}, true, {
                                    onListChange = function(IndexList) 
                                        Index[i] = IndexList
                                    end,
                                    onSelected = function(Index)
                                        if Index == 1 then -- DONNER UN ITEM
                                            local foundPlayers = false
                                            personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
        
                                            if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
                                                foundPlayers = true
                                            end
        
                                            if foundPlayers == true then
                                                local closestPed = GetPlayerPed(personalmenu.closestPlayer)
        
                                                
                                                    if quantity ~= nil and count > 0 then
                                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_standard', value, tonumber(quantity))
                                                        RageUI.CloseAll()
                                                    else
                                                        ESX.ShowNotification("Montant invalide")
                                                    end
                                                                                      else
                                                ESX.ShowNotification("Vous n'avez personne autours de vous")
                                            end
                                        elseif Index == 2 then-- JETTER UN ITEM 
                                            if canRemove then
                                                if not IsPedSittingInAnyVehicle(plyPed) then
                                                    quantity = Keyboardput("Quantité", 0, 10)
                                                    if quantity ~= nil then
                                                        
                                                        TriggerServerEvent('esx:removeInventoryItem', 'item_standard', value, tonumber(quantity))
                                                    
                                                    else
                                                        ESX.ShowNotification("Montant invalide")
                                                    end
                                                else
                                                    ESX.ShowNotification("Vous ne pouvez jetter '"..label.."' en voiture")
                                                end
                                            else
                                                ESX.ShowNotification(label.." n'est pas jetable !")
                                            end
                                        end  
                                    end
                                })
                            end
                        end
                    end
                    
                end)

                RageUI.IsVisible(F5WalletMenu, function()
                    RageUI.Separator("~r~↓ ~g~Portefeuille ~r~↓")
                    local job1 = ESX.PlayerData.job.label
                    local jobgrade = ESX.PlayerData.job.grade_label
                    local job2 = ESX.PlayerData.job2.label
                    local job2grade = ESX.PlayerData.job2.grade_label
                    RageUI.Separator("~r~>  Emploie : ~b~"..job1.." "..jobgrade)
                    RageUI.Separator("~r~>  Organisation : ~b~"..job2.." "..job2grade)
                    RageUI.Button('Liquide : ', nil, {RightLabel = "~g~$"..ESX.Math.GroupDigits(ESX.PlayerData.money.."~s~ →")}, true, {}, F5WalletDropMenu)
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'bank' then
                            RageUI.Button('Banque : ', nil, {RightLabel = "~b~$"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money).."~s~ →"}, true, {})  
                        end
                        if ESX.PlayerData.accounts[i].name == 'black_money' then
                            RageUI.Button('Argent Sale : ', nil, {RightLabel = "~r~$"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money).."~s~ →"}, true, {}, F5WalletDropSaleMenu)  
                        end
                    end
                    RageUI.Button("~b~→→ ~s~Facture", nil, {RighLabel = "→→"}, true, {}, F5BillingMenu)
                    RageUI.Button("~b~→→ ~s~Regarder sa ~g~carte d\'identité", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                        end
                    })
                    RageUI.Button("~b~→→ ~s~Montrer sa ~g~Carte d\'identité", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                            else
                                ESX.ShowNotification('Aucun joueur ~r~proche !')
                            end
                        end
                    })
                    RageUI.Button("~b~>> ~s~Regarder son  ~o~Permis de conduire", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                        end
                    })

                    RageUI.Button("~b~>> ~s~Montrer son  ~o~Permis de conduire", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                            else
                                ESX.ShowNotification('Aucun joueur ~r~proche !')
                            end
                        
                        end
                    })
                    RageUI.Button("~b~>> ~s~Regarder son  ~r~Permis de port d\'armes", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                        end
                    }) 

                    RageUI.Button("~b~>> ~s~Montrer son  ~r~Permis de port d\'armes", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
                            else
                                ESX.ShowNotification('Aucun joueur ~r~proche !')
                            end
                        end
                    }) 
                end)

                RageUI.IsVisible(F5BillingMenu, function()

                    if #billing == 0 then
                        RageUI.Button("Aucune facture", nil, { RightLabel = "" }, true,{} )
                    end
                        
                    for i = 1, #billing, 1 do
                        RageUI.Button(billing[i].label, nil, {RightLabel = '[~b~$' .. ESX.Math.GroupDigits(billing[i].amount.."~s~] →")}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('esx_billing:payBill', function()
                                    ESX.TriggerServerCallback('zF5:Bill_getBills', function(bills) billing = bills end)
                                end, billing[i].id)
                            end
                        })
                    end
                    RageUI.Separator("~g~Facture")
                end)


                RageUI.IsVisible(F5GangsMenu, function()
                    RageUI.Separator("~r~ Gestion Organisation")
                    RageUI.Separator("~o~"..ESX.PlayerData.job2.grade_label.." - ~g~"..ESX.PlayerData.job2.label)
                    RageUI.Separator("")
                    RageUI.Button("~b~>> ~s~Recruter un ~g~Joueur", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('Aucun joueur proche')
                                else
                                    TriggerServerEvent('zF5:Boss_recruterplayer2', GetPlayerServerId(closestPlayer))
                                    
                                end
                            else
                                ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end

                        end
                    })
                    RageUI.Button("~b~>> ~r~Virer un ~s~Joueur", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('Aucun joueur proche')
                                else
                                    TriggerServerEvent('zF5:Boss_virerplayer2', GetPlayerServerId(closestPlayer))
                                end
                            else
                                ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end
                        end
                    })
                    
                    RageUI.Button("~b~>> ~o~Rank un ~s~Joueur", nil, {RighLabel = "→"}, true, {
                        onSelected = function() 
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                        ESX.ShowNotification('Aucun joueur proche')
                                else
                                        TriggerServerEvent('zF5:Boss_promouvoirplayer2', GetPlayerServerId(closestPlayer))
                                end
                            else
                                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end
                        end
                    })
                        
                     RageUI.Button("~b~>> ~r~UnRank un ~s~Joueur", nil, {RighLabel = "→"}, true, {
                        onSelected = function() 
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
           
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                        ESX.ShowNotification('Aucun joueur proche')
                                else
                                   TriggerServerEvent('zF5:Boss_destituerplayer2', GetPlayerServerId(closestPlayer))
                                end
                            else
                                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end
                        end
                    })
                                          
                end)
                
                RageUI.IsVisible(F5EntrepriseMenu, function()
                    RageUI.Separator("~r~ Gestion Entreprise")
                    RageUI.Separator("~y~Societé : ~r~"..ESX.PlayerData.job.label.." - "..ESX.PlayerData.job.grade_label)
                    RageUI.Separator("")
                    RageUI.Button("~b~>> ~s~Recruter un ~g~Joueur", nil, {RighLabel = "→"}, true, {
                    onSelected = function()
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer == -1 or closestDistance > 3.0 then
                            ESX.ShowNotification('Aucun joueur proche')
                        else
                            TriggerServerEvent('zF5:Boss_recruterplayer', GetPlayerServerId(closestPlayer))
                            
                        end
                    else
                        ESX.ShowNotification('Vous n\'avez pas les ~r~droits~s~')
                    end  
                        end})
                    RageUI.Button("~b~>> ~r~Virer ~s~un Joueur", nil, {RighLabel = "→"}, true, {
                    onSelected = function()
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('Aucun joueur proche')
                            else
                                TriggerServerEvent('zF5:Boss_virerplayer', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                        end
                    end})

                    RageUI.Button("~b~>> ~o~Rank ~s~le Joueur", nil, {RighLabel = "→"}, true, {
                        onSelected = function()
                            if ESX.PlayerData.job.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('Aucun joueur proche')
                                else
                                    TriggerServerEvent('zF5:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
                            end
                            else
                                ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end
                        
                        end})
                
                        RageUI.Button("~b~>> ~r~DeRank ~s~le Joueur", nil, {RighLabel = "→"}, true, {
                            onSelected = function()
                                if ESX.PlayerData.job.grade_name == 'boss' then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                
                                    if closestPlayer == -1 or closestDistance > 3.0 then
                                            ESX.ShowNotification('Aucun joueur proche')
                                        else
                                        TriggerServerEvent('zF5:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
                                            end
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                                        end
                        end})
                end)

                RageUI.IsVisible(F5DiversMenu, function()

                    RageUI.Separator("~g~Actions Diverses")
                    RageUI.Checkbox("~b~→→  ~s~Afficher / Désactiver la map", nil, menumap, {RighLabel = ""}, { 
                        onChecked = function()
                            menumap = true
                            DisplayRadar(true)
                        end,
                        onUnChecked = function()
                            menumap = false
                            DisplayRadar(false)
                        end
                    })

                    RageUI.Button("~b~→→ ~s~Tomber", "Ragdoll", {RightLabel = "→→"}, true, {
                        onSelected = function()
                            ragdolling = not ragdolling
                            RageUI.CloseAll()
                            isMenuOpen = false
                            while ragdolling do
                                Wait(0)
                                local myPed = GetPlayerPed(-1)
                                SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                                ResetPedRagdollTimer(myPed)
                                AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~Réveillé'))
                                DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                                ResetPedRagdollTimer(myPed)
                                if IsControlJustPressed(0, 22) then 
                                    ragdolling = false
                                end
                            end
                        end
                    }) 

                    RageUI.Button("~b~→→  ~s~Faire un Tweet", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            tweetraison = Keyboardput("Ecrire votre message dans twitter", "", 200)
                            TriggerServerEvent("twt:send", tweetraison, GetPlayerName(PlayerId()))
                        end
                    })

                    RageUI.Button("~b~→→  ~s~Voir ton ID", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            ESX.ShowAdvancedNotification('~g~zF5', '~r~ID', 'Ton ID : '.. GetPlayerServerId(PlayerId()), 'CHAR_TREVOR', 3)
                        end
                    })

                

                RageUI.Button("~b~→→  ~s~Notre Discord", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        ESX.ShowAdvancedNotification('~g~zF5', '~p~Discord', 'dsc.gg/zdev : ', 'CHAR_TREVOR', 3)
                    end
                })

            end)


                

                RageUI.IsVisible(F5WalletDropMenu, function()
                    RageUI.Separator("~r~------------------------------------")
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        RageUI.Button("Donner", nil, {RightLabel = "→→"}, true, {
                            onSelected = function() 
                                local quantity = Keyboardput("Somme d'argent que vous voulez donner", '', 25)
                                if tonumber(quantity) then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)
                                        if not IsPedSittingInAnyVehicle(closestPed) then
                                            TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', 'rien', tonumber(quantity))
                                        else
                                            ESX.ShowNotification('Vous ne pouvez pas donner de l\'argent dans un véhicles')
                                        end
                                    else
                                        ESX.ShowNotification('Aucun joueur proche !')
                                    end
                                else
                                    ESX.ShowNotification('Somme invalid')
                                end
                            end
                        })
                    else
                        RageUI.Button("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                    end
                end)

                RageUI.IsVisible(F5WalletDropSaleMenu, function()
                    RageUI.Separator("~r~------------------------------------")
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestDistance ~= -1 and closestDistance <= 3 then
                    RageUI.Button("Donner", nil, {RightLabel = "→→"}, true, {
                        onSelected = function() 
                            local quantity = Keyboardput("Somme d'argent que vous voulez donner", '', 25)
                            if tonumber(quantity) then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
                                    if not IsPedSittingInAnyVehicle(closestPed) then
                                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', 'black_money', tonumber(quantity))
                                    else
                                        ESX.ShowNotification('Vous ne pouvez pas donner de l\'argent dans un véhicles')
                                    end
                                else
                                    ESX.ShowNotification('Aucun joueur proche !')
                                end
                            else
                                ESX.ShowNotification('Somme invalid')
                            end
                        end
                    })
                    else
                        RageUI.Button("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                    end
                end)

                RageUI.IsVisible(F5AdminMenu, function() 
                    zName = "user"
                    if PlayerGroup == "superadmin" then
                        zName = "Owner"
                    end
                    if PlayerGroup == "admin" or PlayerGroup == "mod" then
                        zName = "Staff"
                    end
                    local zSteam = GetPlayerName(PlayerId())
                    RageUI.Separator("~r~↓ ~g~ Menu Administration ~r~↓")
                    RageUI.Separator("~h~"..zSteam.."~h~ ~b~Grade : "..zName)
                    RageUI.Separator("~g~↓ ~r~ Intéraction Perso ~g~↓")


                    RageUI.Checkbox("~b~→→ ~s~ NoClip : ", "Démarer Votre Session Admin", StateNoClip, {RightLabel = ""}, {
                        onChecked = function()
                            StateNoClip = true
                            zNoClip()
                        end,
                        onUnChecked = function()
                            StateNoClip = false
                            zNoClip()
                        end
                    })

                    local StateGhost = false
                    RageUI.Checkbox("~b~→→ ~s~ Invisible : ", "Démarer Votre Session Admin", StateNo, {RightLabel = ""}, {
                        onChecked = function()
                            zInvinsible()
                            StateNo = true
                            ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'Invisibilitée ~g~ON', 'CHAR_TREVOR', 3)
                        end,
                        onUnChecked = function()
                            StateNo = false
                            zInvinsible()
                            ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'Invisibilitée ~r~OFF', 'CHAR_TREVOR', 3)
                    end})

                    RageUI.Button("~b~→→ ~s~Téléportation Position", "Vroom", {RightLabel = "→→"}, CanOpenAdmin, {
                        onSelected = function()
                            admin_tp_pos()
                            ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', '~b~TpPosition ~g~Effectuer', 'CHAR_TREVOR', 3)
                    end})

                    RageUI.Button("~b~→→ ~s~Téléportation Marker", "TP Marker", {RightLabel = "→→"}, CanOpenAdmin, {
                        onSelected = function()
                            admin_tp_marker()
                        end})

                    RageUI.Button("~b~→→ ~s~Revive un Joueur", "Revive", {RightLabel = "→→"}, CanOpenAdmin, {
                        onSelected = function()
                            ids = Keyboardput("ID DU JOUEUR", "ID", 15)
                            ExecuteCommand("revive "..ids)
                            ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', '~b~TpPosition ~g~Effectuer', 'CHAR_TREVOR', 3)
                    end})
                        RageUI.Separator("~g~↓ ~r~ Intéraction Money ~g~↓")

                    
                    RageUI.Button("~b~→→ ~s~Give Cash", "Vroom", {RightLabel = "→→"}, CanOpenAdmin, {
                        onSelected = function()
                            admin_give_money()
                        end
                    })

                    RageUI.Button("~b~→→ ~s~Give Banque", "Vroom", {RightLabel = "→→"}, CanOpenAdmin, {
                        onSelected = function()
                            admin_give_bank()
                        end
                    })

                    RageUI.Button("~b~→→ ~s~Give Sale", "Vroom", {RightLabel = "→→"}, CanOpenAdmin, {
                        onSelected = function()
                            admin_give_dirty()
                        end
                    })

                    RageUI.Separator("~g~↓ ~r~ Options Véhicules ~g~↓")
                    
                    RageUI.Button("~b~→→ ~s~Custom Voitures", "Vroom", {RightLabel = "→→"}, CanOpenAdmin, {
                        onSelected = function()
                            FullVehicleBoost()
                            ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'Véhicule ~g~Booster', 'CHAR_TREVOR', 3)
                        end
                    })

                    
                    RageUI.Button("~b~→→ ~s~Réparer Véhicule", "Réparation Voiture", {RightLabel = "→→"}, CanOpenAdmin, {
                    onSelected = function()
                        admin_vehicle_repair()
                        ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'Véhicule ~g~Réparé', 'CHAR_TREVOR', 3)
                        end
                    })
                    
                    RageUI.Button("~b~→→ ~s~ Supression Véhicule ", "Suprimé un véhicle autour", {RightLabel = "→→"}, true, {
                    onSelected = function()
                        ExecuteCommand("dv")
                        ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'Voiture ~r~Delete', 'CHAR_TREVOR', 3)

                        end
                    })
                    
                    RageUI.Button("~b~→→ ~s~ Spawn Véhicule ", "Faire Spawn une voitre", {RightLabel = "→→"}, true, {
                        onSelected = function()
                            carname = Keyboardput("Nom de la voiture", nil, 15)
                            ExecuteCommand("car "..carname)
                            ESX.ShowAdvancedNotification('~g~zF5', '~r~Modération', 'Véhicule ~g~Spawn', 'CHAR_TREVOR', 3)
                        end
                    })
                end)
            end
        end)
    end
end



RegisterCommand("saydev", function() OpenNewsF5Menu() end)
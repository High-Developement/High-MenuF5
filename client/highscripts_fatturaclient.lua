if GetCurrentResourceName() ~= 'High-MenuF5' then
    return
end

ESX = exports.es_extended:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function OpenBillingMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = "Invia Fattura", value = "send_bill"},
        {label = "Fatture", value = "guardafatture"}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing_menu', {
        title = 'Gestione Fatture',
        align = 'left-top',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'send_bill' then
            if ConfigHighScripts.Job2 == false then
                if ESX.PlayerData.job and ESX.PlayerData.job.name ~= ConfigHighScripts.jobDisocuppato then
                    OpenSendBillMenu()
                else
                    ESX.ShowNotification('Non puoi mandare fatture da disoccupato!')
                end
            else
                if ESX.PlayerData.job2 and ESX.PlayerData.job2.name ~= ConfigHighScripts.jobDisocuppato then
                    OpenSendBillMenu()
                else
                    ESX.ShowNotification('Non puoi mandare fatture da disoccupato!')
                end
            end
        end

        if data.current.value == 'guardafatture' then
            OpenUnpaidBillsMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenSendBillMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing_target', {
        title = 'Inserisci ID del giocatore',
        align = 'left-top',
    }, function(data1, menu1)
        local playerId = tostring(data1.value)

        if playerId == nil or playerId == '' then
            ESX.ShowNotification('ID non valido')
        else
            menu1.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing_amount', {
                title = 'Inserisci l\'importo'
            }, function(data2, menu2)
                local amount = tonumber(data2.value)

                if amount == nil or amount <= 0 then
                    ESX.ShowNotification('Importo non valido')
                else
                    menu2.close()
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing_label', {
                        title = 'Inserisci la descrizione'
                    }, function(data3, menu3)
                        local label = tostring(data3.value)

                        if label == nil or label == '' then
                            ESX.ShowNotification('Descrizione non valida')
                        else
                            TriggerServerEvent('highscripts:sendBill', playerId, "job", label, amount)
                            ESX.ShowNotification('Fattura inviata con successo')
                            menu3.close()
                        end
                    end, function(data3, menu3)
                        menu3.close()
                    end)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data1, menu1)
        menu1.close()
    end)
end

function OpenUnpaidBillsMenu()
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('highscripts:getUnpaidBills', function(bills)
        local elements = {}

        local billIds = {}
        
        if #bills == 0 then
            table.insert(elements, {
                label = 'Non hai nessuna fattura.',
                value = 'no_bill',
            })
        end

        for i = 1, #bills do
            billIds[bills[i].id] = bills[i].amount
            table.insert(elements, {
                label = bills[i].label .. ' - <span style="color:red;">' .. bills[i].amount .. '€</span>',
                value = bills[i].id
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unpaid_bills_menu', {
            title = 'Fatture Non Pagate',
            align = 'left-top',
            elements = elements
        }, function(data, menu)
            local billId = tonumber(data.current.value)

            if data.current.value == 'no_bill' then
                ESX.ShowNotification("Non hai nessuna fattura da pagare")
                ESX.UI.Menu.CloseAll()
                return
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_pay_menu', {
                title = 'Vuoi pagare questa fattura?',
                align = 'left-top',
                elements = {
                    {label = 'Sì', value = 'si'},
                    {label = 'No', value = 'no'}
                }
            }, function(data2, menu2)
                if data2.current.value == 'si' then
                    menu2.close()

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'concosa', {
                        title = 'Contanti o Banca?',
                        align = 'left-top',
                        elements = {
                            {label = 'Contanti', value = 'money'},
                            {label = 'Banca', value = 'bank'}
                        }
                    }, function(data4, menu4)
                        if data4.current.value == 'money' then
                            TriggerServerEvent('highscripts:payBill-contanti', billId)
                        elseif data4.current.value == 'bank' then
                            TriggerServerEvent('highscripts:payBill-banca', billId)
                        end
                        ESX.UI.Menu.CloseAll()
                    end, function(data4, menu4)
                        menu4.close()
                    end)
                elseif data2.current.value == 'no' then
                    ESX.UI.Menu.CloseAll()
                end

            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

RegisterNetEvent('highscripts:aprimenufatture')
AddEventHandler('highscripts:aprimenufatture', function ()
    OpenBillingMenu()
end)
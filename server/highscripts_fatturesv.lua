if GetCurrentResourceName() ~= 'High-MenuF5' then
    return
end

ESX = exports["es_extended"]:getSharedObject()

local function creaIdPerFatture(callback)
    local function rigeneraid()
        local timestamp = os.time()
        local randomValue = math.random(1000, 9999)
        local newId = tostring(timestamp) .. tostring(randomValue)
        
        MySQL.single('SELECT id FROM highscripts_billing WHERE id = ?', {newId}, function(result)
            if result then
                rigeneraid()
            else
                callback(newId)
            end
        end)
    end

    rigeneraid()
end

RegisterServerEvent('highscripts:sendBill')
AddEventHandler('highscripts:sendBill', function(playerId, job, label, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)
    amount = ESX.Math.Round(amount)

    creaIdPerFatture(function(id)
        if amount > 0 and xTarget then
            MySQL.insert('INSERT INTO highscripts_billing (identifier, mandatore, ricevitore, label, amount, id, jobmandatore) VALUES (?, ?, ?, ?, ?, ?, ?)', 
            {xTarget.identifier, xPlayer.identifier, xTarget.identifier, label, amount, id, xPlayer.job.name}, function(insertId)
                if insertId then
                    xTarget.showNotification('Hai ricevuto una fattura di ' .. amount .. '€ per ' .. label)
                end
            end)
        else
            xPlayer.showNotification('Errore: importo non valido o giocatore non trovato.')
        end
    end)
end)

ESX.RegisterServerCallback('highscripts:getUnpaidBills', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query('SELECT id, amount, label FROM highscripts_billing WHERE ricevitore = ?', {xPlayer.identifier}, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('highscripts:payBill-contanti')
AddEventHandler('highscripts:payBill-contanti', function(billId)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.single('SELECT * FROM highscripts_billing WHERE id = ?', {billId}, function(bill)
        if bill then
            local amount = tonumber(bill.amount)

            if xPlayer.getMoney() >= amount then
                xPlayer.removeMoney(amount)

                local xMandatore = ESX.GetPlayerFromIdentifier(bill.mandatore)
                if xMandatore then

                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. bill.jobmandatore, function(account)
                        account.addMoney(amount)
                    end)

                    -- TriggerEvent('highscripts_bossmenu:aggiungiSoldiAllaSociety', bill.jobmandatore, amount)
                end

                MySQL.update('DELETE FROM highscripts_billing WHERE id = ?', {billId}, function(affectedRows)
                    if affectedRows > 0 then
                        xPlayer.showNotification('Hai pagato una fattura con importo ' .. amount)
                        if xMandatore then
                            xMandatore.showNotification('Hai ricevuto un pagamento di ' .. amount .. '€')
                        end
                    else
                        xPlayer.showNotification('Errore durante il pagamento della fattura.')
                    end
                end)
            else
                xPlayer.showNotification('Non hai abbastanza denaro contante per pagare questa fattura.')
            end
        else
            xPlayer.showNotification('Fattura non trovata.')
        end
    end)
end)

RegisterServerEvent('highscripts:payBill-banca')
AddEventHandler('highscripts:payBill-banca', function(billId)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.single('SELECT * FROM highscripts_billing WHERE id = ?', {billId}, function(bill)
        if bill then
            local amount = tonumber(bill.amount)
            local bankAccount = xPlayer.getAccount('bank')

            if bankAccount.money >= amount then
                xPlayer.removeAccountMoney('bank', amount)

                local xMandatore = ESX.GetPlayerFromIdentifier(bill.mandatore)
                if xMandatore then
                    TriggerEvent('crystal_bossmenu:aggiungiSoldiAllaSociety', bill.jobmandatore, amount)
                end

                MySQL.update('DELETE FROM highscripts_billing WHERE id = ?', {billId}, function(affectedRows)
                    if affectedRows > 0 then
                        xPlayer.showNotification('Hai pagato una fattura con importo ' .. amount)
                        if xMandatore then
                            xMandatore.showNotification('Hai ricevuto un pagamento di ' .. amount .. '€')
                        end
                    else
                        xPlayer.showNotification('Errore durante il pagamento della fattura.')
                    end
                end)
            else
                xPlayer.showNotification('Non hai abbastanza soldi in banca per pagare questa fattura.')
            end
        else
            xPlayer.showNotification('Fattura non trovata.')
        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS highscripts_billing (
                id VARCHAR(255) PRIMARY KEY,
                label VARCHAR(255) NOT NULL,
                amount VARCHAR(255) NOT NULL,
                identifier VARCHAR(255) NOT NULL,
                mandatore VARCHAR(255) NOT NULL,
                ricevitore VARCHAR(255) NOT NULL,
                jobmandatore VARCHAR(255) NOT NULL
            )
        ]], {}, function(result)
            print('Tabella "highscripts_billing" creata con successo o esiste già.')
        end)
    end
end)

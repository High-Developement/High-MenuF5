if GetCurrentResourceName() ~= 'High-MenuF5' then
    return
end

ESX = exports["es_extended"]:getSharedObject()

RegisterCommand('aprimenuf5', function()
    openMenuF5()
end, false)

RegisterKeyMapping('aprimenuf5', 'Menu F5', 'keyboard', 'F5')

function openMenuF5()
    local elements = {}

    for _, option in ipairs(ConfigHighScripts.MenuOptions) do
        table.insert(elements, {label = option.label, value = option.event})
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'menuuf5',
        {
            title    = 'Menu F5',
            align    = 'left-top',
            elements = elements
        },
        function(data, menu)
            menu.close()

            TriggerEvent(data.current.value)
        end,
        function(data, menu)
            menu.close()
        end
    )
end

RegisterNetEvent('documenti')
AddEventHandler('documenti', function()
    menudocumenttt()
end)

RegisterNetEvent('apri:fatture')
AddEventHandler('apri:fatture', function()
    TriggerEvent('highscripts:aprimenufatture')
end)

RegisterNetEvent('animradio')
AddEventHandler('animradio', function()
    ExecuteCommand('animradio')
end)

function menudocumenttt()
    local elements = {
        {label = '<i class="fa-regular fa-id-badge fa-beat-fade fa-sm" style="color: #ffffff;"></i> ID: ' .. GetPlayerServerId(PlayerId())},
        {label = '<i class="fa-sharp fa-light fa-user-helmet-safety fa-beat-fade fa-sm" style="color: #ffffff;"></i> Lavoro: ' .. ESX.GetPlayerData().job.label},
        {label = '<i class="fa-solid fa-arrow-turn-up fa-beat-fade fa-sm" style="color: #ffffff;"></i> Grado Lavoro: ' .. ESX.GetPlayerData().job.grade_label}
    }

    if ConfigHighScripts.Job2 then
        table.insert(elements, {label = '<i class="fa-sharp fa-light fa-user-helmet-safety fa-beat-fade fa-sm" style="color: #ffffff;"></i> Fazione: ' .. ESX.GetPlayerData().job2.label})
        table.insert(elements, {label = '<i class="fa-solid fa-arrow-turn-up fa-beat-fade fa-sm" style="color: #ffffff;"></i> Grado Fazione: ' .. ESX.GetPlayerData().job2.grade_label})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menudocss', {
        title = 'Documenti Personali',
        align = 'left-top',
        elements = elements
    }, function(data1, menu1)
    end, function(data1, menu1)
        menu1.close()
    end)
end

RegisterNetEvent('fps')
AddEventHandler('fps', function ()
    ExecuteCommand('fps')
end)
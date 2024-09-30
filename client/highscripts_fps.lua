if GetCurrentResourceName() ~= 'High-MenuF5' then
  return
end

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('highscripts:fps1') 
AddEventHandler('highscripts:fps1', function()
  SetTimecycleModifier('yell_tunnel_nodirect')
  ESX.ShowNotification('FPS Boost')
end)

RegisterNetEvent('highscripts:fps2') 
AddEventHandler('highscripts:fps2', function()
  SetTimecycleModifier('tunnel')
  ESX.ShowNotification('Lights Mode')
end)

RegisterNetEvent('highscripts:fps3') 
AddEventHandler('highscripts:fps3', function()
  SetTimecycleModifier('MP_Powerplay_blend')
  SetExtraTimecycleModifier('reflection_correct_ambient')
  ESX.ShowNotification('Graphics')
end)

RegisterNetEvent('highscripts:fps4') 
AddEventHandler('highscripts:fps4', function()
  SetTimecycleModifier()
  ClearTimecycleModifier()
  ClearExtraTimecycleModifier()
  ESX.ShowNotification('Reseted to default')
end)

RegisterCommand('fps', function()
    OpenFPSMenu()
end)

function OpenFPSMenu()
    local elements = {
        {label = 'FPS Boost', value = 'highscripts:fps1'},
        {label = 'Lights Mode', value = 'highscripts:fps2'},
        {label = 'Graphics', value = 'highscripts:fps3'},
        {label = 'Reset', value = 'highscripts:fps4'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fps_menu', {
        title = 'FPS Menu',
        align = 'left-top',
        elements = elements
    }, function(data, menu)
        TriggerEvent(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end
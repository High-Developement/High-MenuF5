if GetCurrentResourceName() ~= 'High-MenuF5' then
    return
end

local usingRadio = false
local anim1 = false
local anim2 = false
local anim3 = false
local anim4 = false
local anim5 = false
local radioProp = nil

AddEventHandler("pma-voice:radioActive", function(radioTalking)
    usingRadio = radioTalking
    local playerPed = PlayerPedId()

    if usingRadio then
        if anim1 then
            RequestAnimDict('random@arrests')
            while not HasAnimDictLoaded('random@arrests') do
                Wait(10)
            end
            TaskPlayAnim(playerPed, "random@arrests", "generic_radio_chatter", 8.0, -8, -1, 49, 0, 0, 0, 0)
        elseif anim2 then
            RequestAnimDict('random@arrests')
            while not HasAnimDictLoaded('random@arrests') do
                Wait(10)
            end
            TaskPlayAnim(playerPed, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, false, false, false)
        elseif anim3 then
            RequestAnimDict('cellphone@str')
            while not HasAnimDictLoaded('cellphone@str') do
                Wait(10)
            end
            TaskPlayAnim(playerPed, "cellphone@str", "cellphone_call_listen_a", 8.0, 2.0, -1, 50, 2.0, false, false, false)
        elseif anim4 then
            RequestAnimDict('amb@code_human_police_investigate@idle_a')
            while not HasAnimDictLoaded('amb@code_human_police_investigate@idle_a') do
                Wait(10)
            end
            TaskPlayAnim(PlayerPedId(), "amb@code_human_police_investigate@idle_a", "idle_b", 8.0, -8, -1, 49, 0, 0, 0, 0)
        elseif anim5 then
            RequestAnimDict("anim@move_m@security_guard");
            while not HasAnimDictLoaded("anim@move_m@security_guard") do Wait(5) end
            TaskPlayAnim(PlayerPedId(),"anim@move_m@security_guard", "idle_var_02", 2.0, 0.0, -1, 49, 0, 0, 0, 0);
        end

        if radioProp then
            if anim1 then
                SetEntityVisible(radioProp, true, true)
                local boneIndex = GetPedBoneIndex(playerPed, 60309)
                local boneCoords = GetWorldPositionOfEntityBone(playerPed, boneIndex)
                local boneRotation = GetEntityRotation(playerPed, 2)
                SetEntityCoordsNoOffset(radioProp, boneCoords.x, boneCoords.y, boneCoords.z, true, true, true)
                SetEntityRotation(radioProp, boneRotation.x, boneRotation.y, boneRotation.z, 2, true)
                AttachEntityToEntity(radioProp, playerPed, boneIndex, 0.06, 0.05, 0.03, -90.0, 30.0, 0.0, true, true, false, true, 1, true)
            elseif anim2 then
                SetEntityVisible(radioProp, true, true)
                local boneIndex = GetPedBoneIndex(playerPed, 60309)
                local boneCoords = GetWorldPositionOfEntityBone(playerPed, boneIndex)
                local boneRotation = GetEntityRotation(playerPed, 2)
                SetEntityCoordsNoOffset(radioProp, boneCoords.x, boneCoords.y, boneCoords.z, true, true, true)
                SetEntityRotation(radioProp, boneRotation.x, boneRotation.y, boneRotation.z, 2, true)
                AttachEntityToEntity(radioProp, playerPed, boneIndex, 0.06, 0.05, 0.03, -90.0, 30.0, 0.0, true, true, false, true, 1, true)
            elseif anim3 then
                SetEntityVisible(radioProp, true, true)
                local boneIndex = GetPedBoneIndex(playerPed, 28422)
                local boneCoords = GetWorldPositionOfEntityBone(playerPed, boneIndex)
                local boneRotation = GetEntityRotation(playerPed, 2)
                SetEntityCoordsNoOffset(radioProp, boneCoords.x, boneCoords.y, boneCoords.z, true, true, true)
                SetEntityRotation(radioProp, boneRotation.x, boneRotation.y, boneRotation.z, 2, true)
                AttachEntityToEntity(radioProp, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
            elseif anim4 then
                SetEntityVisible(radioProp, false, false)
            end
        end
    else
        usingRadio = false        
        if radioProp then
            SetEntityVisible(radioProp, false, false)
        end

        StopAnimTask(PlayerPedId(), "anim@move_m@security_guard","idle_var_02", -3.0)	
        StopAnimTask(PlayerPedId(), "amb@code_human_police_investigate@idle_a","idle_b", -3.0)	
        StopAnimTask(PlayerPedId(), "cellphone@str","cellphone_call_listen_a", -3.0)	
        StopAnimTask(PlayerPedId(), "random@arrests","generic_radio_enter", -3.0)	
        StopAnimTask(PlayerPedId(), "random@arrests","generic_radio_chatter", -3.0)	

    end
end)

function apriMenuAnimRadio()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'animradioe',
        {
            title    = 'Menu Animazioni Radio',
            align    = 'left-top',
            elements = {
                {label = 'Spalla veloce', value = '1'},
                {label = 'Spalla lenta', value = '2'},
                {label = 'Orecchio', value = '3'},
                {label = 'Polizia', value = '4'},
                {label = 'Auricolare', value = '5'},
                {label = 'Attiva/Disattiva Radio Prop', value = 'toggle_radio_prop'}
            }
        },
        function(data, menu)
            local action = data.current.value
            if action == '1' then
                anim1 = true
                anim2 = false
                anim3 = false
            elseif action == '2' then
                anim1 = false
                anim2 = true
                anim3 = false
            elseif action == '3' then
                anim1 = false
                anim2 = false
                anim3 = true
            elseif action == '4' then
                anim1 = false
                anim2 = false
                anim3 = false
                anim4 = true
            elseif action == '5' then
                anim1 = false
                anim2 = false
                anim3 = false
                anim4 = false
                anim5 = true
            elseif action == 'toggle_radio_prop' then
                if radioProp then
                    DeleteObject(radioProp)
                    radioProp = nil
                else
                    local playerPed = PlayerPedId()
                    local boneIndex = GetPedBoneIndex(playerPed, 57005)
                    local boneCoords = GetWorldPositionOfEntityBone(playerPed, boneIndex)
                    RequestModel('prop_cs_hand_radio')
                    while not HasModelLoaded('prop_cs_hand_radio') do
                        Wait(500)
                    end
                    radioProp = CreateObject(GetHashKey('prop_cs_hand_radio'), boneCoords.x, boneCoords.y, boneCoords.z, true, true, true)
                    SetEntityCollision(radioProp, false, false)
                    PlaceObjectOnGroundProperly(radioProp)
                    SetEntityVisible(radioProp, false, false)
                    SetEntityAlpha(radioProp, 255, false)
                    AttachEntityToEntity(radioProp, playerPed, boneIndex, 0.15, 0.1, -0.05, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                end
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

RegisterCommand('animradio', function ()
    apriMenuAnimRadio()
end)

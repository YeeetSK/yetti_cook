--- CREATING THE ped'S USING THE CONFIG AND ADDING A TARGET TO THEM---
--- CREATING THE ped'S USING THE CONFIG AND ADDING A TARGET TO THEM---
--- CREATING THE ped'S USING THE CONFIG AND ADDING A TARGET TO THEM---
lib.locale()

for k, v in ipairs(Config.CookLocations) do
    lib.zones.sphere({
        coords = v.coords,
        radius = Config.DisplayDistance,
        debug = Config.Debug,
        modelEntity = nil,
        targetID = nil,
        model = v.model,
        targetLabel = Config.TargetLabel,
        askedFood = nil,
        askedDrink = nil,
        onEnter = function (self)
            

            lib.requestModel(self.model)

            local ped = CreatePed(4, GetHashKey(v.model), v.coords.x, v.coords.y, v.coords.z - 1, v.coords.w, false, false)

            SetPedFleeAttributes(ped, 0, 0)
            SetPedDiesWhenInjured(ped, false)
            SetPedKeepTask(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            SetModelAsNoLongerNeeded(GetHashKey(self.model))

            lib.requestAnimDict("anim@mp_player_intcelebrationfemale@wave", 100)

            TaskPlayAnim(ped, "anim@mp_player_intcelebrationfemale@wave", "wave", 8.0, 0.0, -1, 1, 0, false, false, false)

            self.modelEntity = ped

            if Config.Target == 'ox_target' then
                self.targetID = exports.ox_target:addLocalEntity(ped, {
                        type = "client",
                        icon = Config.TargetIcon,
                        label = locale("target_label"),
                        distance = Config.TargetDistance,
                        onSelect = function ()
                            lib.registerContext({
                                id = 'kuchar_menu',
                                title = locale("menu_title"),
                                options = {
                                {
                                    title = locale("menu_food_title"),
                                    description = locale("menu_food_description"),
                                    icon = 'fa-solid fa-burger',
                                    disabled = self.askedFood,
                                    onSelect = function()
                                        local foodmake = lib.progressCircle({
                                            duration = Config.ProgressBar.foodMaking,
                                            position = 'bottom',
                                            useWhileDead = false,
                                            canCancel = false,
                                            label = locale("food_cooking"),
                                            disable = {
                                                car = true,
                                            },
                                        })
                                    
                                        if foodmake then
                                            if lib.progressBar({
                                                duration = Config.ProgressBar.foodEating,
                                                label = locale("food_eating"),
                                                useWhileDead = false,
                                                canCancel = true,
                                                disable = {
                                                    car = true,
                                                },
                                                anim = {
                                                    dict = 'mp_player_inteat@burger',
                                                    clip = 'mp_player_int_eat_burger_fp' ,
                                                },
                                                prop = { model = `prop_cs_burger_01`, pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
                                            }) then 
                                                if Config.Framework == 'qb' then
                                                    TriggerServerEvent('consumables:server:addHunger', 100)
                                                elseif Config.Framework == 'esx' then
                                                    TriggerEvent('esx_status:add', 'hunger', 100)
                                                else
                                                    print('------------------------')
                                                    print('Invalid Config.Framework')
                                                    print('------------------------')
                                                end

                                            end
                                        end
                                        self.askedFood = true
                                        Wait(Config.Cooldown * 1000)
                                        self.askedFood = false
                                    end,
                                },

                                {
                                    title = locale("menu_drink_title"),
                                    description = locale("menu_drink_description"),
                                    icon = 'fa-solid fa-glass-water',
                                    disabled = self.askedDrink,
                                    onSelect = function()
                                        local foodmake = lib.progressCircle({
                                            duration = Config.ProgressBar.drinkMaking,
                                            position = 'bottom',
                                            useWhileDead = false,
                                            canCancel = false,
                                            label = locale("drink_cooking"),
                                            disable = {
                                                car = true,
                                            },
                                        })
                                    
                                        if foodmake then
                                            if lib.progressBar({
                                                duration = Config.ProgressBar.drinkDrinking,
                                                label = locale("drink_eating"),
                                                useWhileDead = false,
                                                canCancel = true,
                                                disable = {
                                                    car = true,
                                                },
                                                anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
                                                prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
                                            }) then
                                                if Config.Framework == 'qb' then
                                                    TriggerServerEvent('consumables:server:addThirst', 100)
                                                elseif Config.Framework == 'esx' then
                                                    TriggerEvent('esx_status:add', 'thirst', 100)
                                                else
                                                    print('------------------------')
                                                    print('Invalid Config.Framework')
                                                    print('------------------------')
                                                end
                                            end
                                        end
                                        self.askedDrink = true
                                        Wait(Config.Cooldown * 1000)
                                        self.askedDrink = false
                                    end,
                                },
                                }
                            })
                        
                            lib.showContext('kuchar_menu')
                        end
                    })
            elseif Config.Target == 'qb-target' then
            exports['qb-target']:AddBoxZone('CookTarget' .. k, vector3(v.coords.x, v.coords.y, v.coords.z + 0.25), 1.5, 1.6, { -- The name has to be unique, the coords a vector3 as shown, the 1.5 is the length of the boxzone and the 1.6 is the width of the boxzone, the length and width have to be float values
                name = 'CookTarget' .. k, -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
                heading = v.coords.w, -- The heading of the boxzone, 
                debugPoly = Config.Debug, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
                minZ = v.coords.z - 1.5, -- This is the bottom of the boxzone, this can be different from the Z value in the coords, this has to be a float value
                maxZ = v.coords.z + 1.5, -- This is the top of the boxzone, this can be different from the Z value in the coords, this has to be a float value
            }, {
                options = { -- This is your options table, in this table all the options will be specified for the target to accept
                {
                    icon = Config.TargetIcon, -- This is the icon that will display next to this trigger option
                    label = locale("target_label"), -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
                    action = function() -- This is the action it has to perform, this REPLACES the event and this is OPTIONAL
                        lib.registerContext({
                            id = 'kuchar_menu',
                            title = locale("menu_title"),
                            options = {
                            {
                                title = locale("menu_food_title"),
                                description = locale("menu_food_description"),
                                icon = 'fa-solid fa-burger',
                                disabled = self.askedFood,
                                onSelect = function()
                                    local foodmake = lib.progressCircle({
                                        duration = Config.ProgressBar.foodMaking,
                                        position = 'bottom',
                                        useWhileDead = false,
                                        canCancel = false,
                                        label = locale("food_cooking"),
                                        disable = {
                                            car = true,
                                        },
                                    })
                                
                                    if foodmake then
                                        if lib.progressBar({
                                            duration = Config.ProgressBar.foodEating,
                                            label = locale("food_eating"),
                                            useWhileDead = false,
                                            canCancel = true,
                                            disable = {
                                                car = true,
                                            },
                                            anim = {
                                                dict = 'mp_player_inteat@burger',
                                                clip = 'mp_player_int_eat_burger_fp' ,
                                            },
                                            prop = { model = `prop_cs_burger_01`, pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
                                        }) then 
                                            if Config.Framework == 'qb' then
                                                TriggerServerEvent('consumables:server:addHunger', 100)
                                            elseif Config.Framework == 'esx' then
                                                TriggerEvent('esx_status:add', 'hunger', 100)
                                            else
                                                print('------------------------')
                                                print('Invalid Config.Framework')
                                                print('------------------------')
                                            end

                                        end
                                    end
                                    self.askedFood = true
                                    Wait(Config.Cooldown * 1000)
                                    self.askedFood = false
                                end,
                            },

                            {
                                title = locale("menu_drink_title"),
                                description = locale("menu_drink_description"),
                                icon = 'fa-solid fa-glass-water',
                                disabled = self.askedDrink,
                                onSelect = function()
                                    local foodmake = lib.progressCircle({
                                        duration = Config.ProgressBar.drinkMaking,
                                        position = 'bottom',
                                        useWhileDead = false,
                                        canCancel = false,
                                        label = locale("drink_cooking"),
                                        disable = {
                                            car = true,
                                        },
                                    })
                                
                                    if foodmake then
                                        if lib.progressBar({
                                            duration = Config.ProgressBar.drinkDrinking,
                                            label = locale("drink_eating"),
                                            useWhileDead = false,
                                            canCancel = true,
                                            disable = {
                                                car = true,
                                            },
                                            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
                                            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
                                        }) then
                                            if Config.Framework == 'qb' then
                                                TriggerServerEvent('consumables:server:addThirst', 100)
                                            elseif Config.Framework == 'esx' then
                                                TriggerEvent('esx_status:add', 'thirst', 100)
                                            else
                                                print('------------------------')
                                                print('Invalid Config.Framework')
                                                print('------------------------')
                                            end
                                        end
                                    end
                                    self.askedDrink = true
                                    Wait(Config.Cooldown * 1000)
                                    self.askedDrink = false
                                end,
                            },
                            }
                        })
                    
                        lib.showContext('kuchar_menu')
                    end,
                }
                },
                distance = Config.TargetDistance, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
            })
            end

        end,
        onExit = function (self)
            DeleteEntity(self.modelEntity)
            if Config.Target == 'ox_target' then
                exports.ox_target:removeLocalEntity(self.modelEntity)
            elseif Config.Target == 'qb-target' then
                exports['qb-target']:RemoveZone("CookTarget" .. k)
            end
            SetEntityAsNoLongerNeeded(self.modelEntity)
            self.modelEntity = nil
        end
    })
end

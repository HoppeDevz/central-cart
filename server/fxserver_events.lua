local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local SqlCommands = module("five_cart", "server/sql_commands")

--------------------------------------------- ban/unban EVENTS --------------------------------------------------------
RegisterNetEvent("fxserver-events-ban")
AddEventHandler("fxserver-events-ban", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        vRP.kick(source, "Você foi banido do servidor pois pediu reembolso do unban.")
    end

    SqlCommands["fxserver-events-ban"](user_id)
    
    callback(true)
end)

RegisterNetEvent("fxserver-events-unban")
AddEventHandler("fxserver-events-unban", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    SqlCommands["fxserver-events-unban"](user_id)

    callback(true)
end)

--------------------------------------------- group/ungroup EVENTS -----------------------------------------------
RegisterNetEvent("fxserver-events-group")
AddEventHandler("fxserver-events-group", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        vRP.addUserGroup(user_id, argument)

        callback(true)
    else
        local rows = SqlCommands["fxserver-get-user-datatables"](user_id)
    
        if #rows > 0 then
            local parsed_dvalue = json.decode(rows[1].dvalue)
            parsed_dvalue.groups[argument] = true;

            SqlCommands("fxserver-events-group")(user_id, parsed_dvalue)

            callback(true)
        end
    end
    
end)

RegisterNetEvent("fxserver-events-ungroup")
AddEventHandler("fxserver-events-ungroup", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        vRP.removeUserGroup(user_id, argument)

        callback(true)
    else
        local rows = SqlCommands["fxserver-get-user-datatable"](user_id)

        if #rows > 0 then
            local parsed_dvalue = json.decode(rows[1].dvalue)

            local pos = 1
            for k,v in pairs(parsed_dvalue.groups) do
                if k == argument then
                    parsed_dvalue.groups[k] = nil
                end
            end

            SqlCommands["fxserver-events-ungroup"](user_id, parsed_dvalue)

            callback(true)
        end
    end
end)

--------------------------------------------- addMoney/removeMoney EVENTS -----------------------------------------------
RegisterNetEvent("fxserver-events-addBank")
AddEventHandler("fxserver-events-addBank", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        vRP.giveBankMoney(user_id, tonumber(amount))

        callback(true)
    else

        SqlCommands["fxserver-events-addBank"](user_id, amount)

        callback(true)
    end
end)

RegisterNetEvent("fxserver-events-removeBank")
AddEventHandler("fxserver-events-removeBank", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        --if not vRP.tryFullPayment(user_id, tonumber(argument)) then
            vRP.setBankMoney(user_id, vRP.getBankMoney(user_id) - tonumber(amount))
            callback(true)
        --end
    else

        SqlCommands["fxserver-events-removeBank"](user_id, amount)

        callback(true)
    end
end)

------------------------------------------ addInventory/removeInventory-----------------------------------------------
RegisterNetEvent("fxserver-events-addInventory")
AddEventHandler("fxserver-events-addInventory", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        vRP.giveInventoryItem(user_id, argument, amount, false)
        
        callback(true)
    else
        local rows = SqlCommands["fxserver-get-user-datatables"](user_id)
    
        if #rows > 0 then
            local parsed_dvalue = json.decode(rows[1].dvalue)

            if parsed_dvalue.inventory[argument] then
                parsed_dvalue.inventory[argument] = parsed_dvalue.inventory[argument] + amount;
            else
                parsed_dvalue.inventory[argument] = amount
            end

            SqlCommands["fxserver-events-addInventory"](user_id, parsed_dvalue)

            callback(true)
        end
    end
end)

RegisterNetEvent("fxserver-events-removeInventory")
AddEventHandler("fxserver-events-removeInventory", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        local item_amount = vRP.getInventoryItemAmount(user_id, argument)
        if not vRP.tryGetInventoryItem(user_id, argument, amount, false) then
            vRP.tryGetInventoryItem(user_id, argument, item_amount, false)

            callback(true)
        end
    else
        local rows = SqlCommands["fxserver-get-user-datatables"](user_id)

        if #rows > 0 then
            local parsed_dvalue = json.decode(rows[1].dvalue)

            if parsed_dvalue.inventory[argument] then
                if parsed_dvalue.inventory[argument] - amount > 0 then
                    parsed_dvalue.inventory[argument] = parsed_dvalue.inventory[argument] - amount
                else
                    parsed_dvalue.inventory[argument] = nil
                end
            end

            SqlCommands["fxserver-events-removeInventory"](user_id, parsed_dvalue)

            callback(true)
        end
    end
end)

------------------------------------------ addHome/removeHome ----------------------------------------------------------
RegisterNetEvent("fxserver-events-addHome")
AddEventHandler("fxserver-events-addHome", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        local number = vRP.findFreeNumber(argument, 1000)
        vRP.setUserAddress(user_id, argument, number)

        callback(true)
    else
        local number = vRP.findFreeNumber(argument, 1000)
        
        SqlCommands["fxserver-events-addHome"](user_id, argument, number)

        callback(true)
    end
end)

RegisterNetEvent("fxserver-events-removeHome")
AddEventHandler("fxserver-events-removeHome", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        vRP.removeUserAddress(user_id, argument)

        callback(true)
    else
        
        SqlCommands["fxserver-events-removeHome"](user_id, argument)

        callback(true)
    end
end)

------------------------------------------ addVehicle/removeVehicle ----------------------------------------------------------
RegisterNetEvent("fxserver-events-addVehicle")
AddEventHandler("fxserver-events-addVehicle", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)
    
    SqlCommands["fxserver-events-addVehicle"](user_id, argument)

    callback(true)
end)

RegisterNetEvent("fxserver-events-removeVehicle")
AddEventHandler("fxserver-events-removeVehicle", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    SqlCommands["fxserver-events-removeVehicle"](user_id, argument)

    callback(true)
end)


RegisterNetEvent("fxserver_events:user-notify")
AddEventHandler("fxserver_events:user-notify", function(user_id, argument, amount)
    local nsource = vRP.getUserSource(tonumber(user_id))

    if nsource then
        TriggerClientEvent("fxserver_c_events:user-notify", nsource, user_id, argument, amount)
    end
end)

RegisterNetEvent("fxserver_events:global_chat_message")
AddEventHandler("fxserver_events:global_chat_message", function(user_id, argument, amount)
    local identity = vRP.getUserIdentity(tonumber(user_id))
    local message = "".. identity.name .." ".. identity.firstname .." COMPROU ".. argument .." "
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-image: linear-gradient(to right, rgba(255, 10, 10,0.7) 3%, rgba(0, 0, 0,0) 95%); border-radius: 15px 50px 30px 5px;"><img style="width: 17px" src="https://image.flaticon.com/icons/svg/138/138304.svg"> {1}</div>',
        args = { fal, message }
    })
end)
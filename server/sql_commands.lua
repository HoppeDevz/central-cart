--=======================================================================
--============================= [LISTA SQL] =============================
--=======================================================================

local SqlCommands = {}

--============================= [BAN] =============================
SqlCommands["fxserver-events-ban"] = function(user_id)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_users SET banned = 1 WHERE id = @user_id", {
        ["@user_id"] = user_id
    })

    return rows
end

--============================= [UNBAN] =============================
SqlCommands["fxserver-events-unban"] = function(user_id)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_users SET banned = 0 WHERE id = @user_id", {
        ["@user_id"] = user_id
    })

    return rows
end

--============================= [GET USER DATA TABLE] =============================
SqlCommands["fxserver-get-user-datatable"] = function(user_id)

    local rows = MySQL.Sync.fetchAll("SELECT * FROM vrp_user_data WHERE dkey = 'vRP:datatable' AND user_id = @user_id", {
        ["@user_id"] = user_id
    })

    return rows
end

--============================= [ADD GROUP] =============================
SqlCommands["fxserver-events-group"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'vRP:datatable' AND user_id = @user_id", {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end

--============================= [REM GROUP] =============================
SqlCommands["fxserver-events-ungroup"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'vRP:datatable' AND user_id = @user_id", {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end

--============================= [ADDBANK] =============================
SqlCommands["fxserver-events-addBank"] = function(user_id, amount)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_moneys SET bank = bank + @incrementval WHERE user_id = @user_id", {
        ['@user_id'] = user_id,
        ['@incrementval'] = tonumber(amount),
    })

    return rows
end

--============================= [REM BANK] =============================
SqlCommands["fxserver-events-removeBank"] = function(user_id, amount)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_moneys SET bank = bank - @incrementval WHERE user_id = @user_id", {
        ['@user_id'] = user_id,
        ['@incrementval'] = tonumber(amount),
    })

    return rows
end

--============================= [ADD ITEM] =============================
SqlCommands["fxserver-events-addInventory"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'vRP:datatable' AND user_id = @user_id", {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end

--============================= [REM ITEM] =============================
SqlCommands["fxserver-events-removeInventory"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'vRP:datatable' AND user_id = @user_id", {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end


--============================= [ADD HOME] =============================
SqlCommands["fxserver-events-addHome"] = function(user_id, argument, number)

    local rows = MySQL.Sync.fetchAll("INSERT INTO vrp_user_homes (user_id, home, number, chest) VALUES(@user_id, @home, @number, @chest)", {
        ["@user_id"] = user_id,
        ["@home"] = argument,
        ["@number"] = number,
        ["@chest"] = json.encode({});
    })

    return rows
end

--============================= [REM HOME] =============================
SqlCommands["fxserver-events-removeHome"] = function(user_id, argument)

    local rows =MySQL.Sync.fetchAll("DELETE FROM vrp_user_homes WHERE user_id = @user_id AND home = @home", {
        ["@user_id"] = user_id,
        ["@home"] = argument
    })

    return rows
end

--============================= [ADD VEHICLE] =============================
SqlCommands["fxserver-events-addVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("INSERT INTO vrp_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {
        ["@user_id"] = user_id,
        ["@vehicle"] = argument
    })

    return rows
end

--============================= [REM VEHICLE] =============================
SqlCommands["fxserver-events-removeVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle", {
        ["@user_id"] = user_id,
        ["@vehicle"] = argument
    })

    return rows
end


return SqlCommands
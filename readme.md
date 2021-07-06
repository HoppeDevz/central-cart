##### 📦 CentralMarket
<br>

<img style="text-align:center" src="https://cdn.discordapp.com/attachments/632603915988500490/862104634209992715/IMG_20210605_005606_265.png">

<br>

##### 👉 Install
```bash
npm install or yarn install
```
<br>

##### 🗣️ Events
```json
{
    "ban": "fxserver-events-ban",
    "unban": "fxserver-events-unban",

    "group": "fxserver-events-group",
    "ungroup": "fxserver-events-ungroup",

    "addBank":  "fxserver-events-addBank",
    "removeBank":  "fxserver-events-removeBank",

    "addInventory":  "fxserver-events-addInventory",
    "removeInventory":  "fxserver-events-removeInventory",

    "addHome":  "fxserver-events-addHome",
    "removeHome":  "fxserver-events-removeHome",

    "addVehicle":  "fxserver-events-addVehicle",
    "removeVehicle":  "fxserver-events-removeVehicle"
}
```


#### 🤠 Change Delivery SQL's !

```lua
SqlCommands["fxserver-events-addVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("INSERT INTO vrp_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {
        ["@user_id"] = user_id,
        ["@vehicle"] = argument
    })

    return rows
end
```
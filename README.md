
# EmergScripts Polyzone
### Description
EmergScripts Polyzone is a FiveM resource that allows you to create and manage zones within your FiveM server. This documentation provides instructions on how to create zones and implement zone detection functionality in your client or server resource.

##### Why Use EmergScripts Polyzone?
EmergScripts Polyzone offers several advantages over other similar scripts:

1. Server-Side Logic: The logic for zone detection and handling is performed on the server-side. This approach prevents event amplification, a common issue in client-side zone scripts. By handling the logic server-side, EmergScripts Polyzone provides a more efficient and optimized solution.

2. Improved Client Performance: Since the zone detection and handling are executed on the server, the client's performance is not significantly impacted. This allows players to experience smooth gameplay without experiencing lag or performance issues due to zone-related computations on their end.

3. Flexibility and Customization: EmergScripts Polyzone provides a flexible framework that allows you to create and manage zones according to your specific needs. You can define zones of any shape and size, set their height, and customize the actions taken when players enter or leave these zones. This versatility enables you to create unique gameplay experiences tailored to your server's requirements.

##### Creating a Zone
To create a zone, follow these steps within FiveM:

1. Run the following command: ``/setupZone new``
2. Assign a unique identifier (UID) to the zone. For example, ``/setupZone uid sandyPolice``.
3. Define the points that make up the zone by executing the ``/setupZone point`` command at each corner or significant point of the zone.
4. Set the height of the zone by using the ``/setupZone height`` command followed by a floating-point number representing the distance from the lowest point upwards. For example, ``/setupZone height 10.0``.
5. Once all points have been set, finalize the creation of the zone using the ``/setupZone finish`` command.
6. Copy the results and put them in the config.lua file.


# Resource Implementation
#### Client Side
In your client-side script, use the following code:

```Lua
RegisterNetEvent('EmergScripts:PolyZones:EnteredPolyZone', function(zone_uid)
    if zone_uid == "sandyPolice" then
        print('entered sandy pd')
    end
end)
```

```Lua
RegisterNetEvent('EmergScripts:PolyZones:LeftPolyZone', function(zone_uid)
    if zone_uid == "sandyPolice" then
        print('left sandy pd')
    end
end)
```

Replace "sandyPolice" with the appropriate zone UID you defined earlier. Customize the actions inside the event handlers to suit your needs when a player enters or leaves the specified zone.

#### Server Side
In your server-side script, use the following code:

```Lua
RegisterNetEvent('EmergScripts:PolyZones:EnteredPolyZone', function(source, zone_uid)
    if zone_uid == "sandyPolice" then
        print(GetPlayerName(source) .. ' has entered sandy pd')
    end
end)
```

```Lua
RegisterNetEvent('EmergScripts:PolyZones:LeftPolyZone', function(source, zone_uid)
    if zone_uid == "sandyPolice" then
        print(GetPlayerName(source) .. ' has left sandy pd')
    end
end)
```
Once again, replace "sandyPolice" with the appropriate zone UID. Adjust the code inside the event handlers as needed to perform actions when a player enters or leaves the specified zone.
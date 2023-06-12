-- Store if the player is in a poly zone (can be multiple poly zones)
local tempData = {}

-- Detect if the player is in a poly zone
Citizen.CreateThread(function()
	for _, polyZone in ipairs(config.polyZones) do
		tempData[polyZone.uid] = {}
	end

	while true do
		if config.refreshTime == nil then config.refreshTime = 1000 end
		Citizen.Wait(config.refreshTime)
		-- Loop through all players
		for _, playerId in ipairs(GetPlayers()) do
			-- Loop through all poly zones
			for _, polyZone in ipairs(config.polyZones) do
				-- Get the player's position
				local playerPos = GetEntityCoords(GetPlayerPed(playerId))
				
				-- Get the lowest point of the poly zone
				local lowestPoint = polyZone.points[1].z
				for _, point in ipairs(polyZone.points) do
					if point.z < lowestPoint then
						lowestPoint = point.z
					end
				end

				-- Check if the player is in the polyzone (Go in order of the points in the config to form a polygon)
				local isInBoxZone = false
				for i = 1, #polyZone.points do
					local point1 = polyZone.points[i]
					local point2 = polyZone.points[i + 1]
					if point2 == nil then point2 = polyZone.points[1] end

					if point1.x < playerPos.x and point2.x >= playerPos.x or point2.x < playerPos.x and point1.x >= playerPos.x then
						if point1.y + (playerPos.x - point1.x) / (point2.x - point1.x) * (point2.y - point1.y) < playerPos.y then
							-- check if the player is in the height range
							if playerPos.z >= lowestPoint and playerPos.z <= lowestPoint + polyZone.height then
								isInBoxZone = not isInBoxZone
							else
								isInBoxZone = false
							end
						end
					end
				end

				-- If the player is in the poly zone
				if isInBoxZone then
					-- If the player is not in the poly zone
					if tempData[polyZone.uid][playerId] == nil then
						-- If debug is enabled
						if polyZone.debug then
							print("EmergScripts:PolyZones - Player " .. playerId .. " has entered poly zone " .. polyZone.name .. " (" .. polyZone.uid .. ")")
						end

						-- Trigger the event
						TriggerClientEvent("EmergScripts:PolyZones:EnteredPolyZone", playerId, polyZone.uid)
						TriggerEvent("EmergScripts:PolyZones:EnteredPolyZone", playerId, polyZone.uid)
					end

					-- Set the player as in the poly zone
					tempData[polyZone.uid][playerId] = true
				else
					-- If the player is in the poly zone
					if tempData[polyZone.uid][playerId] ~= nil then
						-- If debug is enabled
						if polyZone.debug then
							print("EmergScripts:PolyZones - Player " .. playerId .. " has left poly zone " .. polyZone.name .. " (" .. polyZone.uid .. ")")
						end

						-- Trigger the event
						TriggerClientEvent("EmergScripts:PolyZones:LeftPolyZone", playerId, polyZone.uid)
						TriggerEvent("EmergScripts:PolyZones:LeftPolyZone", playerId, polyZone.uid)
					end

					-- Set the player as not in the poly zone
					tempData[polyZone.uid][playerId] = nil
				end
			end
		end
	end
end)

RegisterNetEvent('EmergScripts:PolyZones:DebugRequestZones', function()
	local source = source
	TriggerClientEvent('EmergScripts:PolyZones:DebugZone', source, config.polyZones)
end)

-- TriggerServerEvent("EmergScripts:PolyZones:SaveZone", data)
RegisterNetEvent('EmergScripts:PolyZones:SaveZone', function(data)
	-- write a file with the data
	local file = io.open("EmergScriptsPolyZones.json", "w")
	file:write(json.encode(data))
	file:close()
end)
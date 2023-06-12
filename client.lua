local showZones = false
local debugZones = {}
RegisterCommand('showzones', function(source, args, raw)
	showZones = not showZones
	TriggerServerEvent('EmergScripts:PolyZones:DebugRequestZones')
end)

RegisterNetEvent('EmergScripts:PolyZones:DebugZone', function(zones)
	debugZones = zones
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showZones then
			-- Loop through poly zones
			for _, polyZone in ipairs(debugZones) do
				-- Get the lowest point of the poly zone
				local lowestPoint = polyZone.points[1].z
				local highestPoint = polyZone.points[1].z
				for _, point in ipairs(polyZone.points) do
					if point.z < lowestPoint then
						lowestPoint = point.z
					end
					if point.z > highestPoint then
						highestPoint = point.z
					end
				end

				-- Draw the walls of the poly zone (may have multiple walls)
				for i = 1, #polyZone.points do
					local point1 = polyZone.points[i]
					local point2 = polyZone.points[i + 1]
					if point2 == nil then point2 = polyZone.points[1] end

					-- Draw lines every 0.5 units vertical
					for height = lowestPoint, highestPoint, 0.004 do
						DrawLine(point1.x, point1.y, height, point2.x, point2.y, height, 0, 255, 0, 100)
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)


local cmdData = {}
RegisterCommand('setupZone', function(source, args, raw)
	-- upload:data
	local cmd = args[1]
	if cmd == "new" then
		cmdData = 	{
			name = nil,
			uid = nil,
			points = {},
			height = nil,
			debug = false,
		}
		print("Starting to setup a new zone")
	elseif cmd == "point" then
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
		table.insert(cmdData.points, vector3(x, y, z))
		print("Added point: " .. x .. ", " .. y .. ", " .. z)
	elseif cmd == "name" then
		cmdData.name = args[2]
		print("Set name to: " .. cmdData.name)
	elseif cmd == "uid" then
		-- Make sure no spaces
		if string.find(args[2], " ") ~= nil then
			print("Uid can't contain spaces")
			return
		end

		cmdData.uid = args[2]
		print("Set uid to: " .. cmdData.uid)
	elseif cmd == "height" then
		-- to float
		local height = tonumber(args[2]) + 0.001
		cmdData.height = height
		print("Set height to: " .. cmdData.height)
	elseif cmd == "finish" then
		-- need at least 3 points
		if #cmdData.points < 3 then
			print("Need at least 3 points")
			return
		end
		
		-- check if height is set
		if cmdData.height == nil then
			print("Height is not set")
			return
		end

		-- check if all data is set
		if cmdData.name == nil then
			print("Name is not set")
			return
		end

		if cmdData.uid == nil then
			print("Uid is not set")
			return
		end

		if #cmdData.points == 0 then
			print("No points set")
			return
		end

		-- upload data
		-- Format data into text format (not json)
		local data = "{\n"
		data = data .. "\tname = '" .. cmdData.name .. "',\n"
		data = data .. "\tuid = '" .. cmdData.uid .. "',\n"
		data = data .. "\tpoints = {\n"
		for _, point in ipairs(cmdData.points) do
			data = data .. "\t\tvector3(" .. point.x .. ", " .. point.y .. ", " .. point.z .. "),\n"
		end
		data = data .. "\t},\n"
		data = data .. "\theight = " .. cmdData.height .. ",\n"
		data = data .. "\tdebug = false,\n"
		data = data .. "},"

		--TriggerServerEvent("upload:data", data)
		--print("Finished uploading data")
	
		TriggerServerEvent("EmergScripts:PolyZones:SaveZone", data)
		print("Copied to clipboard")
	else
		print("Invalid command. Valid commands are: new, point, name, uid, finish")
	end
end)
config = {}

config.refreshTime = 1000 -- How often to check if the player is in a poly zone

config.polyZones = {
	{
		name = 'Sandy Security',
		uid = 'sandy_pd_security',
		points = {
			vector3(1825.9876708984, 3680.8745117188, 33.326133728027),
			vector3(1827.8955078125, 3677.5517578125, 33.369827270508),
			vector3(1828.7019042969, 3678.2663574219, 33.32612991333),
			vector3(1827.2585449219, 3681.0305175781, 35.326126098633),
		},
		height = 5.001,
		debug = false,
	},
	{
		name = 'jailCells',
		uid = 'jailCells',
		points = {
			vector3(1839.9630126953, 3671.6760253906, 33.312870025635),
			vector3(1848.2989501953, 3676.744140625, 33.627868652344),
			vector3(1849.5139160156, 3674.4018554688, 33.627868652344),
			vector3(1841.6594238281, 3669.5041503906, 36.139862060547),
		},
		height = 3.001,
		debug = false,
	},
}


--==================================================================================================--
--======================================== DO NOT EDIT BELOW =======================================--
--==================================================================================================--
function validateConfig()
	if config.polyZones == nil then
		print("EmergScripts:PolyZones - No poly zones found in config.lua")
		return false
	end

	for _, polyZone in ipairs(config.polyZones) do
		if polyZone.name == nil then
			print("EmergScripts:PolyZones - Box zone name is missing")
		end

		if polyZone.uid == nil then
			print("EmergScripts:PolyZones - Box zone uid is missing")
		end
		

		-- If Debug
		if polyZone.debug == nil then
			polyZone.debug = false
		end

		-- If Debug Print
		if polyZone.debug then
			print("EmergScripts:PolyZones - Box zone " .. polyZone.name .. " (" .. polyZone.uid .. ") has been loaded")
			print("EmergScripts:PolyZones - Box zone " .. polyZone.name .. " (" .. polyZone.uid .. ") debug is enabled (Will impact client performance)")
		end

		config.polyZones[_] = polyZone
	end

	-- If refresh time is nil
	if config.refreshTime == nil then
		print("EmergScripts:PolyZones - Refresh time is missing (Defaulting to 1000)")
	end

	-- If refresh time is too low
	if config.refreshTime ~= nil and config.refreshTime < 100 then
		print("EmergScripts:PolyZones - Refresh time is too (Will impact performance. Recommended = 1000)")
	end	


	return true
end

validateConfig()
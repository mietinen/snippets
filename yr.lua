#!/usr/bin/env lua

-- Used for testing while making AwesomeWM yr.no module

local yrdata = {}
local xmlfile = "/home/harry/.cache/awesome/yr.no.xml"
local location = os.getenv("LOCATION") or "Oslo"
local lpattern = string.gsub(location, "%a", function (c)
	return string.format("[%s%s]", string.lower(c),
	string.upper(c))
end)


local f = assert(io.open(xmlfile, "r"))
local xml = f:read("*all") 
f:close()
local match_pattern = string.match(xml, '<weatherdata%W?%C*>.-<location%W?%C*>.-<name%W?%C*>%C*('..lpattern..')%C*</name>.*</location>.*</weatherdata>')
if match_pattern == nil then
	-- widget:get_children_by_id('text')[1].markup = " data error"
	-- update_xml()
else
	local nextupdate = string.match(xml, '<weatherdata%W?%C*>.-<meta%W?%C*>.-<nextupdate%W?%C*>(%C*)</nextupdate>.*</meta>.*</weatherdata>')
	local year, month, day, hour, min, sec = string.match(nextupdate, "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)")
	local nextupdate_unix = os.time{year = year, month = month, day = day, hour = hour, min = min, sec = sec}
	local timediff = os.time(os.date("!*t")) - nextupdate_unix
	local tabular = string.match(xml, '<weatherdata%W?%C*>.-<forecast%W?%C*>.-<tabular%W?%C*>(.-)</tabular>.*</forecast>.*</weatherdata>') or ""
	local i = 1
	for wdata in string.gmatch(tabular, '(<time%W?%C*>.-</time>)') do
		if yrdata[i] == nil then yrdata[i] = {} end
		local year, month, day, hour, min, sec = string.match(wdata, '<time%C*from="(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)"')
		yrdata[i].time = os.time{year = year, month = month, day = day, hour = hour, min = min, sec = sec}
		local symbolnumber = string.match(wdata, '<symbol%C*number="(.-)"')
		local precipitation = string.match(wdata, '<precipitation%C*value="(.-)"')
		local winddirection = string.match(wdata, '<windDirection%C*deg="(.-)"')
		local windspeed = string.match(wdata, '<windSpeed%C*mps="(.-)"')
		local temperature = string.match(wdata, '<temperature%C*value="(.-)"')
		local pressure = string.match(wdata, '<pressure%C*value="(.-)"')
		if symbolnumber == nil or precipitation == nil or winddirection == nil
			or windspeed == nil or temperature == nil or pressure == nil then
			-- widget:get_children_by_id('text')[1].markup = " data error"
			-- update_xml()
		else
			local windarrow, precipitationtext
			if tonumber(winddirection) <= 22 then windarrow = "↓"
			elseif tonumber(winddirection) <= 67 then windarrow = "↙"
			elseif tonumber(winddirection) <= 112 then windarrow = "←"
			elseif tonumber(winddirection) <= 157 then windarrow = "↖"
			elseif tonumber(winddirection) <= 202 then windarrow = "↑"
			elseif tonumber(winddirection) <= 247 then windarrow = "↗"
			elseif tonumber(winddirection) <= 292 then windarrow = "→"
			elseif tonumber(winddirection) <= 337 then windarrow = "↘"
			else windarrow = "↓" end
			if tonumber(precipitation) > 0 then precipitationtext = ", (" .. precipitation .. "mm)"
			else precipitationtext = "" end
			-- yrdata[i].image = path_to_icons .. icon[tonumber(symbolnumber)] 
			yrdata[i].markup = temperature .. "°C" .. precipitationtext .. ", " .. windarrow .. windspeed .. "m/s"
			-- if i == 1 then
			-- 	widget:get_children_by_id('icon')[1].image = path_to_icons .. icon[tonumber(symbolnumber)] 
			-- 	widget:get_children_by_id('text')[1].markup = yrdata[i].markup 
			-- end
		end

		i = i + 1
	end
	if timediff > 1 then update_xml() end
end


for i = 1, 10 do
	print(os.date("%d %b, %H:%M", yrdata[i].time) .. "  " .. yrdata[i].markup)
end




     









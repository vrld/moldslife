local function colorEqual(a,b)
	return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

return function(path)
	local info = assert(require('levels.'..path), "Cannot load level "..path)
	local m = love.image.newImageData("levels/"..path..".png")

	local color_to_code = {
		{{m:getPixel(0,0)}, {1,0,0,0}},
		{{m:getPixel(1,0)}, {0,1,0,0}},
		{{m:getPixel(2,0)}, {0,0,1,0}},
		{{m:getPixel(3,0)}, {0,0,0,1}},
	}
	local goal_color = {m:getPixel(4,0)}
	info.goals = {}

	local control = {0,0,0}
	local map = love.image.newImageData(WIDTH, HEIGHT)
	map:mapPixel(function(x,y)
		local c = {m:getPixel(x,y+1)}
		for i,cc in ipairs(color_to_code) do
			if colorEqual(cc[1], c) then
				control[i] = (control[i] or 0) + 1
				return unpack(cc[2])
			end
		end
		if colorEqual(goal_color, c) then
			info.goals[#info.goals+1] = vector(x,y)
			info.goals[#info.goals].nr = #info.goals
		end
		return 0,0,0,0
	end)

	info.reset = function(timer)
		info.map = love.image.newImageData(map:getWidth(), map:getHeight())
		info.map:paste(map, 0,0,0,0, map:getWidth(), map:getHeight())
		info.map_img = love.graphics.newImage(info.map)

		info.molds = info.initMolds(info.map)
		info.control = class.clone(control)
		for i,g in ipairs(info.goals) do
			info.goals[i] = vector(g:unpack())
		end

		info.onLoad(info, timer or Timer)
	end

	info.everyFrame = info.everyFrame or function() end

	return info
end

local st = {}
local map, map_shader, mold

function st:enter()
	map = love.image.newImageData(WIDTH, HEIGHT)
	map:mapPixel(function(x,y)
		x = (x - WIDTH/2)  / HEIGHT
		y = (y - HEIGHT/2) / HEIGHT
		if x*x + y*y < .125 then
			return 1,1,1,255
		end
		return 0,0,0,0
	end)

	mold = Entity.Mold(map, 1, 1000)
	map = love.graphics.newImage(map)
end

function st:draw()
	mold:drawMap({20,40,75})
	mold:drawMold({20,40,75})
end

function st:update(dt)
	mold:update(dt)
	map:refresh()
end

function st:mousereleased(mx,my)
	mold.kde:add(function(x,y)
		local d = ((x-mx)/WIDTH)^2 + ((y-my)/WIDTH)^2
		return math.exp(-d / .005)
	end)
end

function st:keypressed(key)
	if key == 'c' then
		mold.kde.clear()
	end
end

return st

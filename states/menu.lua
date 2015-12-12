local st = {}

function st:init()
end

function st:enter()
end

function st:draw()
	love.graphics.setColor(100,100,100,100)
	love.graphics.print("Grow and 2 Buttons", 10,10)
end

return st

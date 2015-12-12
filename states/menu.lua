local st = {}

function st:init()
end

function st:enter()
	love.graphics.setBackgroundColor(30,28,25)
	love.graphics.setFont(Font[50])
end

function st:draw()
	love.graphics.setColor(100,100,100)
	love.graphics.print("Grow and 2 Buttons", 10,10)

	love.graphics.printf("-press any key-", 0,HEIGHT-120,WIDTH, 'center')
end

function st:keypressed()
	GS.switch(State.game)
end

return st

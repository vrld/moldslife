local st = {}

function st:init()
end

function st:enter()
	--love.graphics.setBackgroundColor(0,0,0)
end

function st:draw()
	love.graphics.setColor(100,100,100)
	love.graphics.setFont(Font[50])
	love.graphics.printf("Moldy", 0,HEIGHT/2-100,WIDTH, 'center')

	love.graphics.setFont(Font[40])
	love.graphics.printf("-press any key-", 0,HEIGHT-120,WIDTH, 'center')
end

function st:keypressed()
	GS.switch(State.game, Level.level01)
end

return st

local st = {}

local effect
function st:init()
	effect = shine.boxblur():chain(shine.desaturate())
	effect.radius = 5
	effect.strength = 1
	effect.tint = {100,100,100}
end

function st:enter(pre)
	print("Enter ", pre)
	self.pre = pre
	effect, self.pre.post = self.pre.post, effect
end

function st:leave()
	effect, self.pre.post = self.pre.post, effect
end

function st:draw()
	self.pre:draw()

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(Font[40])
	love.graphics.printf("You did it!", 0,HEIGHT/2-100,WIDTH, "center")

	love.graphics.setFont(Font[20])
	love.graphics.printf("Press any key to go to next level", 0,HEIGHT/2+50, WIDTH, "center")
end

function st:keypressed()
	GS.switch(State.game, self.pre.level.nextLevel())
end

return st

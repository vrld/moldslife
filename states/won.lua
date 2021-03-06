local st = {}

local effect
function st:init()
	effect = shine.boxblur():chain(shine.desaturate())
	effect.radius = 5
	effect.strength = 1
	effect.tint = {100,100,100}
end

function st:enter(pre)
	self.pre = pre
	effect, self.pre.post = self.pre.post, effect
	self.nextLevel = self.pre.level.nextLevel()
end

function st:leave()
	effect, self.pre.post = self.pre.post, effect
end

function st:draw()
	self.pre:draw()

	love.graphics.setColor(120,240,230)
	love.graphics.setFont(Font[50])
	love.graphics.printf("Another Day, Another Victory!", 0,HEIGHT/2-100,WIDTH, "center")

	gui.core.draw()
end

function st:update()
	love.graphics.setFont(Font[30])
	gui.group{grow="down", pos = {WIDTH/2-100, HEIGHT/2+100}, size={200,40}, spacing=5, function()
		if self.nextLevel then
			if gui.Button{text = "Next level"} then
				GS.transition(State.game, 1, self.nextLevel)
			end
		else
			gui.Label{text = "That's it. You made it!",align="center",pos={nil,-40}}
			gui.Label{text = "",align="center",size={nil,40}}
		end

		if gui.Button{text = "Quit"} then
			GS.transition(State.menu, .5)
		end
	end}

	hot, hot_last = gui.mouse.getHot(), hot
	if hot and hot ~= hot_last then
		selectSound:play()
	end

end

return st

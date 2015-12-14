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
end

function st:leave()
	effect, self.pre.post = self.pre.post, effect
end

function st:draw()
	self.pre:draw()

	love.graphics.setColor(120,240,230)
	love.graphics.setFont(Font[50])
	love.graphics.printf("Pause", 0,HEIGHT/2-100,WIDTH, "center")

	gui.core.draw()
end

function st:update()
	love.graphics.setFont(Font[30])
	gui.group{grow="right", pos = {WIDTH/2-310, HEIGHT/2+100}, size={200,40}, spacing=5, function()
		if gui.Button{text = "Resume"} then
			GS.pop()
		end

		if gui.Button{text = "Restart"} then
			GS.pop()
			Timer.after(0, function() GS.switch(State.game, State.game.level) end)
		end

		if gui.Button{text = "Quit"} then
			GS.pop()
			Timer.after(0, function() GS.transition(State.menu, .5) end)
		end
	end}

	hot, hot_last = gui.mouse.getHot(), hot
	if hot and hot ~= hot_last then
		selectSound:play()
	end
end

function st:keypressed(key)
	if key == 'escape' then
		GS.pop()
	end
end

return st

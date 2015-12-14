local st = {}

function st:init()
	self.post = shine.vignette():chain(shine.godsray())
	self.post.radius = .8
	self.post.softness = .7
	self.post.opacity = .6
	self.post.exposure = .35
	self.post.decay = .94
	self.post.density = .3
	self.post.positionx = .5
	self.post.positiony = .4

	gui.core.style.color.normal = {
		bg     = {50,92,82},
		fg     = {120,240,230},
		border = {50,92,82},
	}

	gui.core.style.color.hot = {
		bg     = {120,240,230},
		fg     = {50,92,82},
		border = {50,92,82},
	}

	gui.core.style.color.active = {
		bg     = {75,40,20},
		fg     = {50,92,82},
		border = {50,92,82},
	}

	gui.keyboard.disable()
end

function st:enter()
	love.graphics.setBackgroundColor(25,30,28)
end

local hot, hot_last
function st:update()
	love.graphics.setFont(Font[30])
	gui.group{grow="down", pos = {WIDTH/2-150, HEIGHT/2+60}, size={300,40}, spacing=5, function()
		if gui.Button{text = "Start"} then
			GS.transition(State.game, 1, Level.level01)
		end

		if gui.Button{text = "Level Select"} then
			GS.transition(State.levelselect, .5)
		end

		if gui.Button{text = "Credits"} then
			GS.transition(State.credits, .5)
		end

		if gui.Button{text = "Exit"} then
			love.event.quit()
		end
	end}

	hot, hot_last = gui.mouse.getHot(), hot
	if hot and hot ~= hot_last then
		selectSound:play()
	end
end

function st:draw()
	self.post:draw(function()
		love.graphics.setColor(120,240,230)
		love.graphics.setFont(Font[80])
		love.graphics.printf("A mold's life", 0,HEIGHT/2-180,WIDTH, 'center')
	end)
	gui.core.draw()
end

return st

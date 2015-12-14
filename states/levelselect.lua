local st = {}

function st:update()
	gui.group{grow="down", pos = {WIDTH/2-250, HEIGHT/2-20}, size={500,40}, spacing=5, function()
		love.graphics.setFont(Font[30])
		if gui.Button{text = "01: Something's fishy", size={nil,40}} then
			GS.transition(State.game, 1, Level.level01)
		end

		if gui.Button{text = "02: Two for Two", size={nil,40}} then
			GS.transition(State.game, 1, Level.level02)
		end

		if gui.Button{text = "03: A shared meal", size={nil,40}} then
			GS.transition(State.game, 1, Level.level03)
		end

		if gui.Button{text = "04: ring ring ring ring ring ring", size={nil,40}} then
			GS.transition(State.game, 1, Level.level04)
		end

		if gui.Button{text = "05: The Hunt", size={nil,40}} then
			GS.transition(State.game, 1, Level.level05)
		end

		gui.Label{text = "", size={nil,20}}
		if gui.Button{text = "back", pos={100}, size={300,40}} then
			GS.transition(State.menu,.5)
		end
	end}

	hot, hot_last = gui.mouse.getHot(), hot
	if hot and hot ~= hot_last then
		selectSound:play()
	end
end

function st:draw()
	State.menu:draw()
end

return st

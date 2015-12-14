local st = {}

function st:update()
	gui.group{grow="down", pos = {WIDTH/2-150, HEIGHT/2-60}, size={300,25}, spacing=5, function()
		love.graphics.setFont(Font[30])
		gui.Label{text = "A game by VRLD", align="center"}
		gui.Label{text = "Made in 48-ish Hours", align="center"}
		gui.Label{text = "for the 34th Ludum Dare compo", align="center"}

		love.graphics.setFont(Font[25])
		gui.Label{text = "", size={nil,15}}
		gui.Label{text = "Made with LÖVE", align="center"}
		gui.Label{text = "Font: Turtles by jaynz", align="center"}

		love.graphics.setFont(Font[20])
		gui.Label{text = "", size={nil,15}}
		gui.Label{text = "Season's Greetings:", align="center"}
		gui.Label{text = "cappel:nord, fysx, headchant, steven colling", align="center"}
		gui.Label{text = "bartbes, boolsheet, rude, slime, and the inner party members", align="center"}

		gui.Label{text = "", size={nil,20}}
		love.graphics.setFont(Font[30])
		if gui.Button{text = "back", size={nil,40}} then
			GS.transition(State.menu, .5)
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

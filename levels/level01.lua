local text

return {

onLoad = function(self, timer)
	text = {
		x = 20,
		y = -50,
		rot = 0,
		color = {255,255,255,0}
	}
	timer.script(function(wait)
		self.message = "The eye is THE best part of the fish!"
		wait(5)
		self.message = "Go for it!"

		timer.tween(5, text, {x = 30, y = -60, rot = .1}, 'in-out-quad', function()
			timer.tween(.5, text.color, {[4] = 0}, 'quad')
		end)
		timer.tween(.5, text.color, {[4] = 255}, 'quad')
		wait(5)
		self.message = ""
	end)
end,

initMolds = function(map)
	return {
		Entity.Mold(map, 1, 300, {50,92,82}),
	}
end,

nextLevel = function()
	return Level.level02
end,

drawHook = function(self)
	love.graphics.setColor(240,240,100)
	local g = self.goals[1]
	love.graphics.circle('line', g.x, g.y, 5)

	love.graphics.setColor(text.color)
	love.graphics.setFont(Font[20])
	love.graphics.print("click?", text.x + g.x, text.y + g.y, text.rot)

	local cs = table.sum(self.control)
	love.graphics.setColor(self.molds[1].color)
	love.graphics.rectangle("fill", 0,0, WIDTH*self.control[1]/cs, 20)
end,

winningConditionSatisfied = function(self)
	for _,g in ipairs(self.goals) do
		if not g.reached then return false end
	end
	return true
end,
}

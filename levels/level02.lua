return {

onLoad = function(self, timer)
	timer.script(function(wait)
		self.message = "Another fish! And another!"
		wait(5)
		self.message = "Is it Christmas already?"
		wait(3)
		self.message = "An eye for an eye"
		wait(3)
		self.message = "And two are better than one"
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
	return Level.level03
end,

drawHook = function(self)
	love.graphics.setColor(240,240,100)
	for _,g in ipairs(self.goals) do
		love.graphics.circle('line', g.x, g.y, 5)
	end

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

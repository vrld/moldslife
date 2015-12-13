return {

onLoad = function(self, timer)
	self.control[4] = 0
	timer.script(function(wait)
		self.message = "An apple a day keeps the doctor away..."
		wait(5)
		self.message = "Wait. Who are you?!"
		wait(3)
		self.message = "This apple is mine! Go away!"
		wait(5)
		self.message = ""
		wait(2)
		self.message = "Alright"
		wait(2)
		self.message = "He that will not hear must feel!"
		wait(5)
		self.message = ""
	end)
end,

initMolds = function(map)
	return {
		Entity.Mold(map, 1, 300, {50,92,82}, {1,2,1}, 5),
		Entity.Mold(map, 2, 100, {75,40,20}, {1,1,1}),
	}
end,

nextLevel = function()
	return Level.level04
end,

drawHook = function(self)
	local cs = table.sum(self.control)
	love.graphics.setColor(self.molds[1].color)
	love.graphics.rectangle("fill", 0,0, WIDTH*self.control[1]/cs, 20)
	love.graphics.setColor(self.molds[2].color)
	love.graphics.rectangle("fill", WIDTH, 0, -WIDTH*self.control[2]/cs, 20)
end,

winningConditionSatisfied = function(self)
	return self.control[2] < 800
end,
}

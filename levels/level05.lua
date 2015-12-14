return {

onLoad = function(self, timer)
	self.control[4] = 0
	timer.script(function(wait)
		self.message = "Aaah, Christmas! So much delicious food!"
		wait(3)
		self.message = "Just look at that beautiful bird!"
		wait(5)
		self.message = "MINE! ALL MINE!"
		wait(4)
		self.message = ""
	end)

	self.molds[2].kde:add(function(x,y)
		local c = self.molds[1]:centroid()
		local d = ((x-c.x)/self.map:getWidth())^2 + ((y-c.y)/self.map:getWidth())^2
		return math.exp(-d / .01)
	end)

	self.molds[2].kde:add(function(x,y)
		local c = self.molds[3]:centroid()
		local d = ((x-c.x)/self.map:getWidth())^2 + ((y-c.y)/self.map:getWidth())^2
		return math.exp(-d / .01)
	end)

	self.molds[3].kde:add(function(x,y)
		local c = self.molds[1]:centroid()
		local d = ((x-c.x)/self.map:getWidth())^2 + ((y-c.y)/self.map:getWidth())^2
		return math.exp(-d / .01)
	end)

	self.molds[3].kde:add(function(x,y)
		local c = self.molds[2]:centroid()
		local d = ((x-c.x)/self.map:getWidth())^2 + ((y-c.y)/self.map:getWidth())^2
		return math.exp(-d / .01)
	end)
end,

initMolds = function(map)
	return {
		Entity.Mold(map, 1, 300, {50,92,82}, {1,2,1}, 2),
		Entity.Mold(map, 2, 200, {75,40,20}, {1,1,2}),
		Entity.Mold(map, 3, 200, {20,40,92}, {2,1,1}),
	}
end,

nextLevel = function() end,

drawHook = function(self)
	local cs, x0, x = table.sum(self.control,3)

	x0, x = 0, WIDTH*self.control[1]/cs
	love.graphics.setColor(self.molds[1].color)
	love.graphics.rectangle("fill", x0, 0, x, 20)

	x0, x = x0+x, WIDTH*self.control[2]/cs
	love.graphics.setColor(self.molds[2].color)
	love.graphics.rectangle("fill", x0, 0, x, 20)

	x0, x = x0+x, WIDTH*self.control[3]/cs
	love.graphics.setColor(self.molds[3].color)
	love.graphics.rectangle("fill", x0, 0, x, 20)
end,

winningConditionSatisfied = function(self)
	local cs = table.sum(self.control, 3)
	return self.control[1] / cs > .9
end,
}

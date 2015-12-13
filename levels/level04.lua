return {

onLoad = function(self, timer)
	self.control[4] = 0
	timer.script(function(wait)
		self.message = "Oh, a banana! I LOVE THOSE!"
		wait(3)
		self.message = "Especially the tip"
		wait(5)
		self.message = "Then again, I love all food"
		wait(3)
		self.message = "I wonder if that red dude will let me through"
		wait(5)
		self.message = "Only one way to find out"
		wait(3)
		self.message = "GERONIMO!!!"
		wait(2)
		self.message = ""
	end)

	for i = 1,#self.goals-1 do
		local gx, gy = self.goals[i]:unpack()
		self.molds[2].kde:add(function(x,y)
			local d = ((x-gx)/self.map:getWidth())^2 + ((y-gy)/self.map:getWidth())^2
			return math.exp(-d / .005)
		end)
	end
	self.molds[2].kde:add(function(x,y)
		local c = self.molds[1]:centroid()
		local d = ((x-c.x)/self.map:getWidth())^2 + ((y-c.y)/self.map:getWidth())^2
		return math.exp(-d / .005)
	end)
end,

initMolds = function(map)
	return {
		Entity.Mold(map, 1, 400, {50,92,82}, {1,2,2,2}),
		Entity.Mold(map, 2, 100, {75,40,20}, {1,2,1}, 4),
	}
end,

nextLevel = function()
	return Level.level05
end,

drawHook = function(self)
	love.graphics.setColor(240,240,100)
	local g = self.goals[#self.goals]
	love.graphics.circle('line', g.x, g.y, 5)

	local cs = table.sum(self.control)
	love.graphics.setColor(self.molds[1].color)
	love.graphics.rectangle("fill", 0,0, WIDTH*self.control[1]/cs, 20)
	love.graphics.setColor(self.molds[2].color)
	love.graphics.rectangle("fill", WIDTH, 0, -WIDTH*self.control[2]/cs, 20)
end,

winningConditionSatisfied = function(self)
	return self.goals[#self.goals].reached
end,
}

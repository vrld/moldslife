-- Mold class

return class{
init = function(self, mask, id, N, color, against, maxval)
	assert(id >= 1 and id <= 4, "id must be in [1,4]")

	self.kde = Util.KDE(mask, id)
	self.id = id
	self.mask = mask
	self.color = color
	self.slice = 0
	self.against = against or {1,1,1}
	self.maxval = maxval or 2

	local center, i = vector(0,0), 0
	self.mask:mapPixel(function(x,y,r,g,b,a)
		if ({r,g,b})[self.id] ~= 0 then
			center.x, center.y = center.x + x, center.y + y
			i = i + 1
		end
		return r,g,b,a
	end)
	center = center / i

	for i = 1,N do
		self[i] = self.kde:sample(center)
	end
end;

centroid = function(self)
	local c = vector()
	for _,p in ipairs(self) do
		c.x,c.y = c.x+p.x, c.y+p.y
	end
	return c / #self
end;

update = function(self)
	local i = math.random(#self)
	self[i] = self.kde:sample(self[math.random(#self)])--self:centroid())
	local x,y = self[i].x, self[i].y
	Signal.emit("seed-change", self.id, self[i])

	local r = 4
	local gained, played = false, false
	for i = math.max(0, x-r),math.min(self.mask:getWidth()-1, x+r) do
	for k = math.max(0, y-r),math.min(self.mask:getHeight()-1, y+r) do
		local c = {self.mask:getPixel(i,k)}
		if c[4] > 0 then break end
		local control_before,val = table.findmax(c, 3)
		if val == 0 then control_before = -1 end

		c[self.id] = math.min(c[self.id] + (self.against[control_before] or 1) + 1,
			self.maxval or 2)
		for i = 1,3 do
			c[i] = math.max(0,c[i] - 1)
		end

		local control_after = table.findmax(c, 3)
		if control_before ~= control_after then
			Signal.emit("control-change", control_before, control_after)
			gained = true
			if not played then
				Signal.emit("play-screech", control_before)
				played = true
			end
		end

		self.mask:setPixel(i,k, c[1],c[2],c[3],c[4])
	end end
	if gained then Signal.emit("play-tick") end
end;

draw = function(self, color)
	love.graphics.setColor(color or self.color)
	--for _, p in ipairs(self) do
	--	love.graphics.circle('fill', p.x, p.y, 2)
	--end

	love.graphics.setColor(self.color[1], self.color[2], self.color[3], 20)
	for i = 3,#self do
		local p,q,r = self[i-2], self[i-1], self[i]
		love.graphics.line(p.x, p.y, q.x, q.y, r.x, r.y)
	end
end;

addSeed = function(self)
	self[#self+1] = self.kde:sample(self:centroid())
	Signal.emit("seed-change", self.id, self[#self])
end;

removeSeed = function(self)
	self[#self] = nil
end;
}

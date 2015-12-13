-- Kernel density estimate

local function MCMC(s, x0, T, f)
	-- metropolis hastings algorithm
	local x = x0 and x0 or vector(love.math.random(WIDTH), love.math.random(HEIGHT))
	for t = 1,T or 50 do
		local dx, dy = love.math.randomNormal() * s, love.math.randomNormal() * s
		local xc = vector(x.x + dx, x.y + dy)
		local a = f(xc) / f(x)
		if a > love.math.random() then
			x = xc
		end
	end
	return x
end

return function(mask, id)
	return setmetatable({
		mask = mask;
		id = id;

		clear = function(self)
			for i = #self,1,-1 do self[i] = nil end
		end;

		add = function(self, f)
			self[#self+1] = f
		end;

		sample = function(self, x0, s, T)
			return MCMC(s or 100, x0 or vector(WIDTH/2, HEIGHT/2), T or 500, self)
		end;

		render = function(self)
			local id = love.image.newImageData(WIDTH, HEIGHT)
			local max = 0
			id:mapPixel(function(x,y)
				max = math.max(self(vector(x,y)), max)
				return 0,0,0,0
			end)
			id:mapPixel(function(x,y)
				local v = self(vector(x,y)) / max * 255
				return v,v,v,255
			end)
			return id
		end;

	}, {__call = function(self, p)
		local x,y = p.x, p.y

		if x < 0 or x >= self.mask:getWidth() or y < 0 or y >= self.mask:getHeight() then
			return 0
		end
		local c = {self.mask:getPixel(math.floor(x), math.floor(y))}
		if c[self.id] == 0 or c[self.id] < c[1] or c[self.id] < c[2] or c[self.id] < c[3] or c[self.id] < c[4] then
			return 0
		end

		local r = 0
		for i = 1,#self do
			r = r + self[i](x,y) / (#self+1)
		end

		-- uniform prior
		if r == 0 then
			r = 1 / (self.mask:getHeight()*self.mask:getWidth()) / (#self+1)
		end

		return r
	end})
end

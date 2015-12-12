-- Kernel density estimate

local function MCMC(s, x0, T, f)
	-- metropolis hastings algorithm
	x = x0 and x0 or vector(love.math.random(WIDTH), love.math.random(HEIGHT))
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
			return MCMC(s or 50, x0 or vector(WIDTH/2, HEIGHT/2), T or 500, self)
		end
	}, {__call = function(self, p)
		local x,y = p.x, p.y

		if x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT or
		   self.mask:getPixel(math.floor(x), math.floor(y)) ~= self.id then
			return 1 / (WIDTH*HEIGHT)^2
		end

		local r = 0
		for i = 1,#self do
			r = r + self[i](x,y) / (#self+1) * i -- more weight on later kernels
		end

		-- uniform prior
		r = r + 1 / (WIDTH*HEIGHT) / (#self+1)

		return r
	end})
end

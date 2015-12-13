local st = {}

local controlSeedRatio = 25
local addSeedEveryNIterations = 100
local mapShader
local tick

function st:init()
	mapShader = love.graphics.newShader[[
	extern number id;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
	{
		vec4 c = Texel(tex, tc);
		int i = int(id);
		if (c[i] == 0 || c[i] < c[0] || c[i] < c[1] || c[i] < c[2] || c[i] < c[3])
			return vec4(0,0,0,0);

		return color;
	}]]

	Signal.register('control-change', function(from, to)
		if from ~= -1 and from <= #self.level.molds then
			local m = self.level.molds[from]
			self.level.control[from] = self.level.control[from] - 1
			-- check if seeds need to be removed
			for i = #m,1,-1 do
				local c = {self.level.map:getPixel(math.floor(m[i].x), math.floor(m[i].y))}
				if c[from] < c[to] then
					table.remove(m, i)
					self.level.molds[to]:addSeed()
				end
			end
		end
		self.level.control[to] = self.level.control[to] + 1
	end)

	Signal.register('seed-change', function(id, v)
		for _, g in ipairs(self.level.goals) do
			if g:dist(v) < 10 then
				g.reached = true
			end
		end
	end)
	self.post = shine.vignette()
				:chain(shine.desaturate())
				:chain(shine.glowsimple())
	self.post.min_luma = .8
	self.post.strength = .3
	self.post.tint = {200,255,230}

	local grains = {}
	for i = 1,5 do
		local l = math.floor(44100 * love.math.random() * .08 + .1)
		local sd = love.sound.newSoundData(l, 44100, 16, 1)
		local r = 0
		for i = 0,l-1 do
			if love.math.random() > .5 then
				r = math.max(-1,math.min(1, r + love.math.random()))
			end
			sd:setSample(i, r*.1*(1-(2*i/l-1)^2))
		end
		grains[#grains+1] = sd
	end
	tick = love.audio.newSource(grains)

	Signal.register("play-tick", function()
		tick:play()
	end)


	local grains = {}
	for i = 1,10 do
		local l = math.floor(44100 * love.math.random() * .08 + .1)
		local sd = love.sound.newSoundData(l, 44100, 16, 1)
		local f = love.math.random() * 220 + 110
		local s = 0
		local r = love.math.random() * .2 + .4
		for i = 0,l-1 do
			if love.math.random() > r then
				s = math.sin(i/44100 * 2*math.pi*f)
			end
			sd:setSample(i, s*.05*(1-(2*i/l-1)^2))
		end
		grains[#grains+1] = sd
	end
	screech = love.audio.newSource(grains)

	Signal.register("play-screech", function()
		screech:play()
	end)
end

local pos = {}
function st:enter(_, level)
	self.timer = Timer.new()
	pos = {}

	self.level = level
	self.level.reset(self.timer)

	love.graphics.setLineJoin('none')
	love.graphics.setLineWidth(.5)

	local ms = 0
	for i,mold in ipairs(self.level.molds) do
		ms = ms + #mold
	end
	for i,mold in ipairs(self.level.molds) do
		self.timer.script(function(wait)
			wait(0)
			while true do
				mold:update()
				self.level.map_img:refresh()
				local s = #mold / ms
				local w = .1 - s*s * .08
				wait(w)
			end
		end)
	end
end

function st:draw()
	love.graphics.setColor(255,255,255)
	self.post:draw(function()
		-- draw map
		love.graphics.setShader(mapShader)
		for _, mold in ipairs(self.level.molds) do
			love.graphics.setColor(mold.color)
			mapShader:send('id', mold.id - 1)
			love.graphics.draw(self.level.map_img)
		end

		love.graphics.setColor(152,167,148)
		mapShader:send('id', 3)
		love.graphics.draw(self.level.map_img)
		love.graphics.setShader()

		love.graphics.setBlendMode('additive')
		for _, mold in ipairs(self.level.molds) do
			mold:draw()
		end
		love.graphics.setBlendMode('alpha')

		for i,p in ipairs(pos) do
			local s = i/#pos * 255
			love.graphics.setColor(s,s,s)
			love.graphics.circle('line', p[1], p[2], 10)
		end

		self.level:drawHook()

		love.graphics.setColor(40,250,200)
		love.graphics.setFont(Font[30])
		love.graphics.printf(self.level.message, 0,HEIGHT-50,WIDTH, "center")
	end)
end

function st:update(dt)
	self.timer.update(dt)
	self.level.everyFrame()
	if self.level.winningConditionSatisfied(self.level) then
		GS.switch(State.won)
	end
end

function st:mousereleased(mx,my,btn)
	if btn == 'l' then
		self.level.molds[1].kde:add(function(x,y)
			local d = ((x-mx)/self.level.map:getWidth())^2 + ((y-my)/self.level.map:getWidth())^2
			return math.exp(-d / .005)
		end)
		while #self.level.molds[1].kde >= 5 do
			table.remove(self.level.molds[1].kde, 1)
		end
	else
		self.level.molds[1].kde:clear()
		pos = {}
	end

	pos[#pos+1] = {mx,my}
	while #pos > #self.level.molds[1].kde do
		table.remove(pos, 1)
	end
end

function st:keypressed(key)
	if key == ' ' then
		st:mousereleased(love.mouse.getX(), love.mouse.getY(), 'r')
	elseif key == 'r' then
		local id = self.level.molds[1].kde:render()
		id:encode("foo.png")
	end
end

return st

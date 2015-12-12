local st = {}

local base = (...):gsub('%.', '/') .. '/'
local duration_show_splash = .5 -- in seconds
local color_fg     = {220,214,204}
local color_bg     = {30,28,25}
local cell_width   = 25
local cell_height  = 25
local cell_spacing = 5

local callbacks = {}
function callbacks.after(f) callbacks.after = f end

-- ANIMATION
-- 1 -> draw square, 0 -> blank
local _ = 0
local sequence, board = {}, {
	{1,_,1,_,1,1,_,1,_,_,1,1,_},
	{1,_,1,_,1,_,_,1,_,_,1,_,1},
	{_,1,_,_,1,_,_,1,1,_,1,1,_},
}

-- GRAPHICS
local offset = {
	x = (love.graphics.getWidth() - #board[1] * (cell_spacing + cell_width)) / 2,
	y = (love.graphics.getHeight() - #board   * (cell_spacing + cell_height)) / 2,
}
local haze = {sx = 0, sy = 1}

-- SOUND
local woosh
local woosh_length = 1.3

local tick = {}
for k = 1,10 do
	local len = 0.06 + math.random() * .2
	local attack, release = 0.1 * len, 0.9 * len
	local freq = 300 + (math.random() * .5 + .5) * 50
	tick[k] = love.sound.newSoundData(len * 44100, 44100, 16, 1)
	for i = 0,len*44100-1 do
		local t = i / 44100
		local sample = math.sin(t * freq * math.pi * 2)
		local env = t < attack and (t/attack)^4 or (1 - (t-attack)/(release-attack))^4
		sample = sample * env * .1
		tick[k]:setSample(i, sample)
	end
end

function st:init()
	Image.haze:setFilter('linear', 'linear')
end

function st:enter(_, to)
	woosh = nil
	sequence = {}
	for i = 1,#board do
		for k = 1,#board[i] do
			sequence[#sequence+1] = {y = i, x = k}
			if board[i][k] == 0 then
				sequence[#sequence+1] = {y = i, x = k}
			end
			board[i][k] = {a = 0}
		end
	end

	-- randomize animation
	for i = 1,#sequence do
		local k = math.random(i,#sequence)
		sequence[i], sequence[k] = sequence[k], sequence[i]
		sequence[i].dt = 1 / #sequence
	end

	Timer.script(function(wait)
		for i,s in ipairs(sequence) do
			if board[s.y][s.x].a == 0 then
				Timer.tween(s.dt, board[s.y][s.x], {a=255})
			else
				Timer.tween(s.dt, board[s.y][s.x], {a=0})
			end
			local src = love.audio.newSource(tick[math.random(#tick)])
			src:play()
			wait(s.dt)
		end

		wait(duration_show_splash)
		Sound.static.woosh:play()

		Timer.tween(.75, haze, {
			sx = -2* love.graphics.getWidth() / Image.haze:getWidth()
		})
		wait(woosh_length - 1)

		GS.transition(to, 1)
	end)

	love.graphics.setBackgroundColor(color_bg)
end

function st:draw()
	love.graphics.setColor(255,255,255)
	for i = 1,#board do
		local y = offset.y + (i-1) * (cell_height + cell_spacing)
		for k = 1,#board[1] do
			if board[i][k].a ~= 0 then
				color_fg[4] = board[i][k].a
				love.graphics.setColor(color_fg)
				local x = offset.x + (k-1) * (cell_width + cell_spacing)
				love.graphics.rectangle('fill', x,y, cell_width, cell_height)
			end
		end
	end

	love.graphics.setColor(color_bg)
	love.graphics.draw(Image.haze, love.graphics.getWidth(),0,0,
	                   haze.sx, love.graphics.getHeight() / Image.haze:getHeight())
end

return st

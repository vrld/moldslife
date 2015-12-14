Timer  = require 'hump.timer'
GS     = require 'hump.gamestate'
vector = require 'hump.vector'
class  = require 'hump.class'
Signal = require 'hump.signal'
shine  = require 'shine'
gui    = require 'Quickie'
require 'slam'

function table.findmax(t, from, to)
	if not to then
		from, to = 1, from
	end
	if not to then to = #t end

	local max, idx_max = t[from], from
	for i = from+1,to do
		if t[i] > max then
			max, idx_max = t[i], i
		end
	end
	return idx_max, max
end

function table.sum(t)
	local s = 0
	for _,v in ipairs(t) do
		s = s + v
	end
	return s
end

function table.prod(t)
	local p = 0
	for _,v in ipairs(t) do
		p = p * v
	end
	return p
end

function GS.transition(to, duration, ...)
	duration = duration or 1

	local fade_color, t = {0,0,0,0}, 0
	local draw, switch, transition = GS.draw, GS.switch, GS.transition
	GS.draw = function()
		draw()
		color = {love.graphics.getColor()}
		love.graphics.setColor(fade_color)
		love.graphics.rectangle('fill', 0,0, WIDTH, HEIGHT)
		love.graphics.setColor(color)
	end
	-- disable switching states while in transition
	GS.switch = function() end
	GS.transition = function() end

	local args = {...}
	Timer.script(function(wait)
		Timer.tween(duration/2, fade_color, {[4] = 255}, 'linear')
		wait(duration / 2)
		switch(to, unpack(args))
		Timer.tween(duration/2, fade_color, {[4] = 0}, 'linear')
		wait(duration / 2)
		GS.draw, GS.switch, GS.transition = draw, switch, transition
	end)
end

local function Lazy(f)
	return setmetatable({}, {__index = function(t,k)
		local v = f(k)
		t[k] = v
		return v
	end})
end

State = Lazy(function(path) return require('states.' .. path) end)
Util = Lazy(function(path) return require('util.' .. path) end)
Entity = Lazy(function(path) return require('entities.' .. path) end)
Level = Lazy(function(path) return Util.loadLevel(path) end)
Image = Lazy(function(path)
	local i = love.graphics.newImage('img/'..path..'.png')
	i:setFilter('nearest', 'nearest')
	return i
end)
Font  = Lazy(function(arg)
	if tonumber(arg) then
		return love.graphics.newFont('font/Turtles.ttf', arg)
	end
	return Lazy(function(size) return love.graphics.newFont('font/'..arg..'.ttf', size) end)
end)
Sound = {
	static = Lazy(function(path) return love.audio.newSource('snd/'..path..'.ogg', 'static') end),
	stream = Lazy(function(path) return love.audio.newSource('snd/'..path..'.ogg', 'stream') end)
}

function love.load()
	WIDTH, HEIGHT = love.window.getWidth(), love.window.getHeight()

	local l = math.floor(44100 * .01)
	local sd = love.sound.newSoundData(l, 44100, 16, 1)
	for i = 0,l-1 do
		sd:setSample(i, (love.math.random()*2-1)*.05)
	end
	selectSound = love.audio.newSource(sd)

	Sound.stream.letscallitmusic:setVolume(.4)

	GS.registerEvents()
	GS.switch(State.splash, State.menu)
	--GS.switch(State.menu)
	--GS.switch(State.game, Level.level01)
	--GS.switch(State.game, Level.level02)
	--GS.switch(State.game, Level.level03)
	--GS.switch(State.game, Level.level04)
	--GS.switch(State.game, Level.level05)

	--Timer.every(0.25, function()
	--	love.window.setTitle(love.timer.getFPS())
	--end)

	gui.core.style.gradient:set(255,255)
	local instance
	chkMusic = {text = "Music?", checked = true, pos = {WIDTH-100, HEIGHT-30}, size={20,20}}
	Timer.after(5, function()
		Signal.emit("play-music", true)
		Timer.every(30, function()
			if chkMusic.checked and instance:isStopped() then
				Signal.emit("play-music", true)
			end
		end)
	end)

	Signal.register("play-music", function(play)
		if play then
			instance = Sound.stream.letscallitmusic:play()
		else
			Sound.stream.letscallitmusic:stop()
		end
	end)
end

function love.quit()
end

function love.update(dt)
	Timer.update(dt)

	love.graphics.setFont(Font[15])
	if gui.Checkbox(chkMusic) then
		Signal.emit("play-music", chkMusic.checked)
	end
end

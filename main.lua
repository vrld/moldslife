Timer  = require 'hump.timer'
GS     = require 'hump.gamestate'
vector = require 'hump.vector'
class  = require 'hump.class'
Signal = require 'hump.signal'
shine = require 'shine'
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

function GS.transition(to, duration)
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

	Timer.script(function(wait)
		Timer.tween(duration/2, fade_color, {[4] = 255}, 'linear')
		wait(duration / 2)
		switch(to)
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

	GS.registerEvents()
	--GS.switch(State.splash, State.menu)
	GS.switch(State.menu)
	--GS.switch(State.game, Level.level01)
	--GS.switch(State.game, Level.level02)
	--GS.switch(State.game, Level.level03)
	--GS.switch(State.game, Level.level04)

	Timer.every(0.25, function()
		love.window.setTitle(love.timer.getFPS())
	end)
end

function love.quit()
end

function love.update(dt)
	Timer.update(dt)
end

Timer  = require 'hump.timer'
GS     = require 'hump.gamestate'
vector = require 'hump.vector'
class  = require 'hump.class'
Signal = require 'hump.signal'
require 'slam'

function Timer.script(f)
	local co = coroutine.wrap(f)
	co(function(t)
		Timer.after(t, co)
		coroutine.yield()
	end)
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
Image = Lazy(function(path)
	local i = love.graphics.newImage('img/'..path..'.png')
	i:setFilter('nearest', 'nearest')
	return i
end)
Font  = Lazy(function(arg)
	if tonumber(arg) then
		return love.graphics.newFont('font/slkscr.ttf', arg)
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
	GS.switch(State.splash, State.menu)
end

function love.quit()
end

function love.update(dt)
	Timer.update(dt)
end

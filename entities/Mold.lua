-- Mold class

local mapShader

return class{
init = function(self, mask, id, N)
	if not mapShader then
		mapShader = love.graphics.newShader[[
		extern number id;
		vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
		{
			vec4 c = Texel(tex, tc);
			if (c[0] != id)
				discard;

			return color;
		}]]
	end

	self.kde = Util.KDE(mask, id)
	self.id = id
	self.mask = mask
	self.mask_img = love.graphics.newImage(mask)

	for i = 1,N do
		self[i] = self.kde:sample()
	end
end;

update = function(self, dt)
	self[math.random(#self)] = self.kde:sample()
end;

drawMap = function(self, color)
	love.graphics.setShader(mapShader)
	mapShader:send('id', self.id / 255)
	love.graphics.setColor(color)
	love.graphics.draw(self.mask_img)
	love.graphics.setShader()
end;

drawMold = function(self, color)
	love.graphics.setBlendMode('additive')
	love.graphics.setColor(color)
	for _, p in ipairs(self) do
		love.graphics.circle('fill', p.x, p.y, 3)
	end

	love.graphics.setLineJoin('none')
	love.graphics.setColor(color[1], color[2], color[3], 30)
	for i = 3,#self do
		local p,q,r = self[i-2], self[i-1], self[i]
		love.graphics.line(p.x, p.y, q.x, q.y, r.x, r.y)
	end
	love.graphics.setBlendMode('alpha')
end;
}

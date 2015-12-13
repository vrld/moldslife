local ffi = require 'ffi'

local function new(dtype, ...)
	local shape = {...}
	if type(dtype) == "number" then
		table.insert(shape, dtype, 1)
		dtype = "float"
	end
	local dims = #shape
	local size = table.prod(shape)
	local data = ffi.new(dtype.."[?]", size)

	return setmetatable({
		_data = data,
		shape = shape,
		dims = dims,
		size = size,
		copy = function(self)
			local copy = new(dtype, unpack(shape))
			ffi.copy(copy._data, data, size * ffi.sizeof(dtype))
		end
	}, {__call = function(_, ...)
		local nargs = select('#', ...)
		assert(nargs >= dims and nargs <= dims+1, "Invalid nuber of arguments")
		local idx = 0
		local dprod = 1
		for i = 1,dims do
			idx = idx + (select('#', i)-1) * dprod
			dprod = dprod * shape[i]
		end
		if nargs <= dims then
			return data[idx]
		end
		data[idx] = select(dims+1, ...)
	end})
end

return new

local mvector_meta = {}

mvector = {
	new = function(a,b,c)
		if type(a) == "table" then
			assert(a.x and a.y and a.z, "Invalid vector passed to mvector.new()")
			return setmetatable({x=a.x, y=a.y, z=a.z}, mvector_meta)
		elseif a then
			assert(b, "Invalid arguments for mvector.new()")
			return setmetatable({x=a, y=b, z=c or 0}, mvector_meta)
		end
		return setmetatable({x=0, y=0, z=0}, mvector_meta)
	end,
	parse = function(str)
		if str == nil then
			return nil
		end

		local p = {}
		p.x, p.y, p.z = string.match(str, "^([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
		if p.x and p.y and p.z then
			p.x = tonumber(p.x)
			p.y = tonumber(p.y)
			p.z = tonumber(p.z)
			return setmetatable(p, mvector_meta)
		end
		p = {}
		p.x, p.y, p.z = string.match(str, "^%( *([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+) *%)$")
		if p.x and p.y and p.z then
			p.x = tonumber(p.x)
			p.y = tonumber(p.y)
			p.z = tonumber(p.z)
			return setmetatable(p, mvector_meta)
		end
		return nil
	end,
	make_metavector = function(o)
		return setmetatable(o,mvector_meta)
	end,
	to_string = function(pos, decimal_places)
		local x = pos.x
		local y = pos.y
		local z = pos.z
		if decimal_places ~= nil then
			x = string.format("%." .. decimal_places .. "f", x)
			y = string.format("%." .. decimal_places .. "f", y)
			z = string.format("%." .. decimal_places .. "f", z)
		end
		return "(" .. x .. "," .. y .. "," .. z .. ")"
	end
}

function mvector.is_metavector(o)
	return type(o) == "table" and rawget(getmetatable(o), "__index")==mvector
end

local nv = mvector.new
local ts = mvector.to_string

mvector_meta.__index = mvector
mvector_meta.__add = function(a,b)
	if type(b) == "number" then
		return nv(a.x+b,a.y+b,a.z+b)
	else
		if type(a) == "number" then
			return nv(a+b.x,a+b.y,a+b.z)
		else
			return nv(a.x+b.x,a.y+b.y,a.z+b.z)
		end
	end
end
mvector_meta.__sub = function(a,b)
	if type(b) == "number" then
		return nv(a.x-b,a.y-b,a.z-b)
	else
		if type(a) == "number" then
			return nv(a-b.x,a-b.y,a-b.z)
		else
			return nv(a.x-b.x,a.y-b.y,a.z-b.z)
		end
	end
end
mvector_meta.__mul = function(a,b)
	if type(b) == "number" then
		return nv(a.x*b,a.y*b,a.z*b)
	else
		if type(a) == "number" then
			return nv(a*b.x,a*b.y,a*b.z)
		else
			return nv(a.x*b.x,a.y*b.y,a.z*b.z)
		end
	end
end
mvector_meta.__div = function(a,b)
	if type(b) == "number" then
		return nv(a.x/b,a.y/b,a.z/b)
	else
		if type(a) == "number" then
			return nv(a/b.x,a/b.y,a/b.z)
		else
			return nv(a.x/b.x,a.y/b.y,a.z/b.z)
		end
	end
end
mvector_meta.__unm = function(a)
	return nv(-a.x,-a.y,-a.z)
end
mvector_meta.__tostring = function(a)
	return ts(a)
end
mvector_meta.__concat = function(a,b)
	local str_a
	if mvector.is_metavector(a) then
		str_a = ts(a)
	else
		str_a = a
	end
	if mvector.is_metavector(b) then
		return str_a .. ts(b)
	else
		return str_a .. b
	end
end
mvector_meta.__eq = function(a,b)
	return a.x==b.x and a.y==b.y and a.z==b.z
end

function mvector.test()
	local v1 = mvector.new(2,4,5)
	assert(v1+1 == mvector.new(3,5,6))
	assert(v1*2 == mvector.new(4,8,10))
	local v2 = mvector.new(5,4,2)
	assert(v1+v2 == mvector.new(7,8,7))
	assert(v1*v2 == mvector.new(10,16,10))
	assert(mvector.new(0,0,0)-v1 == -v1)
	assert(mvector.parse(v1.."") == v1)
	assert(tostring(v1) == v1:to_string())
end

return mvector

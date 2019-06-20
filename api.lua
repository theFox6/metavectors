local mvector_meta = {}

mvector = {
	new = function(a,b,c)
		return setmetatable(vector.new(a,b,c), mvector_meta)
	end,
	parse = function(str)
		return setmetatable(minetest.string_to_pos(str), mvector_meta)
	end,
	make_metavector = function(o)
		return setmetatable(o,mvector_meta)
	end,
}

function mvector.is_metavector(o)
	return type(o) == "table" and rawget(getmetatable(o), "__index")==mvector
end

local nv = mvector.new

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
	return minetest.pos_to_string(a)
end
mvector_meta.__concat = function(a,b)
	local str_a
	if mvector.is_metavector(a) then
		str_a = minetest.pos_to_string(a)
	else
		str_a = a
	end
	if mvector.is_metavector(b) then
		return str_a .. minetest.pos_to_string(b)
	else
		return str_a .. b
	end
end
mvector_meta.__eq = function(a,b)
	return a.x==b.x and a.y==b.y and a.z==b.z
end

return mvector

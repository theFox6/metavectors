local mvector = metavectors.require("api")

benchmark.register("metavectors:metavectors",{
	warmup = 5000,
	loops = 2000,
	before = function()
		local x = math.ceil(math.random()*100)
		local y = math.ceil(math.random()*100)
		local z = math.ceil(math.random()*100)
		return {x,y,z}
	end,
	run = function(data)
		local v = mvector.new(data[1],data[2],data[3])
		assert(v + v - v == v)
		assert(v.." test" == minetest.pos_to_string(v).." test")
		assert(v*2 == v+v)
		assert(v*v/2)
		assert(mvector.parse(minetest.pos_to_string(v)) == v)
	end,
})

benchmark.register("metavectors:standardvectors",{
	warmup = 5000,
	loops = 2000,
	before = function()
		local x = math.ceil(math.random()*100)
		local y = math.ceil(math.random()*100)
		local z = math.ceil(math.random()*100)
		return {x,y,z}
	end,
	run = function(data)
		local v = vector.new(data[1],data[2],data[3])
		assert(vector.equals(vector.subtract(vector.add(v,v),v),v))
		assert(minetest.pos_to_string(v).." test")
		assert(vector.equals(vector.multiply(v,2),vector.add(v,v)))
		assert(vector.divide(vector.multiply(v,v),2))
		assert(vector.equals(minetest.string_to_pos(minetest.pos_to_string(v)),v))
	end,
})

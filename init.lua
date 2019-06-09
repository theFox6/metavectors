local init = os.clock()
minetest.log("action", "["..minetest.get_current_modname().."] loading...")

metavectors = {}
local modpath = minetest.get_modpath("metavectors")

local modules = {
  init = metavectors -- just in case anybody tries funny stuff
}

function metavectors.require(module)
  if not modules[module] then
    modules[module] = dofile(modpath.."/"..module..".lua") or true
  end
  return modules[module]
end

metavectors.metavector = metavectors.require("api")

if minetest.get_modpath("benchmark_engine") then
	metavectors.require("benchmarks")
end

local time_to_load = os.clock() - init
minetest.log("action","loaded in %.4f s", time_to_load)

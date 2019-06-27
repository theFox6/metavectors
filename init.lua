local init = os.clock()
minetest.log("action", "["..minetest.get_current_modname().."] loading...")

metavector_mod = {}
local modpath = minetest.get_modpath("metavectors")

local modules = {
  init = metavector_mod -- just in case anybody tries funny stuff
}

function metavector_mod.require(module)
  if not modules[module] then
    modules[module] = dofile(modpath.."/"..module..".lua") or true
  end
  return modules[module]
end

metavector_mod.metavector = metavector_mod.require("metavectors")

if minetest.get_modpath("benchmark_engine") then
	metavector_mod.require("benchmarks")
end

local time_to_load = os.clock() - init
minetest.log("action","loaded in %.4f s", time_to_load)

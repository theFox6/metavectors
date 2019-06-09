# metavectors
A mintetest mod adding vectors that support opperators.
(eg. v1 + v2)

To get the vectors use `metavectors.metavector` or `metavectors.require("api")`.

```lua
local metavector = metavectors.require("api")
local v1 = mvector.new(x,y,z)
local v2 = mvector.new(aVector)
local distance = v1-v2
```

##benchmarks
To see the performance of metavectors compared to minetest's vector utils install the benchmark_engine mod.
The benchmarks "metavectors:metavectors" and "metavectors:standardvectors" will then be added.

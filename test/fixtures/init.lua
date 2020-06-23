local mod1 = require('dir.mod1')
local mod2 = require('dir.mod2')

local fns = {}

function fns.a()
    return 1
end

function fns.b()
    return 1
end

for _ = 1, 3 do
    fns.a()
end
mod1.b()
mod2()
require('luacov.runner').shutdown()
os.exit()

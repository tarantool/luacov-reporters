local fio = require('fio')
local Capture = require('luatest.capture')

local helper = {}

helper.root = fio.dirname(fio.dirname(fio.abspath(package.search('luacov.reporters_utils'))))

-- cdata errors friendly assert compatible with fio calls.
local function assert(val, message, ...)
    if not val or val == nil then
        error(message, 2)
    end
    return val, message, ...
end

-- Luacov saves a lot of it's state to global config and doesn't allow to override config.
-- So it's better to unload it completely before running a report.
local function unload_luacov()
    local prefix = 'luacov.'
    for name in pairs(package.loaded) do
        if name:sub(1, #prefix) == prefix then
            package.loaded[name] = nil
        end
    end
end

function helper.get_report(reporter, config)
    local fixtures_path = fio.pathjoin(helper.root, 'test', 'fixtures')
    local report_path = fio.pathjoin(helper.root, 'tmp', 'test.luacov.report.out')
    local stats_path = fio.pathjoin(helper.root, 'tmp', 'test.luacov.stats.out')

    for _, file in ipairs({report_path, stats_path}) do
        if fio.path.exists(file) then
            assert(fio.unlink(file))
        end
    end

    local workdir = fio.cwd()
    fio.chdir(fixtures_path)

    assert(os.execute(arg[-1] .. ' -l luacov -l init') == 0, 'collecting stats failed')
    unload_luacov()
    local capture = Capture:new()
    capture:wrap(true, function()
        config = config or {}
        config.reporter = reporter
        config.statsfile = stats_path
        config.reportfile = report_path
        require('luacov.runner').run_report(config)
    end)

    fio.chdir(workdir)

    local result = capture:flush()
    result.report = assert(fio.open(report_path)):read()
    return result
end

return helper

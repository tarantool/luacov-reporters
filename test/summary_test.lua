local t = require('luatest')
local g = t.group()

local helper = require('test.helper')
local Reporter = require('luacov.reporter.summary')

local expected_report =
[[==============================================================================
Summary
==============================================================================

File         Hits Missed Coverage
---------------------------------
dir/mod1.lua 5    1      83.33%
init.lua     11   2      84.62%
dir/mod2.lua 1    0      100.00%
---------------------------------
Total        17   3      85.00%
]]

g.test_report = function()
    local result = helper.get_report('summary')
    t.assert_equals(result.report, expected_report)
    t.assert_equals(result.stdout, '')
    t.assert_equals(result.stderr, '')
end

g.test_report_with_print_error = function()
    local result = helper.get_report('summary', {print_report = true})
    t.assert_equals(result.report, expected_report)
    t.assert_equals(result.stdout, expected_report .. '\n')
    t.assert_equals(result.stderr, '')
end

g.test_remove_key_prefix = function()
    local subject = Reporter.remove_key_prefix
    t.assert_equals(subject({
        ['/qwe/rty/uio'] = {1},
        ['/asd/rty/asd/cvb'] = {2},
        ['/qwe/rty/dfg'] = {3},
    }, '/qwe/'), {
        ['rty/uio'] = {1},
        ['/asd/rty/asd/cvb'] = {2},
        ['rty/dfg'] = {3},
    })
end

g.test_sort_summary = function()
    local subject = Reporter.sort_summary
    t.assert_equals(subject({
        full2 = {hits = 10, miss = 0},
        empty1 = {hits = 2, miss = 1},
        empty2 = {hits = 1, miss = 2},
        full1 = {hits = 0, miss = 0},
    }), {
        'empty2',
        'empty1',
        'full1',
        'full2',
    })
end

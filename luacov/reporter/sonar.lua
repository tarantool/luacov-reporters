local luacov_reporter = require('luacov.reporter')
local utils = require('luacov.reporters_utils')

local Reporter = setmetatable({}, luacov_reporter.ReporterBase)
Reporter.__index = Reporter

function Reporter.report()
    return luacov_reporter.report(Reporter)
end

function Reporter:on_start()
    self.remove_prefix = utils.cwd() .. '/'
    self:write('<coverage version="1">\n')
end

function Reporter:on_end()
    self:write('</coverage>\n')
end

function Reporter:on_new_file(filename)
    filename = utils.remove_prefix(filename, self.remove_prefix)
    self:write(('  <file path="%s">\n'):format(filename))
end

function Reporter:on_end_file(_)
    self:write('  </file>\n')
end

local function line_covered(lineno, covered)
    return ('    <lineToCover lineNumber="%d" covered="%s"/>\n'):format(lineno, covered)
end

function Reporter:on_hit_line(_, lineno)
    self:write(line_covered(lineno, 'true'))
end

function Reporter:on_mis_line(_, lineno)
    self:write(line_covered(lineno, 'false'))
end

return Reporter

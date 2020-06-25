local luacov_reporter = require('luacov.reporter')
local utils = require('luacov.reporters_utils')

-- Outputs only summary from default reporter with removed common path prefix
-- and sorted by coverage.
local Reporter = setmetatable({}, luacov_reporter.ReporterBase)
Reporter.__index = Reporter

function Reporter.report()
    return luacov_reporter.report(Reporter)
end

Reporter.on_start = assert(luacov_reporter.DefaultReporter.on_start)

function Reporter:on_end_file(filename, hits, miss)
    self._summary[filename] = {hits = hits, miss = miss}
end

function Reporter:on_end(...)
    local prefix = utils.cwd() .. '/'
    self._summary = self.remove_key_prefix(self._summary, prefix)
    self._files = self.sort_summary(self._summary)
    return luacov_reporter.DefaultReporter.on_end(self, ...)
end

function Reporter:close(...)
    luacov_reporter.DefaultReporter.close(self, ...)
    if self._cfg.print_report then
        print(io.open(self._cfg.reportfile):read('*a'))
    end
end

function Reporter.remove_key_prefix(tbl, prefix)
    local result = {}
    for path, value in pairs(tbl) do
        result[utils.remove_prefix(path, prefix)] = value
    end
    return result
end

function Reporter.sort_summary(summary)
    local files = {}
    for file in pairs(summary) do
        table.insert(files, file)
    end

    local function coverage(file)
        local total = summary[file].hits + summary[file].miss
        if total == 0 then
            return 1
        else
            return summary[file].hits / total
        end
    end

    table.sort(files, function(a, b)
        local cov_a = coverage(a)
        local cov_b = coverage(b)
        if cov_a == cov_b then
            return a < b
        else
            return cov_a < cov_b
        end
    end)
    return files
end

return Reporter

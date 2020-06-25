local t = require('luatest')
local g = t.group()

local helper = require('test.helper')

g.test_report = function()
    local result = helper.get_report('sonar')
    t.assert_equals(result.report, [[<coverage version="1">
  <file path="dir/mod1.lua">
    <lineToCover lineNumber="1" covered="true"/>
    <lineToCover lineNumber="3" covered="true"/>
    <lineToCover lineNumber="4" covered="false"/>
    <lineToCover lineNumber="7" covered="true"/>
    <lineToCover lineNumber="8" covered="true"/>
    <lineToCover lineNumber="11" covered="true"/>
  </file>
  <file path="dir/mod2.lua">
    <lineToCover lineNumber="2" covered="true"/>
  </file>
  <file path="init.lua">
    <lineToCover lineNumber="1" covered="true"/>
    <lineToCover lineNumber="2" covered="true"/>
    <lineToCover lineNumber="4" covered="true"/>
    <lineToCover lineNumber="6" covered="true"/>
    <lineToCover lineNumber="7" covered="true"/>
    <lineToCover lineNumber="10" covered="true"/>
    <lineToCover lineNumber="11" covered="false"/>
    <lineToCover lineNumber="14" covered="true"/>
    <lineToCover lineNumber="15" covered="true"/>
    <lineToCover lineNumber="17" covered="true"/>
    <lineToCover lineNumber="18" covered="true"/>
    <lineToCover lineNumber="19" covered="true"/>
    <lineToCover lineNumber="20" covered="false"/>
  </file>
</coverage>
]])
    t.assert_equals(result.stdout, '')
    t.assert_equals(result.stderr, '')
end

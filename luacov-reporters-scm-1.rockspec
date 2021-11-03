package = 'luacov-reporters'
version = 'scm-1'
source = {
    url = 'git+https://github.com/tarantool/luacov-reporters.git',
    branch = 'master',
}
description = {
    summary = 'Sonarqube reporter for luacov',
    homepage = 'https://github.com/tarantool/luacov-reporters',
    license = 'MIT',
}
dependencies = {
    'lua >= 5.1',
}
build = {
    type = 'builtin',
    modules = {
        ['luacov.reporters_utils'] = 'luacov/reporters_utils.lua',
        ['luacov.reporter.sonar'] = 'luacov/reporter/sonar.lua',
        ['luacov.reporter.summary'] = 'luacov/reporter/summary.lua',
    },
}

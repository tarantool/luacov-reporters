# luacov-reporters

Collection of reporters for [luacov](https://github.com/keplerproject/luacov)

## Usage

### Tarantool

```bash
tarantoolctl rocks install luacov
tarantoolctl rocks install luacov-reporters
.rocks/bin/luacov -r reporter_name .
```

### Lua

```bash
luarocks install luacov
luarocks install https://raw.githubusercontent.com/tarantool/luacov-reporters/master/luacov-reporters-scm-1.rockspec
luacov -r reporter_name .
```

## Available reporters

- `summary` - Outputs only summary from default reporter with removed common path prefix and sorted by coverage.
  Add `print_report = true` to `.luacov` config file to print generated report to stdout.
- `sonar` - reporter for [SonarQube](https://docs.sonarqube.org/latest/analysis/generic-test/).

## License

MIT

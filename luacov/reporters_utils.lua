local utils = {}

function utils.cwd()
    return io.popen('pwd'):read()
end

function utils.remove_prefix(str, prefix)
    if str:sub(1, #prefix) == prefix then
        return str:sub(#prefix + 1, #str)
    else
        return str
    end
end

return utils

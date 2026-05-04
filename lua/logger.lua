local config = require("config")

local module_name = require("constants").PluginName

local M = {}

local function current_time()
    return os.date("!%Y-%m-%dT%TZ")
end

local function output(message)
    vim.print(message)
end

M.Debug = function(message)
    if config.Instance.log_severity < 4 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(DEBUG):" .. message
    output(message)
end

M.Info = function(message)
    if config.Instance.log_severity < 3 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(INFO):" .. message
    output(message)
end

M.Warn = function(message)
    if config.Instance.log_severity < 2 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(WARN):" .. message
    output(message)
end

M.Error = function(message)
    if config.Instance.log_severity < 1 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(ERROR):" .. message
    error(message)
end

return M

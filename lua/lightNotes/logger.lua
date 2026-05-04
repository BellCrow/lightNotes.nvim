local config = require("lightNotes.config")
local module_name = require("lightNotes.constants").PluginName

local M = {}

M.Debug = function(message)
    if config.Instance.log_level < 3 then
        return
    end
    assert(type(message) == "string")
    message = module_name .. ": " .. message
    vim.notify(message, vim.log.levels.DEBUG)
end

M.Info = function(message)
    if config.Instance.log_level < 2 then
        return
    end
    assert(type(message) == "string")
    message = module_name .. ": " .. message
    vim.notify(message, vim.log.levels.INFO)
end

M.Warn = function(message)
    if config.Instance.log_level < 1 then
        return
    end
    assert(type(message) == "string")
    message = module_name .. ": " .. message
    vim.notify(message, vim.log.levels.WARN)
end

M.Error = function(message)
    if config.Instance.log_level < 0 then
        return
    end
    assert(type(message) == "string")
    message = module_name .. ": " .. message
    vim.notify(message, vim.log.levels.ERROR)
end

return M

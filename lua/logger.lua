local projectInfo = require("info")
---TODO: make the severity value part of the config
---@type integer Sets the severity of logs, to see. Higher numbers means less severe messages are logged
local loglevel = 4
local module_name = projectInfo.ProjectName
local function current_time()
    return os.date("!%Y-%m-%dT%TZ")
end

local function output(message)
    vim.print(message)
end

function Debug(message)
    if loglevel < 4 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(DEBUG):" .. message
    output(message)
end

function Info(message)
    if loglevel < 3 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(INFO):" .. message
    output(message)
end

function Warn(message)
    if loglevel < 2 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(WARN):" .. message
    output(message)
end

function Error(message)
    if loglevel < 1 then
        return
    end
    assert(type(message) == "string")
    message = current_time() .. " " .. module_name .. "|(ERROR):" .. message
    error(message)
end

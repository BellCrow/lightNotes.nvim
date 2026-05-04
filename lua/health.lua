local config = require("config")
local constants = require("constants")
local H = {}

H.check = function()
    -- TODO: add proper health checks here
    -- * add listing of the used folders and file names
    -- * add info if the plugin can write to the folders
    vim.health.start(constants.PluginName)
    vim.health.info("Config: " .. vim.inspect(config))

    vim.health.ok("All lights are green major tom")
end

return H

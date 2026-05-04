require("lightNotes.util")
local config = require("lightNotes.config")
local constants = require("lightNotes.constants")
local logger = require("lightNotes.logger")
local M = {}

M.check = function()
    logger.Debug("Healthcheck called")
    -- TODO: add proper health checks here
    -- * add listing of the used folders and file names
    -- * add info if the plugin can write to the folders
    vim.health.start(constants.PluginName)
    vim.health.info("Config table: " .. vim.inspect(config.Instance))

    if config.Instance.notes_directory == nil or config.Instance.notes_directory == "" then
        vim.health.error(
            "The notes directory path cannot be nil or empty. Did you specify that in your config in the setup call ?"
        )
    end

    if not Exists(config.Instance.notes_directory) or not Is_Directory(config.Instance.notes_directory) then
        vim.health.error(
            "Did not find notes directory on path '"
                .. config.Instance.notes_directory
                .. "' which should have been created during startup."
        )
    else
        vim.health.ok("Found notes directory on path " .. config.Instance.notes_directory)
    end
    if config.Instance.log_level > 4 then
        vim.health.warn(
            "The log severity should be in the range 0-4 (inclusive). Setting it to something bigger than 4 effectively behavese like level 4"
        )
    end
    if config.Instance.log_level < 0 then
        vim.health.warn(
            "The log severity should be in the range 0-4 (inclusive). Setting it to something smaller than 0 effectively behavese like level 0"
        )
    end
end

return M

local constants = require("lightNotes.constants")
local M = {}
---@class (exact) Config
---@field global_notes_file_name string The name of the file, that contains the global notes
---@field notes_directory string The root path where all notes are stored
---@field log_level integer Severity of logs, to see. Higher numbers means less severe messages are logged. Set to a number from

---@type Config
M.Instance = {
    global_notes_file_name = "global_notes.txt",
    notes_directory = vim.fs.joinpath(vim.fn.stdpath("data"), constants.PluginName),
    log_level = 2,
}

--- Merges a given (user) config into the config singleton
---@param config Config The user supplied config to merge in the default values
M.Merge = function(config)
    M.Instance = vim.tbl_deep_extend("force", M.Instance, config)
    vim.validate("config.global_notes_file_name", M.Instance.global_notes_file_name, "string")
    vim.validate("config.notes_directory", M.Instance.notes_directory, "string")
    vim.validate("config.log_level", M.Instance.log_level, "number")

    -- the paths might be given, as relative paths or have a '~' in them
    -- is there a better way to ensure, that paths are expanded by default ?
    M.Instance.notes_directory = vim.fn.expand(M.Instance.notes_directory)
end
return M

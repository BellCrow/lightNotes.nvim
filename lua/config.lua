local constants = require("constants")
local M = {}
---@class (exact) Config
---@field global_notes_file_name string The name of the file, that contains the global notes
---@field notes_folder string The root path where all notes are stored
---@field log_severity integer Severity of logs, to see. Higher numbers means less severe messages are logged

---@type Config
M.Instance = {
    global_notes_file_name = "global_notes.txt",
    notes_folder = vim.fs.joinpath(vim.fn.stdpath("data"), constants.PluginName),
    log_severity = 4,
}

--- Merges a given (user) config into the config singleton
---@param config Config The user supplied config to merge in the default values
M.Merge = function(config)
    M.Instance = vim.tbl_deep_extend("force", M.Instance, config)

    -- the paths might be given, as relative paths or have a '~' in them
    -- is there a better way to ensure, that paths are expanded by default ?
    M.Instance.notes_folder = vim.fn.expand(M.Instance.notes_folder)
end
return M

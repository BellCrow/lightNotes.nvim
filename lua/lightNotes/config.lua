local constants = require("lightNotes.constants")
local M = {}
---@class (exact) Config
---@field global_notes_file_name string The name of the file, that contains the global notes
---@field notes_directory string The root path where all notes are stored
---@field log_level integer Severity of logs, to see. Higher numbers means less severe messages are logged.
---Set to a number from 1 to 4, where 4 inludes the most logs
---@field file_extension string The default extension for the notes files, saved to disk. (Defaults to '.txt')
---Set this to "md" if you want your notes to be markdown files
---@field restore_cursor boolean If true restore the cursor position from last time a note was open (relies on ShaDa file).

--- Create a new table containing the default configuration
---@return Config
local function GetDefaultConfig()
    ---@type Config

    ---@diagnostic disable-next-line: missing-fields
    local config = {}
    config.notes_directory = vim.fs.joinpath(vim.fn.stdpath("data"), constants.PluginName)
    config.log_level = 2
    config.file_extension = ".txt"
    config.global_notes_file_name = "global_notes" .. config.file_extension
    config.restore_cursor = true
    return config
end

---@type Config
M.Instance = GetDefaultConfig()

--- Merges a given (user) config into the config singleton
---@param config Config The user supplied config to merge in the default values
M.Merge = function(config)
    M.Instance = vim.tbl_deep_extend("force", M.Instance, config)
    vim.validate("config.global_notes_file_name", M.Instance.global_notes_file_name, "string")
    vim.validate("config.notes_directory", M.Instance.notes_directory, "string")
    vim.validate("config.log_level", M.Instance.log_level, "number")
    vim.validate("config.file_extension", M.Instance.file_extension, "string")

    -- if a . is missing before the (user supplied)
    -- file extension, we add it here
    if string.find(M.Instance.file_extension, "%.") == nil then
        M.Instance.file_extension = "." .. M.Instance.file_extension
    end

    vim.validate("config.restore_cursor", M.Instance.restore_cursor, "boolean")

    -- the paths might be given, as relative paths or have a '~' in them
    -- is there a better way to ensure, that paths are expanded by default ?
    M.Instance.notes_directory = vim.fn.expand(M.Instance.notes_directory)
end
return M

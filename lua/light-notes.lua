local config = require("config")
require("util")
local float = require("float")
local logger = require("logger")
require("scopes")
require("note")

local constants = require("constants")

local M = {}

--- Call this once with your settings table, if you need settings, that are not default
---@param user_config Config
M.setup = function(user_config)
    if user_config == nil then
        -- this is a special case im handling, to not annoy the user
        -- so the warning is unfounded in this case
        ---@diagnostic disable-next-line: missing-fields
        user_config = {}
    end

    config.Merge(user_config)
    if not Exists(config.Instance.notes_folder) then
        logger.Info("No existing config directory found. Creating new one on path: " .. config.Instance.notes_folder)
        if vim.fn.mkdir(config.Instance.notes_folder, "p") == 0 then
            logger.Error("Could not create new notes directory. Are write permissions missing ?")
            return
        end
    end

    vim.api.nvim_create_augroup(constants.PluginName, { clear = true })
end

M.toggle_global_note = function()
    local global_note_identifier = Calculate_global_scope_identifier()

    if float.Is_open() then
        local shown_note = float.Get_current_note()
        M.close_note()
        if shown_note.identifier == global_note_identifier then
            -- this happens when the user has a float open with the global note and
            -- they request to show the global note again
            -- I interpret this as the user wanting to close the float
            -- Like a toggle operation
            return
        end
    end

    local global_notes_file_path = vim.fs.joinpath(config.Instance.notes_folder, global_note_identifier)
    if not Exists(global_notes_file_path) then
        logger.Info(
            "Could not find global note on path "
                .. global_notes_file_path
                .. ". Creating a new empty global note file."
        )
    end

    local global_note = Open_note_from_path(global_notes_file_path)
    global_note.identifier = global_note_identifier
    float.Show_note_in_float(global_note, "Global note")
end

M.toogle_branch_scoped_note = function()
    ---@type Note
    local shown_note = nil
    if float.Is_open() then
        shown_note = float.Get_current_note()
        M.close_note()
    end

    local current_file_path = Get_path_to_current_file()
    assert(current_file_path ~= nil)

    local path_scoped_identifier, branch_name = Calculate_branch_scope_identifier(current_file_path)
    if path_scoped_identifier == nil then
        logger.Warn("Cannot create branch scoped note if not in a repository.")
        return
    end

    -- shown note is nil, if there was no float open
    if shown_note ~= nil and path_scoped_identifier == shown_note.identifier then
        -- this happens when the user has a float open and
        -- they request to show the same note as is already shown
        -- I interpret this as the user wanting to close the float
        -- Like a toggle operation
        return
    end

    local note_file_path = vim.fs.joinpath(config.Instance.notes_folder, path_scoped_identifier .. ".txt")
    local note = Open_note_from_path(note_file_path)
    note.identifier = path_scoped_identifier
    float.Show_note_in_float(note, "Branch note: " .. branch_name)
end

M.toogle_repo_scoped_note = function()
    ---@type Note
    local shown_note = nil
    if float.Is_open() then
        shown_note = float.Get_current_note()
        M.close_note()
    end
    local current_file_path = Get_path_to_current_file()
    assert(current_file_path ~= nil)

    local path_scoped_identifier = Calculate_root_scope_identifier(current_file_path, ".git")
    if path_scoped_identifier == nil then
        logger.Warn("Could not determine root of project to create a note. Used '.git' as root marker")
        return
    end

    -- shown note is nil, if there was no float open
    if shown_note ~= nil and path_scoped_identifier == shown_note.identifier then
        -- this happens when the user has a float open and
        -- they request to show the same note as is already shown
        -- I interpret this as the user wanting to close the float
        -- Like a toggle operation
        return
    end

    local scoped_note_path = vim.fs.joinpath(config.Instance.notes_folder, path_scoped_identifier .. ".txt")
    local scoped_note = Open_note_from_path(scoped_note_path)
    scoped_note.identifier = path_scoped_identifier
    float.Show_note_in_float(scoped_note, "Repository note")
end

M.close_note = function()
    if not float.Is_open() then
        return
    end
    local shown_note = float.Get_current_note()
    float.Close()
    Free_note(shown_note)
end

return M

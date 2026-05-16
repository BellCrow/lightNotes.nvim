local config = require("lightNotes.config")
local float = require("lightNotes.float")
local logger = require("lightNotes.logger")
local notes = require("lightNotes.note")
local scopes = require("lightNotes.scopes")
local util = require("lightNotes.util")

local constants = require("lightNotes.constants")

local M = {}

--- Call this once with your settings table, if you need settings, that are not default
---@param user_config Config
M.setup = function(user_config)
    config.Merge(user_config or {})

    if not util.Exists(config.Instance.notes_directory) then
        logger.Warn("No existing config directory found. Creating new one on path: " .. config.Instance.notes_directory)
        if vim.fn.mkdir(config.Instance.notes_directory, "p") == 0 then
            logger.Error("Could not create new notes directory. Are write permissions missing ?")
            return
        end
    end

    vim.api.nvim_create_augroup(constants.PluginName, { clear = true })
end

--- Toogles the global note for on and off. If there is already a floating
--- window, the old note will be closed and a new floting window
--- will be created with the global note.
M.toggle_global_note = function()
    local global_note_identifier = scopes.Calculate_global_scope_identifier()

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

    local global_notes_file_path = vim.fs.joinpath(config.Instance.notes_directory, global_note_identifier)
    if not util.Exists(global_notes_file_path) then
        logger.Warn(
            "Could not find global note on path "
                .. global_notes_file_path
                .. ". Creating a new empty global note file."
        )
    end

    local global_note = notes.Open_note_from_path(global_notes_file_path)
    global_note.identifier = global_note_identifier
    float.Show_note_in_float(global_note, "Global note")
end

--- Toogles a note, that is scoped to the branch of the current repository.
--- This will only work if the path of the file of the currently active
--- buffer, is inside of a git repository. Will fail with
--- a warning if the file is not part of a repository.
M.toogle_branch_scoped_note = function()
    ---@type Note
    local shown_note = nil
    if float.Is_open() then
        shown_note = float.Get_current_note()
        M.close_note()
    end

    local current_file_path = util.Get_path_to_current_file()
    assert(current_file_path ~= nil)

    local path_scoped_identifier, branch_name = scopes.Calculate_branch_scope_identifier(current_file_path)
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

    local note_file_path =
        vim.fs.joinpath(config.Instance.notes_directory, path_scoped_identifier .. config.Instance.file_extension)
    local note = notes.Open_note_from_path(note_file_path)
    note.identifier = path_scoped_identifier
    float.Show_note_in_float(note, "Branch note: " .. branch_name)
end

--- Toogles a note, that is scoped to the repository of the active file.
--- This will only work if the path of the file of the currently active
--- buffer, is inside of a git repository. Will fail with
--- a warning if the file is not part of a repository.
M.toogle_repo_scoped_note = function()
    ---@type Note
    local shown_note = nil
    if float.Is_open() then
        shown_note = float.Get_current_note()
        M.close_note()
    end
    local current_file_path = util.Get_path_to_current_file()
    assert(current_file_path ~= nil)

    local note_identifier = scopes.Calculate_root_scope_identifier(current_file_path, ".git")
    if note_identifier == nil then
        logger.Warn("Could not determine root of project to create a note. Used '.git' as root marker")
        return
    end

    -- shown note is nil, if there was no float open
    if shown_note ~= nil and note_identifier == shown_note.identifier then
        -- this happens when the user has a float open and
        -- they request to show the same note as is already shown
        -- I interpret this as the user wanting to close the float
        -- Like a toggle operation
        return
    end

    local note_path =
        vim.fs.joinpath(config.Instance.notes_directory, note_identifier .. config.Instance.file_extension)
    local note = notes.Open_note_from_path(note_path)
    note.identifier = note_identifier
    float.Show_note_in_float(note, "Repository note")
end

--- Closes an open floating window, that is
--- showing a note if there is any.
--- Nothing happens if no window is open.
M.close_note = function()
    if not float.Is_open() then
        return
    end
    local shown_note = float.Get_current_note()
    float.Close()
    notes.Free_note(shown_note)
end

---@alias scope_func fun(buffer_path:string):string,string
---@param scope_func scope_func This function should take in a path
--- to the file of the current buffer and return an identifier, that
--- can be used as the name of a file. It can optionally also return
--- any name, that will be shown as the title of the floating window
--- used to show the note (Can be nil)
M.toogle_custom_scoped_note = function(scope_func)
    ---@type Note
    local shown_note = nil
    if float.Is_open() then
        shown_note = float.Get_current_note()
        M.close_note()
    end
    local current_file_path = util.Get_path_to_current_file()
    assert(current_file_path ~= nil)

    local note_identifier, float_window_title = scope_func(current_file_path)
    float_window_title = float_window_title or ""

    -- shown note is nil, if there was no float open
    if shown_note ~= nil and note_identifier == shown_note.identifier then
        -- this happens when the user has a float open and
        -- they request to show the same note as is already shown
        -- I interpret this as the user wanting to close the float
        -- Like a toggle operation
        return
    end

    local note_path =
        vim.fs.joinpath(config.Instance.notes_directory, note_identifier .. config.Instance.file_extension)
    local note = notes.Open_note_from_path(note_path)
    note.identifier = note_identifier
    float.Show_note_in_float(note, float_window_title)
end

--- Calculates an identifier from the given string, that only
--- contains characters, that can be used as characters in a directory path.
---@param input string The string to convert to an identifier
---@return string
M.calculate_identifier = function(input)
    require("lightNotes.scopes")
    return util.Calc_identifier(input)
end

return M

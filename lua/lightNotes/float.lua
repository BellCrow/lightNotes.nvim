require("lightNotes.note")
local config = require("lightNotes.config")

local M = {}

---@type integer|nil
M._opened_float_window_id = -1

---@type Note|nil
M._current_shown_note = nil

M.Is_open = function()
    return vim.api.nvim_win_is_valid(M._opened_float_window_id)
end

--- Asserts that the float window is open and returns the currently shown note
---@return Note
M.Get_current_note = function()
    assert(
        M.Is_open() and M._current_shown_note ~= nil,
        "Cannot retrieve note from non open float."
            .. " Check if the float is open with 'Is_float_open' before retrieving the note"
    )
    return M._current_shown_note
end

--- Opens a given note in a floating window.
---@param note Note The note to show in the float window
---@param title string The title of the float window shown in the top center
M.Show_note_in_float = function(note, title)
    assert(not M.Is_open())
    local get_dim = function(max, cfg)
        if cfg > 1 then return math.min(max, cfg) end
        return math.floor(max * cfg)
    end
    -- we have to create a new float window
    local width = get_dim(vim.o.columns, config.Instance.window.width)
    local height = get_dim(vim.o.lines, config.Instance.window.height)
    local x = math.floor((vim.o.columns - width) / 2)
    local y = math.floor((vim.o.lines - height) / 2)
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = x,
        row = y,
        title = title,
        title_pos = config.Instance.window.title_pos,
    }
    M._opened_float_window_id = vim.api.nvim_open_win(note.buffer, true, win_config)
    M._current_shown_note = note
    if config.Instance.restore_cursor then
        local line = vim.fn.line([['"]])
        if 0 < line and line <= vim.fn.line('$') then
            vim.cmd('normal! g`"')
        end
    end
end

--- Closes an existing floating window with notes if there is any
M.Close = function()
    if vim.api.nvim_win_is_valid(M._opened_float_window_id) then
        assert(
            M._current_shown_note ~= nil,
            "No note was present on close of an existing float window."
                .. " This should not happen. Consider raising an issue in the plugins repository with reproduction steps"
        )
        vim.api.nvim_win_close(M._opened_float_window_id, false)
        M._current_shown_note = nil
        M._opened_float_window_id = -1
    end
end

return M

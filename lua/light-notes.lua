require("util")
require("logger")
require("config")
local projectInfo = require("info")

Debug("Loading light notes")

local M = {}

--- Call this once with your settings table, if you need settings, that are not default
---@param config Config
M.setup = function(config)
    if config == nil then
        Error(
            "Please supply a config option in the setup call."
                .. "If you want to use the default settigs."
                .. " You can just call setup like this 'require(\"light-notes\").setup({})'"
        )
        return
    end
    Setup_config_instance(config)
end

local function write_buffer(buf)
    local buf_info = vim.fn.getbufinfo(buf)[1]
    if buf_info.changed == 0 then
        return
    end
    vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent w")
    end)
end

local opened_float = -1
local augroup = vim.api.nvim_create_augroup(projectInfo.ProjectName, {})
local function open_buffer_in_float(buf)
    Debug("Window instance " .. tostring(opened_float))
    if opened_float ~= -1 then
        Debug("Closing floating window")
        vim.api.nvim_win_close(opened_float, false)
        return
    end
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    local x = math.floor((vim.o.columns - width) / 2)
    local y = math.floor((vim.o.lines - height) / 2)
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = x,
        row = y,
        title = "Global Notes",
        title_pos = "center",
    }

    opened_float = vim.api.nvim_open_win(buf, true, win_config)
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(opened_float),
        once = true,
        callback = function()
            opened_float = -1
        end,
        group = augroup,
    })
    -- TODO: these autocommands are not properly cleaned up
    -- i found multiple of them with fzf even though there
    -- should only ever be one at a time.
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = buf,
        callback = function()
            Debug("Auto command for buffer saving called")
            write_buffer(buf)
        end,
        group = augroup,
    })
end

---@type integer
local global_notes_buffer = -1

M.open_global_notes = function()
    local global_notes_file_path = vim.fs.joinpath(ConfigInstance.notes_folder, ConfigInstance.global_notes_file_name)

    Debug("Opening global note in path " .. global_notes_file_path)
    if global_notes_buffer == -1 then
        global_notes_buffer = Open_file_into_buffer(global_notes_file_path)
        Debug("Opening global notes from path " .. global_notes_file_path)
    else
        Debug("Reusing already existing global notes buffer with id " .. global_notes_buffer)
    end
    open_buffer_in_float(global_notes_buffer)
end

M.open_scoped_notes = function() end

return M

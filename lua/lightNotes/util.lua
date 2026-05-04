--- Check if the given path points to a valid entry
--- in the file system. Can be a file or a directory.
---@param path string
---@return boolean
function Exists(path)
    path = vim.fn.expand(path)
    assert(path ~= nil, "Path cannot be nil")
    return vim.uv.fs_stat(path) ~= nil
end

function Is_File(path)
    assert(path ~= nil, "Path cannot be nil")
    path = vim.fn.expand(path)
    assert(path ~= nil, "Path cannot be nil")
    return vim.uv.fs_stat(path).type == "file"
end

function Is_Directory(path)
    path = vim.fn.expand(path)
    assert(path ~= nil, "Path cannot be nil")
    return vim.uv.fs_stat(path).type == "directory"
end

function Create_new_file(path)
    path = vim.fn.expand(path)
    local file, error_message = io.open(path, "w")
    if file == nil then
        error("Could not create new file in path " .. path .. ".Error was: " .. error_message)
        return
    end
    file:close()
end

function Get_path_to_current_file()
    -- getting the current active file
    -- is a bit more involved then obvious.
    -- for instance being in a float/scratch
    -- terminal makes it more difficult,
    -- as the buffers contained in them might
    -- not have a file path attached
    if vim.bo.filetype == "oil" then
        -- this is an example for oil integration
        local oil = require("oil")
        assert(oil ~= nil, "Command was called from a buffer marked as 'oil', but require(\"oil\") returned nil")

        local ret = oil.get_current_dir()

        local selected_oil_file = oil.get_cursor_entry()
        if selected_oil_file ~= nil then
            ret = vim.fs.joinpath(ret, selected_oil_file.name)
        end

        return ret
    end

    -- no special case was applicable, so we just return
    -- the regular 'current file' path
    return vim.fn.expand("%:p")
end

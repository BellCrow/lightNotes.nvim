require("util")
require("logger")

local config = require("config")
local sha2 = require("sha2")

function Calc_hash(input)
    local ret = sha2.sha256(input)
    assert(
        type(ret) == "string",
        "The hashing function has not returned a string, but a "
            .. type(ret)
            .. "This happens if you calculate a hash with too much data."
            .. "Consider opening an issue on the plugins repository page,"
            .. "as I did not expect that to ever be an issue"
    )
    return ret
end

---@param file_path string
---@param root_marker string
---@return string|nil
function Calculate_root_scope_identifier(file_path, root_marker)
    local found_root = vim.fs.root(file_path, root_marker)
    if found_root == nil then
        return nil
    end
    return Calc_hash(found_root)
end

--- Taken from: https://www.reddit.com/r/neovim/comments/uz3ofs/heres_a_function_to_grab_the_name_of_the_current/
---@param path string Path to the file from which the note request was started
---@return string string Name of the git branch, the git repository is on that the path is part of.
---Emty string if the given path is not part of a git repository
local function get_branch_name(path)
    if Is_File(path) then
        -- the "git branch" command only works
        -- if the -C parameter specifies a directory
        path = vim.fs.dirname(path)
    end
    return vim.fn.system("git -C " .. path .. " branch --show-current 2> /dev/null | tr -d '\n'")
end

function Calculate_branch_scope_identifier(path)
    assert(path ~= nil, "Path cannot be nil")

    local branch = get_branch_name(path)
    if branch == "" then
        return nil
    end

    local git_root = vim.fs.root(path, ".git")
    if git_root == nil then
        return nil
    end

    local hash = Calc_hash(Calc_hash(branch) .. Calc_hash(git_root))
    return hash, branch
end

function Calculate_global_scope_identifier()
    return config.Instance.global_notes_file_name
end

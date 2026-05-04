local constants = require("constants")
local logger = require("logger")

---@class (exact) Note Encapsulates a single note, with its contained buffer
---@field buffer integer The buffer id that is backing this note
---@field identifier string Unique identifier for this note. I.e. is the string "global" for the global note

--- Writes a given note back to its backing file
---@param note_buffer integer
local function write_buf(note_buffer)
    local buf_info = vim.fn.getbufinfo(note_buffer)[1]
    if buf_info.changed == 0 then
        return
    end
    vim.api.nvim_buf_call(note_buffer, function()
        vim.cmd("silent w")
    end)
end

--- Opens a given note and returs it as a note object.
--- Also creates auto commands, to ensure the note
--- content is automatically written back to the file
---@param path string
---@return Note
function Open_note_from_path(path)
    assert(path ~= nil and path ~= "")
    path = vim.fn.expand(path)

    if not Exists(path) then
        Create_new_file(path)
        logger.Debug("Create new file in path: " .. path)
    end

    local file_buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_call(file_buf, function()
        vim.cmd.edit(path)
    end)

    -- this autocommand is supposed to make sure, the
    -- notes content is always written back to the backing file
    vim.api.nvim_create_autocmd({ "BufLeave", "BufDelete", "BufUnload" }, {
        buffer = file_buf,
        callback = function(args)
            write_buf(args.buf)
            if args.event == "BufDelete" or args.event == "BufUnload" then
                -- we can delete the autocommand, if the buffer
                -- is getting deleted. No need to pollute the users
                -- autocommands
                return true
            end
        end,
        group = constants.PluginName,
    })
    --- @type Note
    local note = { buffer = file_buf, identifier = "" }
    return note
end

--- Frees a note and deletes the buffer
--- Doing so should also call the operations
--- That ensure, the note content is saved back
--- to the file
---@param note Note
function Free_note(note)
    assert(vim.api.nvim_buf_is_valid(note.buffer))
    vim.api.nvim_buf_delete(note.buffer, { force = false, unload = false })
    note.buffer = -1
end

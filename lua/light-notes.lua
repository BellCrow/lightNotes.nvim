vim.print("Loading light notes")
local M = {}

M.setup = function()
  vim.print("Setup called")
end

M.open_global_note = function()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local x = math.floor((vim.o.columns - width) / 2)
  local y = math.floor((vim.o.lines - height) / 2)

  local backing_buffer = vim.api.nvim_create_buf(false, true)

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = x,
    row = y,
    title = "Global Note",
    title_pos = "center",
  }
  _ = vim.api.nvim_open_win(backing_buffer, true, win_config)
end

return M

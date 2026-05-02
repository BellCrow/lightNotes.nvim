function File_exists(path)
  assert(path ~= nil, "Path cannot be nil")
  return vim.uv.fs_stat(path) ~= nil
end

--- Opens a given file in a new buffer
---@param file_path string
---@return integer
function Open_file_into_buffer(file_path)
  file_path = vim.fn.expand(file_path)
  assert(File_exists(file_path))
  local file_buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_call(file_buf, function()
    vim.cmd.edit(file_path)
  end)
  return file_buf
end

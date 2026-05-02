---@alias Config {global_notes_file_name:string, notes_folder:string}

---@type Config
ConfigInstance = {}
--- Creates a new config with default values
---@param user_supplied_config Config
---@return Config
function Setup_config_instance(user_supplied_config)
  ---@type Config
  local config = {
    global_notes_file_name = "global_notes.txt",
    notes_folder = vim.fs.joinpath(vim.fn.stdpath("data"), "lightNotes"),
  }
  ConfigInstance = vim.tbl_deep_extend("force", config, user_supplied_config)
  return ConfigInstance
end

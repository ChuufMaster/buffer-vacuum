local M = {}

---@class Config
local defaults = {
  max_buffers = 6,
  count_pinned_buffers = false,
}

---@type Config
M.options = {}

---@param options Config|nil
function M.setup(options)
  M.options = vim.tbl_deep_extend('force', {}, defaults, options or {})
end

---@param options Config|nil
function M.extend(options)
  M.options =
    vim.tbl_deep_extend('force', {}, M.options or defaults, options or {})
end

M.setup()

return M

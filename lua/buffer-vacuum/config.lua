---@class Config
local M = {}

---@class options
---@field enable_messages boolean Enable debugging messages
---@field count_pinned_buffers boolean Toggle including pinned buffers in count
---@field max_buffers number Set the maximum number of bufferes to include
M.options = {}

---@type options
local defaults = {
    -- the number of buffers to keep open including the current buffer
    max_buffers = 6,

    -- Set to true to include pinned buffers in the buffer count
    count_pinned_buffers = false,

    -- Enable printing out the number of buffers open when entering a buffer
    -- and printing out which buffer is being deleted when deleting buffers
    enable_messages = false,
}

---@param options options|nil
function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

---@param options options|nil
function M.extend(options)
    M.options =
        vim.tbl_deep_extend("force", {}, M.options or defaults, options or {})
end

return M

local config = require("buffer-vacuum.config")
---@class Util
local M = {}

---Toggle buffer-vacuum
function M.toggle_Buffer_Vacuum()
    vim.g.Buffer_Vacuum_Enabled = not vim.g.Buffer_Vacuum_Enabled
end

---Disable buff-vacuum
function M.disable_Buffer_Vacuum()
    vim.g.Buffer_Vacuum_Enabled = false
end

---Enable buff-vacuum
function M.enable_Buffer_Vacuum()
    vim.g.Buffer_Vacuum_Enabled = true
end

---Add a buffer to the pinned_buffers
---@param bufnr number The buffer number of the buffer to pin
function M.pin_buffer(bufnr)
    local buffer = vim.b[bufnr]
    if buffer.pinned == nil then
        buffer.pinned = 0
    end

    buffer.pinned = 1 - buffer.pinned

    if config.options.enable_messages then
        if buffer.pinned == 1 then
            print("pinned buffer " .. bufnr)
        else
            print("unpinned buffer " .. bufnr)
        end
    end
end

---Check if a buffer is pinned
---@param buffer vim.fn.getbufinfo.ret.item The buffer to check
local function is_pinned(buffer)
    if config.options.count_pinned_buffers then
        return 0
    end
    if buffer.variables.pinned ~= nil then
        return buffer.variables.pinned
    else
        return 0
    end
end

---deletes the oldest buffer by getting the all the listed buffers and excluding
---any that are pinned or unsaved to calculate if a buffer should be deleted
function M.delete_oldest_buffer()
    if vim.g.Buffer_Vacuum_Enabled == false then
        return
    end

    local current_buffer = vim.api.nvim_get_current_buf()

    local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })
    local file_buffers = {}

    local considered_buffers = 0

    for _, buff in ipairs(listed_buffers) do
        -- Check if the buffer is associated with a file and does not have unsaved changes
        if
            buff.changed == 0
            and buff.listed == 1
            and buff.bufnr ~= current_buffer
            and is_pinned(buff) == 0
            and buff.name ~= ""
        then
            table.insert(file_buffers, buff)
        end
    end
    table.sort(file_buffers, function(a, b)
        return a.lastused > b.lastused
    end)
    -- Sort files by last access time when they haven't been loaded yet

    considered_buffers = considered_buffers + #file_buffers

    if config.options.enable_messages then
        vim.print("Buffer Vacuum: " .. considered_buffers .. " counted buffers")
    end

    if considered_buffers >= config.options.max_buffers then
        local oldest_bufnr = file_buffers[#file_buffers]
        if config.options.enable_messages then
            print(
                "Deleting the oldest buffer:",
                vim.api.nvim_buf_get_name(oldest_bufnr.bufnr)
            )
        end
        vim.api.nvim_buf_delete(oldest_bufnr.bufnr, {})
    end

    if considered_buffers >= config.options.max_buffers then
        M.delete_oldest_buffer()
    end
end

local function pinned_buffers()
    local pinned = {}
    local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })
    for _, buf in ipairs(listed_buffers) do
        if is_pinned(buf) == 1 then
            table.insert(pinned, buf.bufnr)
        end
    end
    return pinned
end

local function get_pinned_buffer_idx(buffer_list)
    if #buffer_list == 0 then
        print("No pinned buffers found")
        return nil
    end

    local current = vim.api.nvim_get_current_buf()
    local idx
    for i, b in ipairs(buffer_list) do
        if b == current then
            idx = i
            break
        end
    end

    return idx or 1
end

M.go_next_pinned_buffer = function()
    local pinned = pinned_buffers()
    local idx = get_pinned_buffer_idx(pinned)
    if idx then
        local new_idx = (idx % #pinned) + 1
        vim.api.nvim_set_current_buf(pinned[new_idx])
    end
end

M.go_prev_pinned_buffer = function()
    local pinned = pinned_buffers()
    local idx = get_pinned_buffer_idx(pinned)
    if idx then
        local new_idx = ((idx - 2) % #pinned) + 1
        vim.api.nvim_set_current_buf(pinned[new_idx])
    end
end

return M

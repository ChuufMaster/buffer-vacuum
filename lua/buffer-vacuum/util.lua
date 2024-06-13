---@class Util

local config = require('buffer-vacuum.config')

local M = {}

function M.toggle_Buffer_Vacuum()
  vim.g.Buffer_Vacuum_Enabled = not vim.g.Buffer_Vacuum_Enabled
end

function M.disable_Buffer_Vacuum()
  vim.g.Buffer_Vacuum_Enabled = false
end

function M.enable_Buffer_Vacuum()
  vim.g.Buffer_Vacuum_Enabled = true
end

-- Add a buffer to the pinned_buffers
function M.pin_buffer(bufnr)
  local buffer = vim.b[bufnr]
  if buffer.pinned == nil then
    buffer.pinned = 0
  end

  buffer.pinned = 1 - buffer.pinned

  if config.options.enable_messages then
    if buffer.pinned == 1 then
      print('pinned buffer ' .. bufnr)
    else
      print('unpinned buffer ' .. bufnr)
    end
  end
end

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

-- deletes the oldest buffer
function M.delete_oldest_buffer()
  if vim.g.Buffer_Vacuum_Enabled == false then
    return
  end

  local current_buffer = vim.api.nvim_get_current_buf()

  -- Get all buffers
  local listed_buffers = vim.fn.getbufinfo({ bufloaded = 1 })
  -- Initialize an empty table to store buffers associated with files
  local file_buffers = {}
  -- Iterate through each buffer

  local considered_buffers = 0

  for _, buff in ipairs(listed_buffers) do
    -- Check if the buffer is associated with a file and does not have unsaved changes

    if buff.bufnr == current_buffer then
      if buff.changed == 1 or is_pinned(buff) == 1 then
        considered_buffers = -1
      end
    end
    if
      buff.changed == 0
      and buff.listed == 1
      and buff.bufnr ~= current_buffer
      and is_pinned(buff) == 0
    then
      table.insert(file_buffers, buff)
    end
  end
  -- Sort file buffers by last accessed time
  table.sort(file_buffers, function(a, b)
    return a.lastused > b.lastused
  end)
  -- Delete the oldest buffer

  considered_buffers = considered_buffers + #file_buffers

  if considered_buffers >= config.options.max_buffers then
    local oldest_bufnr = file_buffers[#file_buffers]
    if config.options.enable_messages then
      print(
        'Deleting the oldest buffer:',
        vim.api.nvim_buf_get_name(oldest_bufnr.bufnr)
      )
    end
    vim.api.nvim_buf_delete(oldest_bufnr.bufnr, {})
  end

  if considered_buffers >= config.options.max_buffers then
    M.delete_oldest_buffer()
  end
end

return M

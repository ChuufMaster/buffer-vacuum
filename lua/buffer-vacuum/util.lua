---@class Util

local config = require('buffer-vacuum.config')

local M = {}

M.pinned_buffers = {}

-- Add a buffer to the pinned_buffers
function M.pin_buffer(bufnr)
  local buffer = vim.b[bufnr]
  if buffer.pinned == nil then
    buffer.pinned = false
  end

  buffer.pinned = not buffer.pinned

  print('pinned buffer ' .. bufnr .. ' toggled to')
end

local function is_pinned(buffer)
  if buffer.variables.pinned ~= nil then
    return buffer.variables.pinned
  end
  return false
end

-- deletes the oldest buffer
function M.delete_oldest_buffer()
  -- Get all buffers
  local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })
  -- Initialize an empty table to store buffers associated with files
  local file_buffers = {}
  -- Iterate through each buffer
  for _, buff in ipairs(listed_buffers) do
    -- Check if the buffer is associated with a file and does not have unsaved changes
    if
      not is_pinned(buff) and buff.changed == 0
      -- and not buff.bufnr == vim.fn.bufnr(0)
    then
      table.insert(file_buffers, buff)
    end
  end
  -- Sort file buffers by last accessed time
  table.sort(file_buffers, function(a, b)
    print(a.name .. ' and ' .. a.lastused)
    return a.lastused > b.lastused
  end)
  -- Delete the oldest buffer

  if #file_buffers > config.options.max_buffers then
    local oldest_bufnr = file_buffers[#file_buffers]
    vim.print(oldest_bufnr.bufnr)
    print(
      'Deleting the oldest buffer:',
      vim.api.nvim_buf_get_name(oldest_bufnr.bufnr)
    )
    vim.cmd('bd ' .. oldest_bufnr)
  else
    -- print('No file buffers to delete.')
  end
end

return M

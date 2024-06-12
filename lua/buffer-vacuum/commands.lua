---@class Commands

local util = require('buffer-vacuum.util')

local M = {}
function M.load()
  print('commands')
  vim.api.nvim_create_augroup('BufferVacuum', { clear = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    group = 'BufferVacuum',
    callback = function()
      if
        vim.bo.filetype ~= ''
        and vim.bo.buftype == ''
        and not vim.bo.readonly
      then
        util.delete_oldest_buffer()
      end
    end,
  })

  vim.api.nvim_create_user_command('PinBuffer', function()
    local bufnr = vim.fn.bufnr()
    util.pin_buffer(bufnr)
  end, {})
end

return M

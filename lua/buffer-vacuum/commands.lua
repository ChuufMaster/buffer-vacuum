local util = require("buffer-vacuum.util")

---Creates the auto commands and user commands for buffer-vacuum
---@class Commands
local M = {}

---Load all of the auto and user commands
function M.load()
    vim.g.Buffer_Vacuum_Enabled = true
    vim.api.nvim_create_augroup("BufferVacuum", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = "*.*",
        group = "BufferVacuum",
        callback = function()
            if
                vim.bo.filetype ~= ""
                and vim.bo.buftype == ""
                and not vim.bo.readonly
            then
                util.delete_oldest_buffer()
            end
        end,
    })

    vim.api.nvim_create_user_command("BufferVacuumPinBuffer", function()
        local bufnr = vim.fn.bufnr()
        util.pin_buffer(bufnr)
    end, {})

    vim.api.nvim_create_user_command("BufferVacuumToggle", function()
        util.toggle_Buffer_Vacuum()
    end, {})

    vim.api.nvim_create_user_command("BufferVacuumEnable", function()
        util.enable_Buffer_Vacuum()
    end, {})

    vim.api.nvim_create_user_command("BufferVacuumDisable", function()
        util.disable_Buffer_Vacuum()
    end, {})

    vim.api.nvim_create_user_command("BufferVacuumNext", function()
        util.go_next_pinned_buffer()
    end, {})

    vim.api.nvim_create_user_command("BufferVacuumPrev", function()
        util.go_prev_pinned_buffer()
    end, {})
end

return M

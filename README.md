# 🧹 buffer-vacuum

A Neovim plugin to vacuum up unused file buffers

## ✨ Features

- Delete your oldest unsaved/unpinned buffer
- Pin buffers to ignore them from the buffer count
- Cross session vacuuming

## ⚡️ Requirements

- Neovim >=0.10

## TOC

- [🧹 buffer-vacuum](<#-buffer-vacuum>)
  - [✨ Features](<#-features>)
  - [⚡️ Requirements](<#%EF%B8%8F-requirements>)
  - [TOC](<#toc>)
  - [📦 Installation](<#-installation>)
  - [⚙️ Configuration](<#%EF%B8%8F-configuration>)
  - [🚀 Usage](<#-usage>)
  - [Session Persistence](<#session-persistence>)
  - [Plugins that work well with Buffer Vacuum](<#plugins-that-work-well-with-buffer-vacuum>)

## 📦 Installation

Install the plugin with your preferred package manager:

### 💤 [Lazy.nvim](https://github/folke/lazy.nvim)

```lua
return {
  {
    'ChuufMaster/buffer-vacuum',
    opts = {}
  },
}
```

## ⚙️ Configuration

Buffer-Vacuum comes with the following defaults:

```lua
{
    -- The maximum number of buffers to keep (excluding modified buffer)
    max_buffers = 6,

    -- Change to True if you want pinned buffers to count to the
    -- maximum number buffers
    count_pinned_buffers = false,

    -- Enable notifications every time a buffer is pinned or deleted
    -- Default FALSE
    enable_messages = false,
}
```

## 🚀 Usage

**BufferVacuum** exposes 4 commands to the user:

- **BufferVacuumPinBuffer**: pin the current buffer so that it doesn't get
  deleted
- **BufferVacuumToggle**: Toggle buffer-vacuum
- **BufferVacuumEnable**: Enable buffer-vacuum
- **BufferVacuumDisable**: Disable buffer-vacuum
- **BufferVacuumNext**: Go to next pinned buffer
- **BufferVacuumPrev**: Go to previous pinned buffer

## Session Persistence

### Auto-session Integration

If you're using [auto-session](https://github.com/rmagatti/auto-session) and want pinned buffers to persist across sessions, you need to add the following configuration to your auto-session setup:

```lua
require('auto-session').setup({
    save_extra_cmds = {
        function()
            local commands = {}
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.b[bufnr].pinned == 1 then
                    local filename = vim.api.nvim_buf_get_name(bufnr)
                    if filename ~= "" then
                        -- Generate command to set buffer variable directly
                        local escaped_filename = vim.fn.escape(filename, "'\\")
                        table.insert(commands, "call setbufvar(bufnr('" .. escaped_filename .. "'), 'pinned', 1)")
                    end
                end
            end
            if vim.tbl_isempty(commands) then
                return nil
            end
            return commands
        end
    }
    -- your other auto-session options...
})
```

Without this configuration, pinned buffers will not be remembered when you restore a session.

## Plugins that work well with Buffer Vacuum

- [Bufferline](https://github.com/akinsho/bufferline.nvim)
- [Auto-session](https://github.com/rmagatti/auto-session?tab=readme-ov-file)

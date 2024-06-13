# 🧹 buffer-vacuum.nvim

A neovim plugin to vacuum up unused file buffers

## ✨ Features

- Delete your oldest unsaved/unpinned buffer
- pin buffers to ignore them from the buffer cound

## ⚡️ Requirements

- Neovim >=0.10

## 📦 Installation

Install the plugin with your preferred package manager:

### 💤 [Lazy.nvim](https://github/folke/lazy.nvim)

```lua
return {
  {
    'ChuufMaster/buffer-vacuum.nvim'
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

## Plugins that work well with Buffer Vacuum

- [Bufferline](https://github.com/akinsho/bufferline.nvim)

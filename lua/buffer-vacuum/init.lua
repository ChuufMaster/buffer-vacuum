local config = require('buffer-vacuum.config')
local commands = require('buffer-vacuum.commands')

local M = {}

-- Define the autocommand
M.setup = config.setup

M.load = commands.load

M.setup()
M.load()

return M

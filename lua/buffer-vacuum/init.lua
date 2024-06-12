local config = require('buffer-vacuum.config')
local commands = require('buffer-vacuum.commands')

local M = {}

print('vacuum')
-- Define the autocommand
M.setup = config.setup

M.load = commands.load

return M

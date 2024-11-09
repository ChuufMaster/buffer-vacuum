local config = require("buffer-vacuum.config")
local commands = require("buffer-vacuum.commands")
local util = require("buffer-vacuum.util")

---@class buffer-vacuum
local M = {}

M.config = config
M.commands = commands
M.util = util

---Define the autocommand
M.setup = M.config.setup

---Same as buffer-vacuum.commands.load
M.load = M.commands.load

M.setup()
M.load()

return M

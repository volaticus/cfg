-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options hereby
local rootUtil = require("lazyvim.util.root")

vim.g.root_spec = {
  "lsp",
  function(buf)
    local path = rootUtil.bufpath(buf) or vim.loop.cwd()
    local pattern = vim.fs.find(function(name)
      return name:match(".*%.sln$")
    end, { path = path, upward = true })[1]
    return pattern and { vim.fs.dirname(pattern) } or {}
  end,
  { ".git", "lua" },
  "cwd",
}

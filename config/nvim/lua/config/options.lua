-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- Enable mouse support
vim.opt.mouse = "a"
vim.opt.splitbelow = false

-- Enable local config files
vim.opt.exrc = true
vim.opt.secure = true -- This is important for security

-- Interface
vim.opt.relativenumber = false

-- Do not use lsp for root directory detection. Opens the Explorer in wrong root when there is clangd running and a Makefile in a subdir
vim.g.root_spec = { { ".git", "lua" }, "cwd" }

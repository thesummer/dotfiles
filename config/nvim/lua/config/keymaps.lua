-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Git related keymaps
-- vim.keymap.set("n", "<leader>gs", ":Git<cr>", { silent = true, desc = "Fugitive git status" })
-- vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<cr>", { noremap = false, silent = true, desc = "Fugitive git status" })
-- vim.keymap.set("n", "<leader>gs", ":Git<cr>", { silent = true, desc = "Fugitive git status" })
vim.keymap.set("n", "<leader>gs", ":Neogit<cr>", { silent = true, desc = "Neogit git status" })
vim.keymap.set("n", "<leader>gb", "<leader>ghb<cr>", { silent = true, desc = "Git blame current file" })
vim.keymap.set("n", "<leader>fd", "<leader>/<C-r><C-w><cr>", { silent = true, desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>gb", function()
  require("gitsigns").blame()
end, { silent = true, desc = "Git blame current file" })
vim.keymap.set("n", "<leader>fd", function()
  Snacks.picker.grep_word()
end, { silent = true, desc = "Search for word under cursor in project" })
-- vim.keymap.set("n", "<leader>gb", ":Git blame<cr>", { silent = true, desc = "Git blame current file" })
vim.keymap.set("n", "<leader>gp", ":Neogit pull<cr>", { silent = true, desc = "Git pull" })
vim.keymap.set("n", "<leader>gP", ":Neogit push<cr>", { silent = true, desc = "Git push" })
-- Delete keymaps which open terminals in vim
-- NOTE: Some terminals interpret C-/ as C--, so cover both cases
vim.keymap.del("n", "<C-/>")
vim.keymap.del("n", "<C-_>")
vim.keymap.del("t", "<C-/>")
vim.keymap.del("t", "<C-_>")
-- Set up more convenient splits
-- NOTE: Some terminals interpret C-/ as C--, so cover both cases
vim.keymap.set("n", "<C-/>", ":vsplit<cr>", { silent = true, desc = "Spit window right" })
vim.keymap.set("n", "<C-_>", ":vsplit<cr>", { silent = true, desc = "Spit window right" })

vim.keymap.set("n", "<leader>r", function()
  local root = LazyVim.root()
  print("LazyVim.root() found: " .. root)
  print("Git root: " .. vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", ""))
  print("Current file dir: " .. vim.fn.expand("%:p:h"))
  print("Vim cwd: " .. vim.fn.getcwd())
end)

vim.keymap.set("n", "<leader>d", function()
  local root = LazyVim.root()
  print("About to call Snacks.explorer with cwd: " .. root)
  Snacks.explorer({ cwd = root })
end, { desc = "Debug explorer" })

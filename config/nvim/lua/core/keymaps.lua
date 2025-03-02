-- lua/core/keymaps.lua
-- Contains all core keymaps not specific to plugins

-- [[ Mode Exiting ]]
-- Keymaps for exiting different Neovim modes

-- Clear highlight search on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode with <Esc><Esc> 
-- Note: This won't work in all terminal emulators/tmux
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Alternative ways to exit insert and visual modes
vim.keymap.set({ "i", "v" }, "jk", "<Esc>", { desc = "Exit mode more conveniently" })
vim.keymap.set({ "i", "v" }, "kj", "<Esc>", { desc = "Exit mode more conveniently" })

-- [[ Search Improvements ]]
-- Keymaps for better search experience

-- Don't jump when searching with *
vim.keymap.set("n", "*", "*N", { desc = "Do not jump when searching with *" })

-- [[ UI Toggles ]]
-- Keymaps for toggling UI features

-- Toggle showing invisible characters
vim.keymap.set("n", "<leader>l", ":set list!<cr>", { desc = "Toggle display special characters" })
-- Toggle cursorline highlighting
vim.keymap.set("n", "<leader>i", ":set cursorline!<cr>", { desc = "Toggle cursorline" })

-- [[ Editing Improvements ]]
-- Keymaps for better editing experience

-- Keep visual selection when indenting/outdenting
vim.keymap.set("v", "<", "<gv", { desc = "Keep visual selection when indenting/outdenting" })
vim.keymap.set("v", ">", ">gv", { desc = "Keep visual selection when indenting/outdenting" })
-- Enable . command in visual mode
vim.keymap.set("v", ".", ":normal .<cr>", { desc = "Enable . command in visual mode" })

-- [[ Navigation Improvements ]]
-- Keymaps for better navigation within files and buffers

-- Better wrapped line navigation
vim.keymap.set("n", "j", "gj", { desc = "Move down by visual line" })
vim.keymap.set("n", "k", "gk", { desc = "Move up by visual line" })
vim.keymap.set("n", "^", "g^", { desc = "Go to first non-blank character of visual line" })
vim.keymap.set("n", "$", "g$", { desc = "Go to end of visual line" })

-- Faster scrolling
vim.keymap.set("n", "<C-e>", "3<C-e>", { desc = "Scroll viewport faster downward" })
vim.keymap.set("n", "<C-y>", "3<C-y>", { desc = "Scroll viewport faster upward" })

-- Buffer switching
vim.keymap.set("n", "<leader>k", "<C-^>", { desc = "Switch between current and last buffer" })

-- [[ Window Management ]]
-- Keymaps for managing windows and splits

-- Navigate between windows using CTRL+hjkl
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Create new splits
vim.keymap.set("n", "<C-Bslash>", "<C-w>s", { desc = "Split windows horizontally" })
vim.keymap.set("n", "<C-_>", "<C-w>v", { desc = "Split windows vertically" })

-- [[ Diagnostic Navigation ]]
-- Keymaps for navigating diagnostics

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>ee", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- lua/plugins/init.lua
-- Plugin manager and plugin loader configuration

-- [[ Plugin Manager Setup ]]
-- This file configures lazy.nvim and loads all plugin specifications

return require("lazy").setup({
  -- Import plugin specifications from separate files
  -- Each module should return a table of plugin specifications
  { import = "plugins.ui" },          -- UI-related plugins (colorscheme, statusline)
  { import = "plugins.editor" },      -- Editor enhancement plugins (surround, comments)
  { import = "plugins.treesitter" },  -- Treesitter configuration
  { import = "plugins.telescope" },   -- Telescope configuration
  { import = "plugins.git" },         -- Git-related plugins (fugitive, gitsigns)
  { import = "plugins.completion" },  -- Completion plugins (nvim-cmp, luasnip)
  { import = "plugins.formatting" },  -- Code formatting (conform.nvim)
  { import = "plugins.filetree" },    -- Neo-tree configuration
  { import = "plugins.which-key" },   -- Which-key configuration
  { import = "plugins.lsp" },         -- LSP configuration
  { import = "plugins.startscreen" }, -- Start screen configuration (startify)
  { import = "plugins.rust" },        -- Rust-specific configuration
  { import = "plugins.debugger" },    -- Debugger configuration
  
  -- You can also define plugins directly here instead of in separate files
  -- For example:
  -- {
  --   "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  -- },
})

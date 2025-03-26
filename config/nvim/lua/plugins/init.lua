-- lua/plugins/init.lua
-- Plugin manager and plugin loader configuration with direct LSP configuration

-- [[ Plugin Manager Setup ]]
-- This file configures lazy.nvim and loads all plugin specifications

return require("lazy").setup({
  -- Import plugin specifications from separate files
  { import = "plugins.ui" },          -- UI-related plugins (colorscheme, statusline)
  { import = "plugins.editor" },      -- Editor enhancement plugins (surround, comments)
  { import = "plugins.treesitter" },  -- Treesitter configuration
  { import = "plugins.telescope" },   -- Telescope configuration
  { import = "plugins.git" },         -- Git-related plugins (fugitive, gitsigns)
  { import = "plugins.completion" },  -- Completion plugins (nvim-cmp, luasnip)
  { import = "plugins.formatting" },  -- Code formatting (conform.nvim)
  { import = "plugins.filetree" },    -- Neo-tree configuration
  { import = "plugins.which-key" },   -- Which-key configuration
  -- { import = "plugins.lsp" },      -- LSP configuration - Commented out in favor of direct config
  { import = "plugins.startscreen" }, -- Start screen configuration (startify)
  { import = "plugins.rust" },        -- Rust-specific configuration
  { import = "plugins.debugger" },    -- Debugger configuration
  
  -- Direct LSP configuration - this replaces the import = "plugins.lsp" line
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- Set up LSP event handlers (must happen before servers are configured)
      require("lsp.handlers").setup()
      
      -- LSP servers and clients are able to communicate to each other what features they support.
      -- By default, Neovim doesn't support everything that is in the LSP Specification.
      -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      
      -- Initialize mason first (must come before other LSP setup)
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
      
      -- Get the server configurations
      local servers = require("lsp.servers")
      
      -- Configure Mason for automatic tool installation
      require("lsp.mason").setup(servers, capabilities)
      
      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end,
  },
}, {
  -- Lazy.nvim configuration options
  ui = {
    -- Use Nerd Font icons if available, otherwise use Unicode symbols
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

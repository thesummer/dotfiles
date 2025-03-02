-- File: lua/lsp/init.lua
-- Main LSP (Language Server Protocol) configuration module
-- This file sets up the core LSP functionality and loads other LSP-related modules
--
-- This file serves as the entry point for all LSP-related configuration.
-- It loads Mason first, which is required before other LSP configurations,
-- then loads the specialized modules for handlers, servers, keymaps, and autocmds.
-- 
-- If you want to add a new language server, you should:
-- 1. Add it to the servers table in lua/lsp/servers.lua
-- 2. Create a language-specific configuration file if needed (see lua/lsp/lua_ls.lua as an example)

-- Return the plugin spec for lazy.nvim
return {
    -- Core LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        
        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
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
}

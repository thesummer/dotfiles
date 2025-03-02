-- File: lua/lsp/mason.lua
-- Mason configuration module
-- Responsible for installing and setting up LSP servers and tools

local M = {}

-- Setup function for configuring Mason, Mason-lspconfig, and Mason-tool-installer
-- @param servers (table) - Table of LSP server configurations
-- @param capabilities (table) - Enhanced capabilities for LSP servers
function M.setup(servers, capabilities)
    -- Ensure we have the tables we need
    servers = servers or {}
    capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()

    -- Basic Mason setup
    -- Mason must be set up before mason-lspconfig and mason-tool-installer
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

    -- Extract server names from the servers table for automatic installation
    local ensure_installed = vim.tbl_keys(servers)
    
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    vim.list_extend(ensure_installed, {
        "stylua", -- Used to format lua code
        "bacon",  -- Analyzer for Rust
        "rust-analyzer",
    })
    
    -- Configure Mason-tool-installer to ensure the specified tools are installed
    require("mason-tool-installer").setup({ 
        ensure_installed = ensure_installed 
    })
    
    -- Set up Mason-lspconfig with handlers for each server
    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                local server = servers[server_name] or {}
                
                -- This handles overriding only values explicitly passed
                -- by the server configuration. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for tsserver)
                server.capabilities = vim.tbl_deep_extend(
                    "force", 
                    {}, 
                    capabilities, 
                    server.capabilities or {}
                )
                
                -- Use lspconfig to set up the server with our configuration
                require("lspconfig")[server_name].setup(server)
            end,
        },
    })
end

-- Return the module
return M

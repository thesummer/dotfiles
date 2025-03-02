-- File: lua/lsp/lua_ls.lua
-- Lua Language Server (lua-ls) configuration
-- Documentation: https://luals.github.io/wiki/settings/

return {
    -- Command to start the language server
    -- cmd = { "lua-language-server" },

    -- Filetypes this server should be activated for
    -- filetypes = { "lua" },

    -- Additional capabilities can be defined here if needed
    -- capabilities = {},

    -- Server-specific settings
    settings = {
        Lua = {
            -- Tell the language server which Lua version we're using
            runtime = { 
                version = "LuaJIT" -- Most Neovim builds use LuaJIT
            },
            
            -- Workspace configuration
            workspace = {
                -- Disable third party checking to avoid prompt when starting
                checkThirdParty = false,
                
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your Neovim configuration
                library = {
                    -- Include Lua libraries that the language server should be aware of
                    "${3rd}/luv/library",
                    unpack(vim.api.nvim_get_runtime_file("", true)),
                },
                
                -- Performance alternative for slow machines
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
            },
            
            -- Completion settings
            completion = {
                -- Snippet behavior when completing function calls
                callSnippet = "Replace", -- Replace text with snippet when completing
            },
            
            -- Diagnostic settings
            -- You can toggle the following to ignore lua_ls's noisy `missing-fields` warnings
            -- diagnostics = { 
            --     disable = { 'missing-fields' } 
            -- },
        },
    },
    
    -- Bacon LSP settings (Rust analyzer helper)
    bacon = {
        -- This is a dynamic setting that depends on an external variable
        -- When using this module, you may need to set this appropriately
        enabled = false, -- Default to false, should be set to: diagnostics == "bacon-ls"
    },
    
    -- Disable rust-analyzer when loaded via this configuration
    rust_analyzer = { 
        enabled = false 
    },
}

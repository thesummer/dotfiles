-- File: lua/plugins/rust.lua
-- Rust-specific plugins and configuration
-- Includes rustaceanvim and crates.nvim for enhanced Rust development

return {
    { 
        -- Rust crates.io dependency manager integration
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },  -- Only load when editing Cargo.toml
        opts = {
            -- Add completion for crates in Cargo.toml
            completion = {
                crates = {
                    enabled = true,
                },
            },
            -- Enable LSP-like features
            lsp = {
                enabled = true,       -- Enable LSP features
                actions = true,       -- Enable code actions
                completion = true,    -- Enable completions
                hover = true,         -- Enable hover information
            },
        },
    },

    {
        -- Advanced Rust development plugin
        -- Provides enhanced rust-analyzer integration, debugging, and more
        "mrcjkb/rustaceanvim",
        version = vim.fn.has("nvim-0.10.0") == 0 and "^4" or false,  -- Version based on Neovim version
        ft = { "rust" },  -- Only load for Rust files
        opts = {
            server = {
                -- Custom key mappings when attached to a Rust buffer
                on_attach = function(_, bufnr)
                    -- Code action command specific to Rust
                    vim.keymap.set("n", "<leader>cR", function()
                        vim.cmd.RustLsp("codeAction")
                    end, { desc = "Code Action", buffer = bufnr })
                    
                    -- Debugging command for Rust
                    vim.keymap.set("n", "<leader>dr", function()
                        vim.cmd.RustLsp("debuggables")
                    end, { desc = "Rust Debuggables", buffer = bufnr })
                    
                    -- Additional keymaps you might want to add:
                    -- vim.keymap.set("n", "<leader>rr", function()
                    --     vim.cmd.RustLsp("runnables")
                    -- end, { desc = "Rust Runnables", buffer = bufnr })
                    
                    -- vim.keymap.set("n", "<leader>rt", function()
                    --     vim.cmd.RustLsp("testables")
                    -- end, { desc = "Rust Testables", buffer = bufnr })
                end,
                
                -- Default settings for rust-analyzer via rustaceanvim
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        -- Cargo configuration
                        cargo = {
                            allFeatures = true,               -- Enable all Cargo features
                            loadOutDirsFromCheck = true,      -- Load output dirs from check command
                            buildScripts = {
                                enable = true,                -- Enable build scripts support
                            },
                        },
                        
                        -- Diagnostics configuration
                        -- The original configuration used a variable 'diagnostics'
                        -- You may need to adjust this based on your setup
                        checkOnSave = true,                   -- Set to 'diagnostics == "rust-analyzer"' in original
                        
                        -- Enable diagnostics
                        diagnostics = {
                            enable = true,                    -- Set to 'diagnostics == "rust-analyzer"' in original
                        },
                        
                        -- Procedural macro configuration
                        procMacro = {
                            enable = true,                    -- Enable procedural macros support
                            -- Ignore certain macros for better performance
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                        
                        -- File exclusions for better performance
                        files = {
                            excludeDirs = {
                                ".direnv",
                                ".git",
                                ".github",
                                ".gitlab",
                                "bin",
                                "node_modules",
                                "target",
                                "venv",
                                ".venv",
                            },
                        },
                    },
                },
            },
        },
        -- Plugin initialization
        config = function(_, opts)
            -- Merge user options with defaults
            vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
            
            -- Check if rust-analyzer is installed, show error if missing
            if vim.fn.executable("rust-analyzer") == 0 then
                -- This error function might be specific to your Neovim configuration
                -- You may need to replace it with a more generic notification
                vim.notify(
                    "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
                    vim.log.levels.ERROR,
                    { title = "rustaceanvim" }
                )
            end
        end,
    },
}

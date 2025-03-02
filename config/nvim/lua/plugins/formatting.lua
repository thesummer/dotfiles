-- File: lua/plugins/formatting.lua
-- Code formatting configuration using conform.nvim
--
-- This module handles automatic code formatting on save.
-- 
-- Usage:
-- - Code is formatted automatically when saving files
-- - Use <leader>F to toggle auto-formatting globally
-- - Use :FormatToggle! to toggle formatting for just the current buffer
-- - Use :FormatEnable to re-enable formatting if disabled
-- 
-- To add support for a new language, add its formatter to the formatters_by_ft table.

return { -- Autoformat
    "stevearc/conform.nvim",
    -- Load the plugin when needed to improve startup time
    event = { "BufWritePre" }, -- Load before file save for autoformatting
    cmd = { "ConformInfo" },   -- Load when running the ConformInfo command
    
    config = function()
        -- Create a keymap to toggle autoformatting with <leader>F
        vim.api.nvim_set_keymap(
            "n",                         -- Normal mode
            "<leader>F",                 -- Keymap
            ":FormatToggle<cr>",         -- Command
            { silent = true, desc = "Toggle autoformat" } -- Options
        )
        
        -- Create a user command to toggle formatting
        vim.api.nvim_create_user_command("FormatToggle", function(args)
            if args.bang then
                -- FormatToggle! will toggle formatting just for this buffer
                vim.b.disable_autoformat = not vim.b.disable_autoformat
            else
                -- FormatToggle will toggle formatting globally
                vim.g.disable_autoformat = not vim.g.disable_autoformat
            end
        end, {
            desc = "Toggle autoformat-on-save",
            bang = true, -- Enable bang version (!), for buffer-local toggle
        })
        
        -- Create a user command to re-enable formatting
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })
        
        -- Configure conform.nvim
        require("conform").setup({
            -- Configure format-on-save behavior
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { 
                    timeout_ms = 2000,        -- Time out after 2 seconds
                    lsp_format = "fallback"   -- Use LSP format as fallback
                }
            end,
            
            -- Setup function runs when the plugin loads
            setup = function()
                -- By default, enable autoformat
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
                
                -- Create an autocmd to format on save
                vim.api.nvim_create_autocmd("BufWritePre", {
                    pattern = "*",  -- Apply to all files
                    callback = function(args)
                        require("conform").format({ bufnr = args.buf })
                    end,
                })
            end,
            
            -- Configure formatters for different file types
            formatters_by_ft = {
                lua = { "stylua" },      -- Format Lua with stylua
                cpp = { "clang_format" }, -- Format C++ with clang_format
                rust = { "rustfmt" },    -- Format Rust with rustfmt
                
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
                
                -- Additional formatters you might want to add:
                -- go = { "gofmt" },
                -- json = { "jq" },
                -- yaml = { "yamlfmt" },
                -- markdown = { "prettier" },
                -- html = { "prettier" },
                -- css = { "prettier" },
            },
            
            -- You can also configure specific formatter options:
            -- formatters = {
            --     stylua = {
            --         prepend_args = { "--indent-type", "spaces", "--indent-width", "4" },
            --     },
            --     clang_format = {
            --         prepend_args = { "--style", "file" },
            --     },
            -- },
        })
    end,
}

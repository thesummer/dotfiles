-- lua/plugins/debugger.lua
-- Configuration for debugging tools, including Termdebug

return {
    {
        -- This is a config-only entry for the built-in Termdebug plugin
        "neovim/nvim-lspconfig", -- Placeholder plugin entry (we're just using this for lazy.nvim structure)
        name = "termdebug-config",
        config = function()
            -- Use vertical layout for Termdebug
            vim.g.termdebug_wide = 1
            
            -- Don't open the binary file automatically
            vim.g.termdebug_disasm_window = 0
            
            -- Alternative approach to disable the binary file window
            vim.g.termdebug_disasm_enable = 0
            
            -- Track whether we've overridden the Termdebug command to avoid recursion
            vim.g.termdebug_custom_override_applied = false
            
            -- Function to override original Termdebug command
            function _G.override_termdebug_command()
                -- Only override if not already done to prevent recursion
                if vim.g.termdebug_custom_override_applied then
                    return
                end
                
                -- Mark that we've done the override
                vim.g.termdebug_custom_override_applied = true
                
                -- Save reference to the original Termdebug command implementation
                if vim.fn.exists("*OriginalTermdebug") == 0 then
                    vim.cmd([[
                        " Create a backup of the original Termdebug command
                        let s:termdebug_cmd = ""
                        silent! redir => s:termdebug_cmd
                        silent! command Termdebug
                        silent! redir END
                        
                        " Extract the command definition
                        let s:termdebug_cmd = substitute(s:termdebug_cmd, '^\n*\s*', '', '')
                        let s:termdebug_def = matchstr(s:termdebug_cmd, 'Termdebug[^:]*:[^a-zA-Z]*\zs.*$')
                        
                        " Store original implementation in a new command
                        if strlen(s:termdebug_def) > 0
                            execute "command! -nargs=? -complete=file OriginalTermdebug " . s:termdebug_def
                        endif
                    ]])
                end
                
                -- Replace the Termdebug command with our custom version
                vim.cmd([[
                    " Redefine Termdebug to use our custom command
                    command! -nargs=? -complete=file Termdebug call v:lua.redirect_to_custom_termdebug(<q-args>)
                ]])
            end
            
            -- Function to redirect from original to custom implementation
            function _G.redirect_to_custom_termdebug(args)
                vim.cmd("TermdebugCustom " .. (args or ""))
            end
            
            -- Create a custom command to start Termdebug with our preferred layout
            vim.api.nvim_create_user_command("TermdebugCustom", function(opts)
                -- First load the Termdebug plugin if not already loaded
                if vim.fn.exists(":OriginalTermdebug") == 0 then
                    vim.cmd("packadd termdebug")
                    -- Override the original command after loading
                    _G.override_termdebug_command()
                end
                
                -- Start the debugger with the provided binary using the original implementation
                if opts.args and opts.args ~= "" then
                    vim.cmd("OriginalTermdebug " .. opts.args)
                else
                    vim.cmd("OriginalTermdebug")
                end
                
                -- Additional adjustments after Termdebug starts
                -- Wait a bit for the windows to be created
                vim.defer_fn(function()
                    -- Resize the GDB window to make it narrower
                    vim.cmd("vertical resize -10")
                    
                    -- Optional: Move cursor to the GDB window
                    -- vim.cmd("wincmd h")
                end, 100)
            end, { nargs = "?", complete = "file", desc = "Start Termdebug with custom layout" })
            
            -- Create a function to ensure Termdebug is loaded before starting
            function _G.start_termdebug_custom()
                vim.cmd("packadd termdebug")
                -- Apply our override to the command
                _G.override_termdebug_command()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Termdebug ", true, false, true), "n", false)
            end
            
            -- Create an autocommand to override Termdebug when the plugin is loaded
            vim.api.nvim_create_autocmd("SourcePost", {
                pattern = {"*termdebug.vim", "*/termdebug.vim"},
                callback = function()
                    _G.override_termdebug_command()
                end,
                desc = "Override Termdebug command after plugin is loaded"
            })
            
            -- SWAPPED: Create keymapping for starting the debugger (<leader>dB)
            vim.keymap.set("n", "<leader>dB", function()
                _G.start_termdebug_custom()
            end, { desc = "Start debugger" })
            
            -- SWAPPED: Keybinding for setting breakpoint (<leader>db)
            vim.keymap.set("n", "<leader>db", ":Break<CR>", { desc = "Set breakpoint" })
            
            -- Additional keybindings for common debugger actions (unchanged)
            vim.keymap.set("n", "<leader>dC", ":Clear<CR>", { desc = "Clear breakpoint" })
            vim.keymap.set("n", "<leader>dc", ":Continue<CR>", { desc = "Continue execution" })
            vim.keymap.set("n", "<leader>dn", ":Over<CR>", { desc = "Step over" })
            vim.keymap.set("n", "<leader>ds", ":Step<CR>", { desc = "Step into" })
            vim.keymap.set("n", "<leader>df", ":Finish<CR>", { desc = "Step out" })
            vim.keymap.set("n", "<leader>dq", ":Stop<CR>", { desc = "Stop debugging" })
        end,
    }
}
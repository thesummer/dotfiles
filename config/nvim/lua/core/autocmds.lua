-- lua/core/autocmds.lua
-- Contains autocommands that are executed on specific events

-- [[ Highlight on Yank ]]
-- Briefly highlight the text that was copied
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- [[ Full-width Quickfix Window ]]
-- Create a function to open the quickfix list at full width across all splits
function _G.open_full_width_quickfix(height)
    height = height or "10" -- Default height if not specified
    
    -- Close existing quickfix window if any
    vim.cmd("cclose")
    
    -- Open quickfix at the bottom with full width
    vim.cmd("botright copen " .. height)
    
    -- No return to previous window - stay in the quickfix window
end

-- Create a command to call this function
vim.api.nvim_create_user_command("COpen", function(opts)
    local height = opts.args ~= "" and opts.args or nil
    _G.open_full_width_quickfix(height)
end, { nargs = "?", desc = "Open quickfix window full-width at bottom" })

-- Create an alias for the built-in copen command
vim.api.nvim_create_user_command("Copen", function(opts)
    _G.open_full_width_quickfix(opts.args)
end, { nargs = "?", desc = "Full-width version of copen" })

-- Create a key mapping for the original copen command to use our full-width version
vim.keymap.set("n", "<leader>qf", ":COpen<CR>", { silent = true, desc = "Open full-width quickfix" })

-- Create a Lua function that overrides copen via an autocmd
local quickfix_group = vim.api.nvim_create_augroup("full_width_quickfix", { clear = true })

vim.api.nvim_create_autocmd("CmdUndefined", {
    pattern = "copen",
    group = quickfix_group,
    callback = function()
        -- Define a new command that uses our function
        vim.api.nvim_create_user_command("Copen", function(opts)
            _G.open_full_width_quickfix(opts.args)
        end, { nargs = "?" })
        
        -- Create abbreviation from copen to Copen
        vim.cmd("cnoreabbrev <expr> copen getcmdtype() == ':' && getcmdline() == 'copen' ? 'Copen' : 'copen'")
    end,
})

-- Also create abbreviation in case autocmd doesn't get triggered
vim.cmd("cnoreabbrev <expr> copen getcmdtype() == ':' && getcmdline() == 'copen' ? 'Copen' : 'copen'")
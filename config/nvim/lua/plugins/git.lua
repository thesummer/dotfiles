-- File: lua/plugins/git.lua
-- Git integration plugins for Neovim

-- This file contains all Git-related plugins to keep them organized together.
-- If you want to add more Git functionality, add it here rather than creating new files.
-- 
-- Common Git workflows supported:
-- - File change indicators in the gutter (gitsigns)
-- - Git commands like status, blame, commit, etc. (fugitive)
-- - Git history browsing (gv.vim)

return {
    { 
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            -- Customize the signs displayed in the gutter
            signs = {
                add = { text = "+" },          -- Symbol for added lines
                change = { text = "~" },        -- Symbol for changed lines
                delete = { text = "_" },        -- Symbol for deleted lines
                topdelete = { text = "‾" },     -- Symbol for deleted lines at the top of file
                changedelete = { text = "~" },  -- Symbol for lines that are both changed and deleted
            },
            -- Additional configuration options available:
            -- numhl = false,                   -- Toggle line number highlights
            -- linehl = false,                  -- Toggle line highlights
            -- current_line_blame = false,      -- Toggle current line blame
            -- See :help gitsigns-config for complete configuration options
        },
    },
    {
        -- Full Git integration with commands like :Git commit, :Git blame, :Git diff, etc.
        "tpope/vim-fugitive",
        config = function()
            -- Key mappings for common Git operations
            vim.keymap.set("n", "<leader>gs", ":Git<cr>", { silent = true, desc = "Fugitive git status" })
            vim.keymap.set("n", "<leader>gb", ":Git blame<cr>", { silent = true, desc = "Git blame current file" })
            
            -- Additional useful mappings you might want to add:
            -- vim.keymap.set("n", "<leader>gc", ":Git commit<cr>", { silent = true, desc = "Git commit" })
            -- vim.keymap.set("n", "<leader>gd", ":Git diff<cr>", { silent = true, desc = "Git diff" })
            -- vim.keymap.set("n", "<leader>gl", ":Git log<cr>", { silent = true, desc = "Git log" })
        end,
    },
    {
        -- Git commit browser/explorer
        -- Depends on vim-fugitive and extends it with commit browsing
        "junegunn/gv.vim",
        dependencies = { "tpope/vim-fugitive" }, -- Add dependency on vim-fugitive explicitly
        -- Usage: 
        -- :GV to open commit browser
        -- :GV! to only show commits for current file
        -- :GV? to fill the location list with revisions of current file
    },
}

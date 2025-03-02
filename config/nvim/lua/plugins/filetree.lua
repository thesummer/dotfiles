-- File: lua/plugins/filetree.lua
-- Neo-tree file explorer configuration for lazy.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",       -- Lua utility functions used by many plugins
        "nvim-tree/nvim-web-devicons", -- Optional: Adds file icons to the tree
        "MunifTanjim/nui.nvim",        -- UI component library
        "s1n7ax/nvim-window-picker",   -- Helps pick a window when opening files
        -- "3rd/image.nvim",           -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        -- Define diagnostic icons for error levels
        vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
        
        -- Keybinding to toggle Neo-tree with <leader>n
        -- 'reveal_force_cwd' ensures the tree displays the current working directory
        vim.keymap.set(
            "n",                                      -- Normal mode
            "<leader>n",                              -- Keybinding (e.g., Space+n if leader is Space)
            ":Neotree toggle reveal_force_cwd<cr>",   -- Command to execute
            { silent = true, desc = "Toggle NeoTree file explorer" } -- Options and description for which-key
        )
        
        -- Configure Neo-tree with specific settings
        require("neo-tree").setup({
            -- File system configuration
            filesystem = {
                -- Do not change the cwd when navigating around in neo-tree
                bind_to_cwd = true,
                cwd_target = {
                    sidebar = "none",   -- Don't change cwd for sidebar
                    current = "none",   -- Don't change cwd for current window
                },
            },
            
            -- Window configuration
            window = {
                mappings = {
                    -- Navigation keybindings within Neo-tree
                    ["l"] = "open_with_window_picker",  -- Use 'l' to open files with window picker
                    ["h"] = "close_node",               -- Use 'h' to close nodes (go up a directory)
                },
            },
        })
    end,
}

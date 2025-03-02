-- File: lua/plugins/treesitter.lua
-- Treesitter configuration for syntax highlighting and code navigation

return { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Runs :TSUpdate when the plugin is installed/updated
    
    -- Configuration options to pass to the plugin
    opts = {
        -- Languages to install parsers for
        ensure_installed = { 
            "bash",
            "c",
            "html",
            "lua", 
            "markdown", 
            "rust", 
            "ron", 
            "vim", 
            "vimdoc" 
        },
        
        -- Automatically install parsers for files you open
        auto_install = true,
        
        -- Enable syntax highlighting using Treesitter
        highlight = { enable = true },
        
        -- Enable indentation using Treesitter
        indent = { enable = true },
        
        -- Other modules you can enable:
        -- 
        -- Incremental selection based on syntax tree:
        -- incremental_selection = {
        --     enable = true,
        --     keymaps = {
        --         init_selection = "<CR>",
        --         node_incremental = "<CR>",
        --         scope_incremental = "<S-CR>",
        --         node_decremental = "<BS>",
        --     },
        -- },
        --
        -- Syntax-aware text objects:
        -- textobjects = {
        --     enable = true,
        --     -- For more options, see nvim-treesitter-textobjects documentation
        -- },
    },
    
    config = function(_, opts)
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup(opts)
        
        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        --
        -- Additional useful plugins that work with Treesitter:
        --    - nvim-treesitter-refactor: Provides refactoring tools
        --    - nvim-treesitter-pairs: Provides smarter handling of delimiter pairs
        --    - playground: For debugging and exploring the syntax tree
    end,
}

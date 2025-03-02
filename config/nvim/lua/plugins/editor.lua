-- lua/plugins/editor.lua
-- Editor enhancement plugins that improve the editing experience

return {
  -- Automatically adjusts 'shiftwidth' and 'expandtab' based on the current file
  {
    "tpope/vim-sleuth",
    -- No configuration needed - works automatically
  },
  
  -- Easy commenting ("gc" to comment visual regions/lines)
  {
    "numToStr/Comment.nvim",
    opts = {}, -- Uses default configuration
  },
  
  -- Maximize and restore current window
  {
    "szw/vim-maximizer",
    config = function()
      vim.keymap.set(
        "n",
        "<leader>m",
        ":MaximizerToggle!<cr>",
        { silent = true, desc = "Maximize current window" }
      )
    end,
  },
  
  -- Collection of mini plugins for editing enhancements
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })
      
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- Examples:
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()
      
      -- Note: Other mini.nvim modules like statusline are configured in ui.lua
      -- More mini.nvim modules: https://github.com/echasnovski/mini.nvim
    end,
  },
  
  -- Highlight TODO, FIXME, NOTE, etc. in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter", -- Load when Vim starts
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { 
      signs = false, -- Don't show signs in the sign column
    },
  },
}

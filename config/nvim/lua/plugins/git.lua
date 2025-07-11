return {
  {
    -- Full Git integration with commands like :Git commit, :Git blame, :Git diff, etc.
    "tpope/vim-fugitive",
    config = function()
      -- Key mappings for common Git operations

      -- Additional useful mappings you might want to add:
      -- vim.keymap.set("n", "<leader>gc", ":Git commit<cr>", { silent = true, desc = "Git commit" })
      -- vim.keymap.set("n", "<leader>gd", ":Git diff<cr>", { silent = true, desc = "Git diff" })
      -- vim.keymap.set("n", "<leader>gl", ":Git log<cr>", { silent = true, desc = "Git log" })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "folke/snacks.nvim", -- optional
    },
  },
  {
    "sindrets/diffview.nvim", -- optional - Diff integration
    keys = {
      { "<leader>dq", "<cmd>DiffviewClose<cr>" },
    },
  },
}

return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
        command_palette = false,
      },
      cmdline = { view = "cmdline" },
    },
  },

  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          -- Disable, I currently just jump to a certain character
          enabled = false,
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    -- opts will be merged with the parent spec
    opts = {
      -- scroll = { enabled = false },
      scroll = { animate = { duration = { steps = 15, total = 50 } } },
      indent = { animate = { enabled = false } },
      picker = {
        -- open from the bottom (for the most part), but open explorer as sidebar
        layout = {
          preset = "ivy",
        },
        git = {
          enabled = false,
        },
        sources = {
          -- Make command history also open from the bottom
          command_history = {
            layout = {
              preset = "ivy",
              position = "bottom",
            },
          },
        },
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
    {
      "saghen/blink.cmp",
      opts = function(_, opts)
        -- Set up autocmd to disable completion in dap-repl
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "dap-repl",
          callback = function()
            vim.b.completion = false
          end,
          desc = "Disable completion in dap-repl",
        })

        return opts
      end,
    },
  },
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup()
      vim.keymap.set("n", "<leader>c", require("osc52").copy_operator, { expr = true })
      vim.keymap.set("n", "<leader>cc", "<leader>c_", { remap = true })
      vim.keymap.set("v", "<leader>c", require("osc52").copy_visual)

      -- Auto-copy to clipboard on yank
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.v.event.operator == "y" then
            require("osc52").copy(vim.fn.getreg('"'))
          end
        end,
      })
    end,
  },
}

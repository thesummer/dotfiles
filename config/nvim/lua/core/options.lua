-- lua/core/options.lua
-- Contains all Neovim configuration options organized by functionality

-- [[ Display Options ]]
-- These settings control how text and UI elements are displayed

-- Line Numbers
vim.opt.number = true                -- Show line numbers
-- vim.opt.relativenumber = true     -- Show relative line numbers (commented out by default)

-- Line Wrapping
vim.opt.wrap = true                  -- Turn on line wrapping
vim.opt.wrapmargin = 0               -- Wrap lines when coming within n characters from side
vim.opt.linebreak = true             -- Set soft wrapping
vim.opt.showbreak = "…"              -- Show ellipsis at breaking
vim.opt.breakindent = false          -- Don't indent wrapped lines

-- User Interface Elements
vim.opt.mouse = "a"                  -- Enable mouse mode, useful for resizing splits
vim.opt.showmode = false             -- Don't show the mode, since it's already in status line
vim.opt.signcolumn = "yes"           -- Keep signcolumn on by default
vim.opt.cursorline = true            -- Highlight the current line
vim.opt.laststatus = 2               -- Always show the status line
vim.opt.showcmd = true               -- Show incomplete commands
vim.opt.cmdheight = 1                -- Command bar height
vim.opt.title = true                 -- Set terminal title
vim.opt.showmatch = true             -- Show matching braces
vim.opt.mat = 2                      -- How many tenths of a second to blink matching brackets
vim.opt.scrolloff = 10               -- Minimal number of screen lines to keep above and below the cursor

-- Whitespace Characters
vim.opt.list = true                  -- Show some invisible characters
vim.opt.listchars = {                -- Configure which whitespace characters to show
    tab = "» ",                      -- Tab characters
    eol = "¬",                       -- End of line
    trail = "⋅",                     -- Trailing spaces
    extends = "❯",                   -- Line continues beyond right edge
    precedes = "❮",                  -- Line continues beyond left edge
    nbsp = "␣"                       -- Non-breaking spaces
}

-- [[ Editor Behavior ]]
-- Settings for editing and manipulating text

-- Indentation
vim.opt.autoindent = true            -- Automatically set indent of new line
vim.opt.expandtab = true             -- Replace tabs with spaces
vim.opt.smarttab = true              -- Tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
vim.opt.tabstop = 4                  -- The visible width of tabs
vim.opt.softtabstop = 4              -- Edit as if the tabs are 4 characters wide
vim.opt.shiftwidth = 4               -- Number of spaces to use for indent and unindent
vim.opt.shiftround = true            -- Round indent to a multiple of 'shiftwidth'

-- Code Folding
vim.opt.foldmethod = "syntax"        -- Fold based on syntax
vim.opt.foldlevelstart = 99          -- Do not fold by default
vim.opt.foldnestmax = 10             -- Deepest fold is 10 levels
vim.opt.foldenable = false           -- Don't fold by default

-- Splits
vim.opt.splitright = true            -- Open vertical splits to the right
vim.opt.splitbelow = false           -- Open horizontal splits above

-- [[ File Handling ]]
-- Options for how Neovim interacts with the file system

-- Clipboard
vim.opt.clipboard = "unnamedplus"    -- Sync clipboard between OS and Neovim

-- File Management
vim.opt.undofile = true              -- Save undo history
vim.opt.hidden = true                -- Allow modified buffers to be put in background

-- [[ Search and Completion ]]
-- Settings that control search behavior and command completion

-- Search Options
vim.opt.hlsearch = true              -- Highlight search results
vim.opt.ignorecase = true            -- Case-insensitive searching
vim.opt.smartcase = true             -- Case-sensitive if search contains capitals
vim.opt.incsearch = true             -- Show search matches as you type
vim.opt.magic = true                 -- Enable regular expressions

-- Command Line Completion
vim.opt.wildmode = "longest"         -- Complete files like a shell
vim.opt.inccommand = "split"         -- Preview substitutions live as you type

-- [[ Performance Settings ]]
-- Options that may affect Neovim's performance

vim.opt.lazyredraw = true            -- Don't redraw screen during macros
vim.opt.ttyfast = true               -- Faster redrawing
vim.opt.updatetime = 250             -- Decrease update time (milliseconds)
vim.opt.timeoutlen = 300             -- Time to wait for a mapped sequence to complete (milliseconds)

-- [[ Notification Settings ]]
-- Control audio and visual notifications

vim.opt.errorbells = false           -- Disable audio error bells
vim.opt.visualbell = false           -- Disable visual bell

-- lua/plugins/startscreen.lua
-- Configuration for the start screen (vim-startify)

return {
    "mhinz/vim-startify",
    init = function()
        -- Configure Startify settings
        vim.g.startify_files_number = 5             -- Number of files to show
        vim.g.startify_change_to_dir = 0            -- Don't change directory when selecting a file
        vim.g.startify_custom_header = {}           -- No custom header
        vim.g.startify_relative_path = 1            -- Show relative paths
        vim.g.startify_use_env = 1                  -- Use environment variables in paths
        
        -- Define the lists shown in the start screen
        vim.cmd([[
        let g:startify_lists = [
        \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
        \  { 'type': function('helpers#startify#listcommits'), 'header': [ 'Recent Commits' ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
        \  { 'type': 'commands',  'header': [ 'Commands' ]       },
        \ ]

        let g:startify_bookmarks = [
            \ { 'c': '~/.config/nvim/init.lua' },
            \ { 'g': '~/.gitconfig' },
            \ { 'z': '~/.zshrc' }
        \ ]
        ]])

        -- Add keybinding to reopen the start screen
        vim.keymap.set("n", "<leader>st", ":Startify<cr>", { silent = true, desc = "Load start screen" })
    end,
}

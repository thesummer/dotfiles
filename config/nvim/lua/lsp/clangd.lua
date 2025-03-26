-- File: lua/lsp/clangd.lua
-- C/C++ Language Server (clangd) configuration
-- Documentation: https://clangd.llvm.org/

return {
    -- Command to start the language server
    -- Using verbose logging for better debugging
    cmd = { "clangd", "--log=verbose", "--header-insertion=never", "--background-index" },

    -- Optional: You can specify filetypes if you want to override defaults
    -- filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

    -- Optional additional configuration options:

    -- root_dir - Customize how clangd determines the project root
    -- root_dir = function(fname)
    --     return require("lspconfig.util").root_pattern(
    --         "compile_commands.json",
    --         "compile_flags.txt",
    --         ".git"
    --     )(fname) or vim.fn.getcwd()
    -- end,

    -- init_options - Additional initialization options for clangd
    init_options = {
        -- Use clang-tidy for additional diagnostics
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true,
    },

    -- Additional useful clangd flags you might want to add to cmd:
    -- "--background-index"     - Build index in background for faster code navigation
    -- "--compile-commands-dir=<dir>" - Directory containing compile_commands.json
    -- "--clang-tidy"          - Enable clang-tidy diagnostics
    -- "--header-insertion=iwyu" - Add missing #include statements automatically
    -- "--suggest-missing-includes" - Suggest missing headers
    -- "--pch-storage=memory"  - Store PCHs in memory for faster access
    -- "--query-driver=/usr/bin/g++" - Specify compiler path for accurate includes
}

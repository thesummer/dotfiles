-- File: lua/lsp/rust.lua
-- Rust Language Server (rust-analyzer) configuration
-- Documentation: https://rust-analyzer.github.io/manual.html

-- Note: This is the basic rust-analyzer configuration
-- More advanced functionality is handled by rustaceanvim in lua/plugins/rust.lua

return {
    -- Set enabled to false when using rustaceanvim to avoid conflicts
    -- rustaceanvim handles the rust-analyzer configuration
    enabled = false,
    
    -- If you want to use rust-analyzer directly without rustaceanvim,
    -- set enabled to true and uncomment the configuration below
    
    -- Basic configuration for rust-analyzer
    -- settings = {
    --     ["rust-analyzer"] = {
    --         -- Cargo configuration
    --         cargo = {
    --             allFeatures = true,
    --             loadOutDirsFromCheck = true,
    --             buildScripts = {
    --                 enable = true,
    --             },
    --         },
    --         
    --         -- Enable diagnostics (set to true or use a variable)
    --         checkOnSave = true,
    --         diagnostics = {
    --             enable = true,
    --         },
    --         
    --         -- Procedural macro configuration
    --         procMacro = {
    --             enable = true,
    --             ignored = {
    --                 ["async-trait"] = { "async_trait" },
    --                 ["napi-derive"] = { "napi" },
    --                 ["async-recursion"] = { "async_recursion" },
    --             },
    --         },
    --         
    --         -- File exclusions
    --         files = {
    --             excludeDirs = {
    --                 ".direnv",
    --                 ".git",
    --                 ".github",
    --                 ".gitlab",
    --                 "bin",
    --                 "node_modules",
    --                 "target",
    --                 "venv",
    --                 ".venv",
    --             },
    --         },
    --     },
    -- },
}

# Install the nvim-dab-cortex plugin to have debugging for Titent
return {
  -- nvim-dap-cortex-debug for embedded debugging
  {
    "jedrzejboczar/nvim-dap-cortex-debug",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    ft = { "c", "cpp", "rust" },
    config = function()
      local dap_cortex = require("dap-cortex-debug")
      local dap = require("dap")
      
      -- Setup cortex-debug
      dap_cortex.setup({
        debug = false,
        gdb_path = "gdb-multiarch",
        jlink_path = "JLinkGDBServerExe",
      })
      
      -- Register the adapter
      if not dap.adapters["cortex-debug"] then
        dap_cortex.register_adapter()
      end
      
      -- Override configuration before launching
      local original_run = dap.run
      dap.run = function(config, ...)
        -- If it's a cortex-debug configuration, inject gdbPath
        if config.type == "cortex-debug" then
          config.gdbPath = config.gdbPath or "gdb-multiarch"
        end
        return original_run(config, ...)
      end
    end,
  },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   opts = {
  --     layouts = {
  --       {
  --         elements = {
  --           -- Elements for the sidebar
  --           { id = "scopes", size = 0.25 },
  --           { id = "breakpoints", size = 0.25 },
  --           { id = "stacks", size = 0.25 },
  --           { id = "watches", size = 0.25 },
  --         },
  --         size = 40,
  --         position = "left",
  --       },
  --       {
  --         elements = {
  --           "terminal",  -- Changed from "repl" to "terminal"
  --           "console",
  --         },
  --         size = 0.25,
  --         position = "bottom",
  --       },
  --     },
  --   },
  -- },
}

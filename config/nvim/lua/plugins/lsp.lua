return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--enable-config",
            "--header-insertion=never",
            "--query-driver=**/sparc-gaisler-rtems5-*",
            "--query-driver=**/sparc-rtems5-*",
            "--query-driver=**/arm-rtems5-*",
            "--query-driver=**/arm-xilinx-linux-gnueabi-*",
          },
        },
      },
    },
  },
}

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
  },
  opts = {
    ui = {
      enable = false,
    },
    workspaces = {
      {
        name = "main_vault",
        path = "/mnt/g/Meine Ablage/Obsidian/Main_vault",
      },
    },
  },
}

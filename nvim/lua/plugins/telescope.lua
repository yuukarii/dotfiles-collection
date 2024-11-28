return {
  "nvim-telescope/telescope.nvim",
  keys = function()
    return {
      { "ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "gr", builtin.lsp_references, desc = "Lists LSP references" },
      { "ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Lists Diagnostics" },
    }
  end,
}

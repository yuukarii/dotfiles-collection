return {
  "nvim-telescope/telescope.nvim",
  keys = function()
    return {
      { "ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    }
  end,
}

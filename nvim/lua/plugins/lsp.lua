return {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  keys = function()
    return {
      { "ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Show code action"},
    }
  end,
}

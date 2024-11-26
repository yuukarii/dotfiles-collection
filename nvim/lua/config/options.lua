vim.cmd 'colorscheme gruvbox'

vim.o.number = true          -- Enable absolute line numbers
vim.o.relativenumber = true  -- Enable relative line numbers

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.o.cursorline = true

vim.o.signcolumn = "yes"
-- Get the background color from the 'Normal' highlight group
local normal_bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")
-- Apply the background color to 'SignColumn'
vim.api.nvim_set_hl(0, "SignColumn", { bg = normal_bg })

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.history = 1000

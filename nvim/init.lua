vim.g.mapleader = " "

require("packer").startup(function(use)
	use "wbthomason/packer.nvim"
	use "ellisonleao/gruvbox.nvim"
  use "terrortylor/nvim-comment"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }
	use {
	  "nvim-telescope/telescope.nvim", 
	   tag = '0.1.1',
	   requires =  "nvim-lua/plenary.nvim" 
	}
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      {'neovim/nvim-lspconfig'},
      {                                     
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'},
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }
	use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" }
end)

-- TREESITTER
require("nvim-treesitter.configs").setup {
	ensure_installed = {"c", "lua", "vim", "go", "javascript", "typescript", "rust"},
	highlight = {
		enable = true,
	}
}

-- THEME
require("gruvbox").setup({
	contrast = "hard",
	palette_overrides = {
		gray = "#2ea542",
	},
	italic = {
		strings = false,
		comments = false
	}
})

vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")
vim.cmd[[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- LSP
local lsp = require("lsp-zero").preset({})
lsp.ensure_installed({ "gopls", "tsserver", "rust_analyzer" })
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
lsp.setup()

local cmp = require("cmp")
cmp.setup({
  mapping = {
   ["<CR>"] = cmp.mapping.confirm({ select = false })
  }
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
  end
})

-- Neogit
local neogit = require("neogit")
neogit.setup {}

-- Bindings
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><space>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>,", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>wv", ":vsplit<CR><C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>gg", neogit.open, {})

-- Misc
vim.opt.relativenumber = true
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.g.mapleader = " "

require("packer").startup(function(use)
	use "wbthomason/packer.nvim"
	use "ellisonleao/gruvbox.nvim"
  use "terrortylor/nvim-comment"
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use {
    "akinsho/toggleterm.nvim",
    tag = "*"
  }
  use {
    "mg979/vim-visual-multi",
    branch = "master"
  }
  use {
    "kylechui/nvim-surround",
    tag = "*",
    config = function () 
      require("nvim-surround").setup({})
    end
  }
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
lsp.ensure_installed({ "gopls", "tsserver", "rust_analyzer", "tailwindcss", "cssls", "emmet_ls" })
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig").emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { "html", "javascriptreact", "typescriptreact" },
})

lsp.setup()

local cmp = require("cmp")
cmp.setup({
  mapping = {
   ["<CR>"] = cmp.mapping.confirm({ select = true })
  }
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
  end
})

-- DAP
local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function() 
  dapui.open()
end
dap.listeners.after.event_terminated["dapui_config"] = function() 
  dapui.close()
end
dap.listeners.after.event_exited["dapui_config"] = function() 
  dapui.close()
end
vim.keymap.set("n", "<leader>od", dapui.toggle, {})

-- Neogit
local neogit = require("neogit")
neogit.setup {}
vim.keymap.set("n", "<leader>gg", neogit.open, {})

-- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader><space>", telescope.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
vim.keymap.set("n", "<leader>,", telescope.oldfiles, {})
vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})
vim.keymap.set("n", "<leader>oc", telescope.commands, {})

-- Terminal
local toggleterm = require("toggleterm")
toggleterm.setup({
  open_mapping = [[<leader>ot]]
})

-- Other bindings
vim.keymap.set("n", "<leader>wv", ":vsplit<CR><C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>ww", ":wincmd w<CR>", { noremap = true })
vim.keymap.set("n", "<leader><tab>n", ":tabnew<CR>", { noremap = true })

-- Misc
vim.opt.relativenumber = true
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

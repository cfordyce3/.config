-- general settings --
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"

vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = "wl-copy" -- make sure installed; change to xclip if on x11

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- colorscheme --
-- vim.cmd("colorscheme habamax")
vim.opt.termguicolors = true
vim.opt.background = dark
--vim.cmd("highlight Normal  guibg=none")
--vim.cmd("highlight NonText guibg=none")
--vim.cmd("highlight Normal  ctermbg=none")
--vim.cmd("highlight NonText ctermbg=none")

vim.g.mapleader = " "
vim.g.localmapleader = " "

-- autocommands in a separate file for cleanliness --
require("autocmds")

-- general keybinds --
local opts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'v', }, ' ', '<Nop>', { silent = true }) -- do nothing in normal mode
vim.keymap.set('n', 'x', '"_x', opts)                        -- don't keep deleted char in clipboard
-- <leader>pc = pack_clean: clean unused packages (autocmd)
vim.keymap.set('n', '<leader>w', ':write<CR>', opts)
vim.keymap.set('n', '<leader>q', ':quit<CR>', opts)
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', opts)
vim.keymap.set('n', '<leader>o', ':so<CR>', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', '<C-o>', '<C-o>zz', opts)
vim.keymap.set('n', '<C-i>', '<C-i>zz', opts)
vim.keymap.set('n', '<leader>n', ':bnext<CR>', opts)
vim.keymap.set('n', '<leader>N', ':bprev<CR>', opts)
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- plugins --
local gh = function(x) return "https://github.com/" .. x end
-- local cb = function(x) return "https://codeberg.org/" .. x end

-- kanagawa colorscheme
vim.pack.add({ gh("rebelot/kanagawa.nvim") })
require "kanagawa".setup({
  transparent = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  }
})
vim.cmd("colorscheme kanagawa")
--


-- tree-sitter
vim.pack.add({ {
  src = gh("nvim-treesitter/nvim-treesitter"),
  branch = "main",
  build = ":TSUpdate",
} })
require "nvim-treesitter".setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
require "nvim-treesitter".install({
  "lua",
  "bash",
  "vim",
  "c",
  "odin",
  "zig",
  "rust",
  "json",
  "markdown",
  "java",
  "c_sharp",
  "python",
  "javascript",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "odin", "rs", "cs", },
  callback = function() vim.treesitter.start() end,
})
--


-- oil file browser
vim.pack.add({ gh("stevearc/oil.nvim") })
require "oil".setup({})
vim.keymap.set('n', '<leader>e', ':Oil<CR>', opts)
--


-- lualine statusbar
vim.pack.add({ gh("nvim-lualine/lualine.nvim") })
require "lualine".setup()
--


-- mini plugins
vim.pack.add({
  { src = gh("nvim-mini/mini.icons"),      branch = "main" }, -- devicons
  -- {src = gh("nvim-mini/mini.git"), branch = "main"}, -- git integration
  { src = gh("nvim-mini/mini.surround"),   branch = "main" }, -- surround commands
  { src = gh("nvim-mini/mini.pairs"),      branch = "main" }, -- autopair brackets
  { src = gh("nvim-mini/mini.hipatterns"), branch = "main" }, -- highlighting for colors, todo, fixme
  { src = gh("nvim-mini/mini.snippets"),   branch = "main" }, -- snippet engine
  { src = gh("nvim-mini/mini.completion"), branch = "main" }, -- completion engine
})
require "mini.icons".setup()
require "mini.surround".setup()
require "mini.pairs".setup()                  -- autopair brackets
local hipatterns = require("mini.hipatterns") -- highlighting for colors, TODO, etc
hipatterns.setup({
  highlighters = {
    fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    todo      = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsHack" },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
require "mini.snippets".setup()
require "mini.completion".setup()
--


-- completion 
-- vim.keymap.set("i", "<C-return>", vim.lsp.completion.get)
--


-- lsp config and mason
vim.pack.add({
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
})
require "mason".setup()

vim.lsp.config("lua_ls", { -- fixes vim globarl warnings
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = "false" },
    },
  }
})

vim.lsp.config("csharp-ls", {
  cmd = { "csharp-ls" },
  filetypes = { "cs" },
  root_markers = { ".git" },
})


vim.lsp.enable({
  "lua_ls",
  "clangd",
  "pyright",
  "ols",
  "rust_analyzer",
  "qmlls",
  "csharp-ls"
})
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
--


-- rainbow brackets
vim.pack.add({ gh("HiPhish/rainbow-delimiters.nvim") })
require "rainbow-delimiters.setup".setup({
  strategy = {
    [""] = require("rainbow-delimiters").strategy["global"],
  },
  query = {
    [""] = "rainbow-delimiters",
    ["c"] = "rainbow-delimiters",
  },
})
--


-- markdowwn-plus
vim.pack.add({ gh("YousefHadder/markdown-plus.nvim") })
require "markdown-plus".setup()
--


-- harpoon
-- vim.pack.add({
--   { gh("nvim-lua/plenary.nvim") }, -- plenary is required
--   {
--     src = gh("ThePrimeagen/harpoon"),
--     branch = "harpoon2",
--   }
-- })
-- local harpoon = require "harpoon"
-- harpoon:setup()
--

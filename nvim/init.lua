-----------------------------------------------
------------------ Options --------------------
-----------------------------------------------

local o = vim.o

o.cursorline = true
o.mouse = "a"

vim.wo.number = true
o.relativenumber = true
o.signcolumn = "yes"

o.clipboard = "unnamedplus"
vim.g.clipboard = "wl-copy"

o.wrap = false
o.linebreak = true
o.scrolloff = 10
o.sidescrolloff = 10

o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true
o.autoindent = true
o.smarttab = true

o.ignorecase = true
o.smartcase = true
o.hlsearch = false
o.incsearch = true

o.termguicolors = true
o.background = "dark"
o.winborder = "rounded"

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- restore cursor location
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
            vim.schedule(function()
                vim.cmd("normal! zz")
            end)
        end
    end,
})

-- don't continue commending on newline
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("no_auto_commend", {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o", })
    end,
})

-- remove unused plugins
local function pack_clean()
    local active_plugins = {}
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        active_plugins[plugin.spec.name] = plugin.active
    end

    for _, plugin in ipairs(vim.pack.get()) do
        if not active_plugins[plugin.spec.name] then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        print("No unused plugins.")
        return
    end

    local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
    end
end

-- somethin to do with autocomplete
-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	group = vim.api.nvim_create_augroup('my.lsp', {}),
-- 	callback = function(args)
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
-- 		if client:supports_method('textDocument/completion') then
-- 			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
-- 			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
-- 			client.server_capabilities.completionProvider.triggerCharacters = chars
-- 			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })
-- vim.cmd("set completeopt+=noselect")
-----------------------------------------------
----------------- Keybinds --------------------
-----------------------------------------------
vim.g.mapleader = " "
local vk = vim.keymap
local opts = { noremap = true, silent = true }

-- do nothing in normal mode
vk.set({ 'n', 'v', }, ' ', '<Nop>', { silent = true })

-- don't keep char del in clipboard
vk.set('n', 'x', '"_x', opts)

-- center on scroll
vk.set('n', '<C-d>', '<C-d>zz', opts)
vk.set('n', '<C-u>', '<C-u>zz', opts)

-- basics
vk.set('n', '<leader>w', ':write<CR>', opts)
vk.set('n', '<leader>q', ':quit<CR>', opts)
vk.set('n', '<leader>Q', ':qa!<CR>', opts)

-- window nav
vk.set('n', '<C-k>', ':wincmd k<CR>', opts)
vk.set('n', '<C-j>', ':wincmd j<CR>', opts)
vk.set('n', '<C-h>', ':wincmd h<CR>', opts)
vk.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- buffer nav
vk.set('n', '<leader>n', ':bnext<CR>', opts)
vk.set('n', '<leader>N', ':bprev<CR>', opts)
vk.set('n', '<leader>c', ':bdelete<CR>', opts)

-- clean unused packages
vk.set('n', '<leader>pc', pack_clean)


-----------------------------------------------
------------------ Plugins --------------------
-----------------------------------------------

vim.pack.add({
    { src = "https://github.com/shaunsingh/nord.nvim" },            -- colorscheme
    { src = "https://github.com/nvim-mini/mini.icons" },            -- icons
    { src = "https://github.com/nvim-mini/mini.pairs" },            -- autopairs
    { src = "https://github.com/nvim-mini/mini.snippets" },         -- snippets
    { src = "https://github.com/nvim-mini/mini.completion" },       -- completion
    { src = "https://github.com/nvim-lualine/lualine.nvim" },       -- lualine statusbar
    { src = "https://github.com/stevearc/oil.nvim" },               -- oil (file browser)
    { src = "https://github.com/nvim-lua/plenary.nvim" },           -- plenary
    { src = "https://github.com/nvim-telescope/telescope.nvim" },   -- telescope
    -- { src = "https://github.com/nvim-mini/mini.pick" }, -- picker window
    { src = "https://github.com/HiPhish/rainbow-delimiters.nvim" }, -- rainbow delimiter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter
    { src = "https://github.com/neovim/nvim-lspconfig" },           -- lspconfig
    { src = "https://github.com/mason-org/mason.nvim" },            -- mason
    -- { src = "https://codeberg.org/ziglang/zig.vim" },               -- zig
})

-----------------------------------------------
--------------- Plugin Options ----------------
-----------------------------------------------

-- nord colorscheme
vim.g.nord_contrast = true
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_cursorline_transparent = false
vim.g.nord_enable_sidebar_background = false
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = false
vim.g.nord_bold = true
vim.cmd("colorscheme nord")
-- vim.cmd(":hi statusline guibg=NONE")

-- icons
require "mini.pairs".setup()

-- auto pairs
require "mini.pairs".setup()

-- snippets
require "mini.snippets".setup()

-- completion
require "mini.completion".setup()

-- lualine
require "lualine".setup()

-- oil
require "oil".setup()
vk.set('n', '<leader>e', ':Oil<CR>', opts)

-- picker window
-- require "mini.pick".setup({
--     mappings = {
--         move_down = '<C-n>',
--     }
-- })
-- vk.set('n', '<leader>ff', ':Pick files<CR>', opts)
-- vk.set('n', '<leader>fb', ':Pick buffers<CR>', opts)
-- vk.set('n', '<C-n>', ':Pick buffers<CR>', opts)

-- plenary

-- telescope
require "telescope".setup()
local t_builtin = require "telescope.builtin"
vk.set('n', '<leader>f', t_builtin.find_files, opts)
vk.set('n', '<leader>b', t_builtin.buffers, opts)
vk.set('n', '<leader>g', t_builtin.live_grep, opts)

-- rainbow delimiter

-- treesitter
require "nvim-treesitter".setup()
require "nvim-treesitter".install({
    "lua",
    "python",
    "c",
    "zig",
    "rust",
    "java",
})

-- lspconfig

-- mason
require "mason".setup()

-- zig


-----------------------------------------------
----------------- LSP Config ------------------
-----------------------------------------------

vim.lsp.enable({
    "lua_ls",
    "zls",
    "clangd",
    "pyright",
    "rust_analyzer"
})

-- fix the vim global warning
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    }
})

vk.set('n', '<leader>lf', vim.lsp.buf.format)

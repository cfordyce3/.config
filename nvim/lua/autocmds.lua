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

-- clean unused packages
vim.keymap.set('n', '<leader>pc', pack_clean)

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


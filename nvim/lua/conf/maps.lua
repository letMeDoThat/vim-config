-- More info:
-- :help nvim_set_keymap

vim.keymap.set({'n', 'x'}, 'j', 'gj', { desc = 'Move down in wrapped lines more naturally', noremap = true })
vim.keymap.set({'n', 'x'}, 'k', 'gk', { desc = 'Move up in wrapped lines more naturally', noremap = true })

vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit', silent = true })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save current buffer', silent = true })

vim.keymap.set('n', '<leader>n', ':noh<CR>', { desc = 'Disable search highlight', silent = true })

vim.keymap.set('n', '<leader><tab>', ':b#<CR>', { desc = 'Switch to last buffer', silent = true })

local function source_config_file()
  local current_file_path = vim.fn.expand("%:p")
  local file_ext = vim.fn.expand("%:e")
  local nvim_config_dir = vim.fn.stdpath("config")
  local dotfiles_dir = os.getenv("DOTFILES_DIR")

  if (current_file_path:find(nvim_config_dir, 1, true) or current_file_path:find(dotfiles_dir, 1, true)) and file_ext == 'lua' then
    vim.cmd("source " .. current_file_path)
    vim.api.nvim_echo({{"Sourced: " .. current_file_path}}, true, {})
  end
end
vim.keymap.set('n', '<leader>v', source_config_file, { desc = 'If in config dir and lua file is open, source it', silent = true })

vim.keymap.set({'n', 'x'}, 'cy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({'n', 'x'}, 'cY', '"+Y', { desc = 'Copy line(s) to clipboard' })

vim.keymap.set({'n', 'x'}, 'cp', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({'n', 'x'}, 'cP', '"+P', { desc = 'Paste from clipboard' })
vim.keymap.set({'n', 'x'}, '0p', '"0p', { desc = 'Paste from yank buffer' })
vim.keymap.set({'n', 'x'}, '0P', '"0P', { desc = 'Paste from yank buffer' })

vim.keymap.set({'i'}, 'jj', '<esc>', { desc = 'Exit from insert mode' })

vim.keymap.set({'i'}, '<C-a>', '<C-o>^', { desc = 'Move to the beggining of the line', noremap = false })
vim.keymap.set({'c'}, '<C-a>', '<Home>', { desc = 'Move to the beggining of the line', noremap = false })
vim.keymap.set({'i'}, '<C-e>', '<End>', { desc = 'Move to the end of the line', noremap = false })
vim.keymap.set({'c'}, '<C-e>', '<End>', { desc = 'Move to the end of the line', noremap = false })
vim.keymap.set({'i', 'c'}, '<C-l>', '<Right>', { desc = 'Move forward one character', noremap = false })
vim.keymap.set({'i', 'c'}, '<A-f>', '<S-Right>', { desc = 'Move one word forward' })
vim.keymap.set({'i', 'c'}, '<A-b>', '<S-Left>', { desc = 'Move one word backwards' })

-- tabs/splits management
vim.keymap.set('n', '<A-x>', ':sp<CR>', { desc = 'Split horizontally', noremap = true, nowait = true })
vim.keymap.set('n', '<A-v>', ':vsp<CR>', { desc = 'Split vertically', noremap = true, nowait = true })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left split', noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right split', noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower split', noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper split', noremap = true })

vim.keymap.set('n', '+', '10<C-w>>', { desc = 'Grow split vertically', noremap = true })
vim.keymap.set('n', '-', '10<C-w><', { desc = 'Shrink split vertically', noremap = true })
vim.keymap.set('n', '<A-+>', '5<C-w>+', { desc = 'Grow split horizontally', noremap = true })
vim.keymap.set('n', '<A-->', '5<C-w>-', { desc = 'Shrink split horizontally', noremap = true })

vim.keymap.set('n', '<A-t>', ':tabnew %<CR>', { desc = 'New tab with current file', noremap = true })

vim.keymap.set('n', '<A-h>', 'gT', { desc = 'Move focus to the next tab', noremap = true })
vim.keymap.set('n', '<A-l>', 'gt', { desc = 'Move focus to the previous tab', noremap = true })
vim.keymap.set('n', '<A-H>', ':tabm-1<CR>', { desc = 'Move tab right', noremap = true, silent = true })
vim.keymap.set('n', '<A-L>', ':tabm+1<CR>', { desc = 'Move tab left', noremap = true, silent = true })

vim.keymap.set('n', '<C-w>]', ':vert stag<CR>', { desc = 'Go to tag in vertical split', silent = true })
vim.keymap.set('n', '<C-w><C-]>', ':vert stag<CR>', { desc = 'Go to tag in vertical split', silent = true })

-- terminal mappings
vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n>', { desc = 'Exit insert mode in terminal', noremap = true, silent = true })

vim.keymap.set({'n'}, 'gp', '`[v`]', { desc = 'Select last pasted text' })

vim.keymap.set('n', '<M-LeftMouse>', '<LeftMouse><C-]>', { desc = 'Go to tag' })

local function toggle_quickfix()
  if vim.fn.getqflist({ winid = 0 }).winid > 0 then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end
vim.keymap.set("n", "zq", toggle_quickfix, { desc = 'Toggle quickfix list', noremap = true, silent = true  })

local function toggle_loclist()
  if vim.fn.getloclist(0, { winid = 0 }).winid > 0 then
    vim.cmd('lclose')
  else
    vim.cmd('lopen')
  end
end
vim.keymap.set("n", "zl", toggle_loclist, { desc = 'Toggle location list', noremap = true, silent = true  })

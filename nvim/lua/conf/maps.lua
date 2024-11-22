-- More info:
-- :help nvim_set_keymap

vim.keymap.set('n', '<leader><leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list'  })

vim.keymap.set('', 'j', 'gj', { desc = 'Move down in wrapped lines more naturally', noremap = true })
vim.keymap.set('', 'k', 'gk', { desc = 'Move up in wrapped lines more naturally', noremap = true })

vim.keymap.set('', '<A-O>', ':set paste<CR>O<Esc>:set nopaste<CR>', { desc = 'Insert empty line above', noremap = true })

vim.keymap.set('', '<leader>q', ':q<CR>', { desc = 'Quit', silent = true })
vim.keymap.set('', '<leader>w', ':w<CR>', { desc = 'Save current buffer', silent = true })

vim.keymap.set('', '<leader>n', ':noh<CR>', { desc = 'Disable search highlight', silent = true })

vim.keymap.set('n', '<leader><tab>', ':b#<CR>', { desc = 'Switch to last buffer', silent = true })

vim.keymap.set('n', '<leader>v', function() require("nvim-tree.api").tree.open({ path = os.getenv("HOME") .. "/.config/nvim" }) end, { desc = 'Go to config dir' })

vim.keymap.set({'n', 'v'}, 'cy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({'n', 'v'}, 'cY', '"+Y', { desc = 'Copy line(s) to clipboard' })

vim.keymap.set({'n', 'v'}, 'cp', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({'n', 'v'}, 'cP', '"+P', { desc = 'Paste from clipboard' })
vim.keymap.set({'n', 'v'}, '0p', '"0p', { desc = 'Paste from yank buffer' })
vim.keymap.set({'n', 'v'}, '0P', '"0P', { desc = 'Paste from yank buffer' })

vim.keymap.set({'i'}, 'jj', '<esc>', { desc = 'Exit from insert mode' })

vim.keymap.set({'i'}, '<C-a>', '<C-o>^', { desc = 'Move to the beggining of the line', noremap = false })
vim.keymap.set({'c'}, '<C-a>', '<Home>', { desc = 'Move to the beggining of the line', noremap = false })
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

vim.keymap.set('n', '<leader><leader>n', ':redraw!<CR>', { desc = 'Force redraw' })

vim.keymap.set({'n'}, 'gp', '`[v`]', { desc = 'Select last pasted text' })

vim.keymap.set('n', '<M-LeftMouse>', '<C-]>', { desc = 'Go to tag' })

-- text obejcts to select current line
vim.keymap.set('x', 'al', 'g_o^', { desc = 'Current line' })
vim.keymap.set('o', 'al', ':norm val<CR>', { desc = 'Current line' })

local function toggle_quickfix()
  local quickfix_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "quickfix" then
      quickfix_open = true
      break
    end
  end

  if quickfix_open then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

vim.keymap.set("n", "zq", toggle_quickfix, { noremap = true, silent = true  })

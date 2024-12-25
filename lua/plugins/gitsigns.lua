return {
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'tpope/vim-fugitive',
  },
  lazy = false,
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    current_line_blame = false,
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = '[s]tage hunk' })
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = '[r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
      map('n', '<leader>ha', gitsigns.stage_hunk, { desc = 'Stage hunk ([a]dd' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = '[u]ndo stage hunk' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
      map('n', '<leader>hb', function()
        gitsigns.blame_line { full = true }
      end, { desc = '[b]lame Line' })
      map('n', '<leader>tB', gitsigns.toggle_current_line_blame, { desc = 'Toggle [B]lame line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = '[d]iff this' })
      map('n', '<leader>hD', function()
        gitsigns.diffthis '~'
      end, { desc = '[D]iff this w/ ~' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Text Object Select Hunk' })
    end,
  },
}

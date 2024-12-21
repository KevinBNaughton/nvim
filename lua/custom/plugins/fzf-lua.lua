return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Calling setup is optional, only needed for customization.
    -- require('fzf-lua').setup {}
    local fzf = require 'fzf-lua'
    vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[s]earch [h]elp' })
    vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[s]earch [k]eymaps' })
    vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[s]earch [f]iles' })
    vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[s]earch [s]elect fzf-lua' })
    vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[s]earch current [w]ord' })
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[s]earch by [g]rep' })
    vim.keymap.set(
      'n',
      '<leader>sd',
      ":lua require'fzf-lua'.diagnostics_document({ fzf_opts = { ['--wrap'] = true } })<cr>",
      { desc = '[s]earch [d]iagnostics' }
    )
    vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[s]earch [r]esume' })
    vim.keymap.set('n', '<leader>sR', fzf.registers, { desc = '[s]earch [R]egisters' })
    vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>s/', fzf.grep_curbuf, { desc = '[s]earch in [/] open files' })
    vim.keymap.set('n', '<leader>sn', ":lua require'fzf-lua'.files({ cwd = vim.fn.stdpath 'config' })<cr>", { desc = '[s]earch [n]eovim files' })
  end,
}

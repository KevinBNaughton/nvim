-- This contains mainly Neogit but also a bunch of Git settings
-- like fetching branches with telescope or blaming with fugitive
return {
  'NeogitOrg/neogit',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'ibhagwan/fzf-lua', -- optional
  },
  keys = {
    { '<leader>gg', '<cmd>Neogit<CR>', mode = { 'n' }, desc = 'Open Neogit' },
    { '<leader>gc', ':Neogit commit<CR>', mode = { 'n' }, desc = 'Neo[g]it [c]ommit' },
    { '<leader>gp', ':Neogit pull<CR>', mode = { 'n' }, desc = 'Neo[g]it [p]ull' },
    { '<leader>gP', ':Neogit push<CR>', mode = { 'n' }, desc = 'Neo[g]it [P]ush' },
    { '<leader>gb', ':FzfLua git_branches<CR>', mode = { 'n' }, desc = 'FzfLua [g]it [b]ranches' },
    { '<leader>gB', ':G blame<CR>', mode = { 'n' }, desc = '[g]it [B]lame' },
  },
}

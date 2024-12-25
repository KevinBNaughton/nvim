local harpoon = require 'harpoon'

harpoon:setup {}

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = '[a]dd Harpoon mark' })

vim.keymap.set('n', '<leader>o', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'View Harp[o]on marks' })

local function pick_harpoon_file()
  local harp = require 'harpoon'
  local fzf_lua = require 'fzf-lua'

  -- Retrieve a list of marked files from Harpoon
  local marks = harp:list()
  if not marks then
    print 'Harpoon: No marked files'
    return
  end

  -- Transform each entry into a string: "1) path/to/file"
  local entries = {}
  for idx, mark in ipairs(marks.items) do
    local display_str = string.format('%d) %s', idx, mark.value)
    table.insert(entries, display_str)
  end

  fzf_lua.fzf_exec(entries, {
    prompt = 'Harpoon> ',
    actions = {
      -- 'default' is triggered by `<CR>`
      ['default'] = function(selected)
        local choice = selected[1]
        local index = tonumber(choice:match '^(%d+)')
        if index then
          harp:list():select(index)
        end
      end,
    },
  })
end

vim.keymap.set('n', '<leader>so', pick_harpoon_file, { desc = '[s]earch Harp[o]on marks' })

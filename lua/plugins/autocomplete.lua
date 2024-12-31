return {
  'saghen/blink.cmp',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        -- See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
  },
  version = '*',

  opts = function(_, opts)
    opts.completion = {
      keyword = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before *and* after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        range = 'prefix',
        -- Regex used to get the text when fuzzy matching
        regex = '[-_]\\|\\k',
        -- After matching with regex, any characters matching this regex at the prefix will be excluded
        exclude_from_prefix_regex = '[\\-]',
      },

      trigger = {
        -- When true, will prefetch the completion items when entering insert mode
        prefetch_on_insert = false,
        -- When false, will not show the completion window automatically when in a snippet
        show_in_snippet = true,
        -- When true, will show the completion window after typing a character that matches the `keyword.regex`
        show_on_keyword = true,
        -- When true, will show the completion window after typing a trigger character
        show_on_trigger_character = true,
        -- LSPs can indicate when to show the completion window via trigger characters
        -- however, some LSPs (i.e. tsserver) return characters that would essentially
        -- always show the window. We block these by default.
        show_on_blocked_trigger_characters = function()
          if vim.api.nvim_get_mode().mode == 'c' then
            return {}
          end
          -- you can also block per filetype, for example:
          -- if vim.bo.filetype == 'markdown' then
          --   return { ' ', '\n', '\t', '.', '/', '(', '[' }
          -- end
          return { ' ', '\n', '\t' }
        end,

        -- When both this and show_on_trigger_character are true, will show the completion window
        -- when the cursor comes after a trigger character after accepting an item
        show_on_accept_on_trigger_character = true,
        -- When both this and show_on_trigger_character are true, will show the completion window
        -- when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
        -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
        -- the completion window when the cursor comes after a trigger character when
        -- entering insert mode/accepting an item
        show_on_x_blocked_trigger_characters = { "'", '"', '(' },
        -- or a function, similar to show_on_blocked_trigger_character
      },

      list = {
        -- Maximum number of items to display
        max_items = 200,
        -- Controls if completion items will be selected automatically,
        -- and whether selection automatically inserts
        selection = 'auto_insert',
        -- selection = function(ctx) return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect' end,
        -- Controls how the completion items are selected
        -- 'preselect' will automatically select the first item in the completion list
        -- 'manual' will not select any item by default
        -- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
        --
        -- You may want to bind a key to the `cancel` command, which will undo the selection
        -- when using 'auto_insert'
        cycle = {
          -- When `true`, calling `select_next` at the *bottom* of the completion list
          -- will select the *first* completion item.
          from_bottom = true,
          -- When `true`, calling `select_prev` at the *top* of the completion list
          -- will select the *last* completion item.
          from_top = true,
        },
      },

      accept = {
        -- Create an undo point when accepting a completion item
        create_undo_point = true,
        -- Experimental auto-brackets support
        auto_brackets = {
          -- Whether to auto-insert brackets for functions
          enabled = true,
          -- Default brackets to use for unknown languages
          default_brackets = { '(', ')' },
          -- Overrides the default blocked filetypes
          override_brackets_for_filetypes = {},
          -- Synchronously use the kind of the item to determine if brackets should be added
          kind_resolution = {
            enabled = true,
            blocked_filetypes = { 'typescriptreact', 'javascriptreact', 'vue' },
          },
          -- Asynchronously use semantic token to determine if brackets should be added
          semantic_token_resolution = {
            enabled = true,
            blocked_filetypes = { 'java' },
            -- How long to wait for semantic tokens to return before assuming no brackets should be added
            timeout_ms = 400,
          },
        },
      },

      menu = {
        enabled = true,
        min_width = 15,
        max_height = 10,
        border = 'none',
        winblend = 0,
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        -- Keep the cursor X lines away from the top/bottom of the window
        scrolloff = 2,
        -- Note that the gutter will be disabled when border ~= 'none'
        scrollbar = true,
        -- Which directions to show the window,
        -- falling back to the next direction when there's not enough space
        direction_priority = { 's', 'n' },
        -- Whether to automatically show the window when new completion items are available
        auto_show = true,
        -- Screen coordinates of the command line
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            return { pos[1] - 1, pos[2] }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height, 0 }
        end,

        -- Controls how the completion items are rendered on the popup window
        draw = {
          -- Aligns the keyword you've typed to a component in the menu
          -- align_to = 'label', -- or 'none' to disable, or 'cursor' to align to the cursor
          -- Left and right padding, optionally { left, right } for different padding on each side
          padding = 1,
          -- Gap between columns
          gap = 1,
          -- Use treesitter to highlight the label text
          treesitter = {},
          -- Components to render, grouped by column
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
          -- Definitions for possible components to render. Each defines:
          --   ellipsis: whether to add an ellipsis when truncating the text
          --   width: control the min, max and fill behavior of the component
          --   text function: will be called for each item
          --   highlight function: will be called only when the line appears on screen
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
              end,
            },

            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
              end,
            },

            label = {
              width = { fill = true, max = 60 },
              text = function(ctx)
                return ctx.label .. ctx.label_detail
              end,
              highlight = function(ctx)
                -- label and label details
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                }
                if ctx.label_detail then
                  table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                end
                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end
                return highlights
              end,
            },

            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = 'BlinkCmpLabelDescription',
            },

            source_name = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.source_name
              end,
              highlight = 'BlinkCmpSource',
            },
          },
        },
      },
      documentation = {
        -- Controls whether the documentation window will automatically show when selecting a completion item
        auto_show = true,
        -- Delay before showing the documentation window
        auto_show_delay_ms = 300,
        -- Delay before updating the documentation window when selecting a new item,
        -- while an existing item is still visible
        update_delay_ms = 50,
        -- Whether to use treesitter highlighting, disable if you run into performance issues
        treesitter_highlighting = true,
        window = {
          min_width = 10,
          max_width = 60,
          max_height = 20,
          border = 'padded',
          winblend = 0,
          winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
          -- Note that the gutter will be disabled when border ~= 'none'
          scrollbar = true,
          -- Which directions to show the documentation window,
          -- for each of the possible menu window directions,
          -- falling back to the next direction when there's not enough space
          direction_priority = {
            menu_north = { 'e', 'w', 'n', 's' },
            menu_south = { 'e', 'w', 's', 'n' },
          },
        },
      },
      -- Displays a preview of the selected item on the current line
      ghost_text = {
        enabled = false,
      },
    }
    -- Merge custom sources with the existing ones from lazyvim
    -- NOTE: by default lazyvim already includes the lazydev source, so not
    -- adding it here again
    opts.sources = vim.tbl_deep_extend('force', opts.sources or {}, {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'luasnip' },
      --   TODO - Maybe integrate dadbod
      --   default = { 'dadbod' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          fallbacks = { 'lsp', 'snippets', 'luasnip', 'buffer' },
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100, -- the higher the number, the higher the priority
        },
        lsp = {
          name = 'lsp',
          enabled = true,
          module = 'blink.cmp.sources.lsp',
          -- When linking markdown notes, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no LSP
          -- suggestions
          fallbacks = { 'snippets', 'luasnip', 'buffer' },
          score_offset = 90, -- the higher the number, the higher the priority
        },
        luasnip = {
          name = 'luasnip',
          enabled = true,
          module = 'blink.cmp.sources.luasnip',
          min_keyword_length = 2,
          fallbacks = { 'snippets' },
          score_offset = 85, -- the higher the number, the higher the priority
        },
        -- TODO - Example on how to configure dadbod found in the main repo
        -- https://github.com/kristijanhusak/vim-dadbod-completion
        -- dadbod = {
        --   name = 'Dadbod',
        --   module = 'vim_dadbod_completion.blink',
        --   score_offset = 83, -- the higher the number, the higher the priority
        -- },
        snippets = {
          name = 'snippets',
          enabled = true,
          module = 'blink.cmp.sources.snippets',
          score_offset = 80, -- the higher the number, the higher the priority
        },
        path = {
          name = 'Path',
          module = 'blink.cmp.sources.path',
          score_offset = 3,
          -- When typing a path, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no path
          -- suggestions
          fallbacks = { 'snippets', 'luasnip', 'buffer' },
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = 'Buffer',
          module = 'blink.cmp.sources.buffer',
          min_keyword_length = 2,
        },
      },
    })

    -- This comes from the luasnip extra, if you don't add it, won't be able to
    -- jump forward or backward in luasnip snippets
    -- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
    opts.snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    }

    -- The default preset used by lazyvim accepts completions with enter
    -- I don't like using enter because if on markdown and typing
    -- something, but you want to go to the line below, if you press enter,
    -- the completion will be accepted
    -- https://cmp.saghen.dev/configuration/keymap.html#default
    opts.keymap = {
      preset = 'default',
      ['<Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ['<C-y>'] = { 'select_and_accept' },
      ['<C-CR>'] = { 'select_and_accept' },

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
    }

    opts.appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    }

    return opts
  end,
}

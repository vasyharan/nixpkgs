local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local telescope = require('telescope')

telescope.setup{
  defaults = {
    file_sorter = sorters.get_fzy_sorter,
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    layout_config = {
      bottom_pane = {
        preview_title = "",
        height = 25,
        max_lines = 20,
      },
    },
    border = true,
    borderchars = {
      "z",
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-x>"] = actions.delete_buffer,
          ["<C-s>"] = actions.select_horizontal,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
    }
  }
}
telescope.load_extension('fzf')

vim.cmd [=[
highlight TelescopeSelection ctermfg=15 ctermbg=0 guifg=#f9f9ff guibg=#1b1d25 guisp=#f9f9ff
highlight Special            ctermfg=12 guifg=#57c7fe
]=]

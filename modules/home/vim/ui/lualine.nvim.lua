local lualine = require('lualine')
local statusline = require('lsp-status/statusline')

modemap = {
  ['n']    = 'No',
  ['nt']    = 'Nt',
  ['no']   = 'O-PENDING',
  ['nov']  = 'O-PENDING',
  ['noV']  = 'O-PENDING',
  ['no'] = 'O-PENDING',
  ['niI']  = 'No',
  ['niR']  = 'No',
  ['niV']  = 'No',
  ['v']    = 'Vv',
  ['V']    = 'VL',
  ['']   = 'Vb',
  ['s']    = 'Ss',
  ['S']    = 'SL',
  ['']   = 'Sb',
  ['i']    = 'In',
  ['ic']   = 'In',
  ['ix']   = 'In',
  ['R']    = 'Re',
  ['Rc']   = 'Re',
  ['Rv']   = 'V-REPLACE',
  ['Rx']   = 'Re',
  ['c']    = 'Cm',
  ['cv']   = 'EX',
  ['ce']   = 'EX',
  ['r']    = 'Re',
  ['rm']   = 'MORE',
  ['r?']   = 'CONFIRM',
  ['!']    = 'Sh',
  ['t']    = 'Tr',
}

function mode()
    local mode_code = vim.api.nvim_get_mode().mode
    local mode_str = modemap[mode_code]
    if mode_str == nil then return mode_code end
    return mode_str
end

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    section_separators = {'', ''},
    component_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { mode },
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {
      {
        'diagnostics',
        sources = {"nvim_diagnostic"},
        symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
      },
      statusline.progress,
      'encoding',
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive', 'nerdtree', 'quickfix'}
}

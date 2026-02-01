return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      local function set_statusline_hl()
        vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = '#eee8d5', bg = '#073642', bold = false })
        vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = '#93a1a1', bg = '#073642' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = '#93a1a1', bg = '#073642' })
      end
      set_statusline_hl()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('custom-mini-statusline-hl', { clear = true }),
        callback = set_statusline_hl,
      })
    end,
  },
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'ecma',
        'jsx',
        'typescript',
        'tsx',
        'javascript',
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      local ok, ts_config = pcall(require, 'nvim-treesitter.configs')
      if not ok then
        ts_config = require('nvim-treesitter.config')
      end
      ts_config.setup(opts)
    end,
  },
}

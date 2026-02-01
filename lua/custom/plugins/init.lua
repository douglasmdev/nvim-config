local specs = {}

local function add(module)
  local ok, items = pcall(require, module)
  if not ok then
    error(('Failed loading %s: %s'):format(module, items))
  end
  vim.list_extend(specs, items)
end

add 'custom.plugins.guess-indent'
add 'custom.plugins.gitsigns'
add 'custom.plugins.which-key'
add 'custom.plugins.telescope'
add 'custom.plugins.lazydev'
add 'custom.plugins.lspconfig'
add 'custom.plugins.conform'
add 'custom.plugins.blink-cmp'
add 'custom.plugins.neosolarized'
add 'custom.plugins.todo-comments'
add 'custom.plugins.mini'
add 'custom.plugins.treesitter'
add 'custom.plugins.debug'
add 'custom.plugins.indent_line'
add 'custom.plugins.lint'
add 'custom.plugins.autopairs'
add 'custom.plugins.neo-tree'
add 'custom.plugins.yazi'

return specs

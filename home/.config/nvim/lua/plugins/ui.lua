return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'lua', 'vim', 'vimdoc', 'c_sharp', 'swift', 'bash', 'json', 'markdown' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}

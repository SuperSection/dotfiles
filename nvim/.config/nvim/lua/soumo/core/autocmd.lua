vim.api.nvim_create_autocmd("FileType", {
  pattern = "css",
  callback = function()
    vim.bo.filetype = "tailwindcss"
  end,
})

vim.cmd([[
  autocmd BufRead,BufNewFile *.ex, *.exs set filetype=elixir
]])

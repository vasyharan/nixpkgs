function trim(arg, startLine, endLine)
  -- reference: https://vim.fandom.com/wiki/Remove_unwanted_spaces
  vim.api.nvim_exec([[silent! %s/\s\+$//e]], false)
  -- reference: https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim
  vim.api.nvim_exec([[silent! %s#\($\n\s*\)\+\%$##]], false)
end

vim.cmd [=[command! -nargs=? -range=% -bang Trim lua trim(<q-args>, <line1>, <line2>)]=]

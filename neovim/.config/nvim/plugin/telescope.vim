lua require("rnprest")

nnoremap <leader>fg :lua require('telescope.builtin').live_grep()<cr>
nnoremap <Leader>ff :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fb :lua require('telescope.builtin').buffers()<CR>

nnoremap <leader>dot :lua require('rnprest.telescope').search_dotfiles()<CR>

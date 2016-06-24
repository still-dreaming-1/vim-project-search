call Log('project-search plugin start')
nmap <leader>* <Plug>(project_search-find_word_undor_cursor)
nnoremap <Plug>(project_search-find_word_undor_cursor) :call project_search#find_word_under_cursor_in_current_file_types()<CR>
"Default mapping to use for this. Since this is using <Plug> it can easilly be changed by the user
" search commands (may want to look into using and mapping :cnext and :cprev in conjuction with this. It may work well if the first result is automatically 'selected')
" Fc = find current
command! -nargs=1 Fc set hlsearch | call project_search#find_in_current_file_types(<f-args>)

let s:current_script_path= expand('<sfile>')
let g:project_search_dir_path= Dir(s:current_script_path).parent().parent().path
call Log('project-search plugin end')

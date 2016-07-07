call l#log('project-search plugin start')
if !hasmapto('<Plug>(project_search-find_word_undor_cursor)') 
	nmap <leader>* <Plug>(project_search-find_word_undor_cursor)
endif 
nnoremap <Plug>(project_search-find_word_undor_cursor) :call project_search#find_word_under_cursor_in_current_file_types()<CR>
"Default mapping to use for this. Since this is using <Plug> it can easilly be changed by the user
" search commands (may want to look into using and mapping :cnext and :cprev in conjuction with this. It may work well if the first result is automatically 'selected')
" Fc = find current
command! -nargs=1 Fc set hlsearch | call project_search#find_in_current_file_types(<f-args>)

let s:current_script_path= expand('<sfile>')
let g:project_search_dir_path= L_dir(s:current_script_path).parent().parent().path
call l#log('project-search plugin end')

call l#log('project-search plugin start')
let maps = L_maps()
if !maps.normal_mode_map_exists_to('<Plug>(project_search-find_word_undor_cursor)')
    if !maps.normal_mode_map_exists_from('<leader>*')
        "Default mapping to use for this. Since this is using <Plug> it can easilly be changed by the user
        nmap <leader>* <Plug>(project_search-find_word_undor_cursor)
    endif
endif
nnoremap <Plug>(project_search-find_word_undor_cursor) :call project_search#find_word_under_cursor_in_current_file_types()<CR>
" search commands (may want to look into using and mapping :cnext and :cprev in conjuction with this. It may work well if the first result is automatically 'selected')
" Fc = find current
command! -nargs=1 Fc set hlsearch | call project_search#find_in_current_file_types(<f-args>, 0)
" Fsc = find case-sensitive current
command! -nargs=1 Fsc set hlsearch | call project_search#find_in_current_file_types(<f-args>, 1)
" Fa = find all
command! -nargs=1 Fa set hlsearch | call project_search#find_in_all_file_types(<f-args>, 0)
" Fa = find case-sensitive all
command! -nargs=1 Fsa set hlsearch | call project_search#find_in_all_file_types(<f-args>, 1)

let s:current_script_path = expand('<sfile>')
let g:project_search_dir_path = L_dir(s:current_script_path).parent().parent().path
if exists('g:project_search_exclude_dir_paths') == 0
    let g:project_search_exclude_dir_paths = []
endif
call l#log('project-search plugin end')

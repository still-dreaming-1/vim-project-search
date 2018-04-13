call l#log('project-search autoload start')

function! project_search#find_word_under_cursor_in_current_file_types() abort
    call project_search#find_in_current_file_types(L_current_cursor().word())
endfunction

function! project_search#find_in_current_file_types(search) abort
    call l#log('project_search#find_in_current_file_types start')
    call project_search#find(a:search, 1)
    call l#log('project_search#find_in_current_file_types end')
endfunction

function! project_search#find_in_all_file_types(search) abort
    call l#log('project_search#find_in_all_file_types start')
    call project_search#find(a:search, 0)
    call l#log('project_search#find_in_all_file_types end')
endfunction

function! project_search#find(search, only_current_file_types) abort
    call l#log('project_search#find start')
    let current_file_extension = L_current_buffer().file().extension
    " create a scratch buffer below the current window
    below new
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    let escaped_search = shellescape(a:search)
    let command = 'grep -Frin'
    if a:only_current_file_types
        let include_param = shellescape('*.'.current_file_extension)
        let command = command.' --include='.include_param
    endif
    if len(g:project_search_exclude_dir_paths) > 0
        for path in g:project_search_exclude_dir_paths
            let exclude_param = shellescape(path)
            let command = command.' --exclude-dir='.exclude_param
        endfor
    endif
    " the -- in the following shell code signifies to grep that the options
    " have now ended and only positional parameters follow. This allows the
    " character "-" to be searched on.
    let command = command.' -- '.escaped_search.' .'
    let out = L_shell().run(command)
    call L_current_buffer().append_line(split(out, '\n'))
    normal! ggdd
    " Vim is designed so that searching in Vimscript does not replace the last search. This is a workaround for that.
    " It still does not highlight the last search term unless the user had already searched on something
    let no_magic_string = L_s(a:search).get_no_magic().str
    let @/ = no_magic_string
    call l#log('project_search#find in search result buffer no magic search string: '.no_magic_string)
    normal! n
    call matchadd('Search', a:search)
    nnoremap <buffer> q :bdelete<CR>

    " This mapping changes the meaning of the enter key in normal mode to do
    " the following while you are in a search result buffer. Move the cursor
    " to the top window, close that window bringing the cursor back to the
    " search results window, go to the beginning of the line, split the window
    " and go to the file and line number under the cursor:
    let b:project_search_current_search = a:search
    nnoremap <buffer><CR> :let g:project_search_go_to_on_line = b:project_search_current_search<CR>:Top<CR>:q<CR>^<C-W>F:call project_search#go_to_first_match_on_current_line()<CR>

    " Bring the cursor to the matching search in the results buffer. The 'c' makes
    " it accept a match at the cursor position which allows this to work
    " correctly when the match is at the beginning of the line:
    call search(no_magic_string, 'c')

    call l#log('project_search#find end')
endfunction

function! project_search#go_to_first_match_on_current_line() abort
    let search_string = g:project_search_go_to_on_line
    normal! 0
    let current_line_s = L_s(getline('.'))
    let number_characters_to_the_right = current_line_s.index_of(search_string)
    while number_characters_to_the_right > 0
        normal! l
        let number_characters_to_the_right -= 1
    endwhile
endfunction

call l#log('project-search autoload end')

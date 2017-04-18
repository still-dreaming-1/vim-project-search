call l#log('project-search autoload start')

function! project_search#find_word_under_cursor_in_current_file_types()
    call project_search#find_in_current_file_types(L_current_cursor().word())
endfunction

function! project_search#find_in_current_file_types(search)
    call l#log('project_search#find_in_current_file_types start')
    call project_search#find(a:search, 1)
    call l#log('project_search#find_in_current_file_types end')
endfunction

function! project_search#find_in_all_file_types(search)
    call l#log('project_search#find_in_all_file_types start')
    call project_search#find(a:search, 0)
    call l#log('project_search#find_in_all_file_types end')
endfunction

function! project_search#find(search, only_current_file_types)
    call l#log('project_search#find_in_all_file_types start')
    let current_file_extension = L_current_buffer().file().extension
    " create a scratch buffer below the current window
    below new
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    let escaped_search = shellescape(a:search)
    let command = 'grep -Frin'
    if a:only_current_file_types
        " let command = command.' --include="*.'.current_file_extension.'"'
        let include_param = shellescape('*.'.current_file_extension)
        " let command = command.' --include="*.'.current_file_extension.'"'
        let command = command.' --include='.include_param
    endif
    " the -- in the following shell code signifies to grep that the options
    " have now ended and only positional parameters follow. This allows the
    " character "-" to be searched on.
    let command = command.' -- '.escaped_search.' .'
    let out = L_shell().run(command)
    call L_current_buffer().append_line(split(out, '\n'))
    normal! ggdd
    " Vim is designed so that searching in Vimscript does not replace the last search. This is a workaround for that. It still does not highlight the last search term unless the user
    " had already searched on something
    let no_magic_string = L_s(a:search).get_no_magic().str
    let @/ = no_magic_string
    normal! n
    call matchadd("Search", a:search)
    nnoremap <buffer> q :bdelete<CR>
    nnoremap <CR> :Top<CR>:q<CR>^<C-W>F
    call search(no_magic_string, 'c')
    call l#log('project_search#find_in_all_file_types end')
endfunction

call l#log('project-search autoload end')

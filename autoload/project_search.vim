call l#log('project-search autoload start')

function! project_search#find_word_under_cursor_in_current_file_types() abort
    call project_search#find_in_current_file_types(L_current_cursor().word(), 0)
endfunction

function! project_search#find_in_current_file_types(search, case_sensitive) abort
    call l#log('project_search#find_in_current_file_types start')
    call project_search#find(a:search, a:case_sensitive, 1)
    call l#log('project_search#find_in_current_file_types end')
endfunction

function! project_search#find_in_all_file_types(search, case_sensitive) abort
    call l#log('project_search#find_in_all_file_types start')
    call project_search#find(a:search, a:case_sensitive, 0)
    call l#log('project_search#find_in_all_file_types end')
endfunction

function! project_search#find(search, case_sensitive, only_current_file_types) abort
    call l#log('project_search#find start')
    try
        let current_file_extension = '' . L_current_buffer().file().extension
        " create a scratch buffer below the current window
        below new
        setlocal buftype=acwrite
        setlocal noswapfile
        setlocal bufhidden=wipe
        let buffer_name = fnameescape(localtime() . ' - project_search_results: ' . a:search)
        execute 'file ' . buffer_name
        augroup VimProjectSearchResults
            autocmd! * <buffer>
            autocmd BufWriteCmd <buffer> call project_search#save_result_edits_to_files()
        augroup END
        let escaped_search = shellescape(a:search)
        let command = 'grep -Frn'
        if !a:case_sensitive
            let command .= 'i'
        endif
        if a:only_current_file_types
            let include_param = shellescape('*.' . current_file_extension)
            let command = command . ' --include=' . include_param
        endif
        if len(g:project_search_exclude_dir_paths) > 0
            for path in g:project_search_exclude_dir_paths
                let exclude_param = shellescape(path)
                let command = command . ' --exclude-dir=' . exclude_param
            endfor
        endif
        " the -- in the following shell code signifies to grep that the options
        " have now ended and only positional parameters follow. This allows the
        " character "-" to be searched on.
        let command = command . ' -- ' . escaped_search . ' .'
        let out = L_shell().run(command)
        call L_current_buffer().append_line(split(out, '\n'))
        normal! ggdd
        set nomodified
        " Vim is designed so that searching in Vimscript does not replace the last search. This is a workaround for that.
        " It still does not highlight the last search term unless the user had already searched on something
        let no_magic_string = L_s(a:search).get_no_magic().str
        let @/ = no_magic_string
        call l#log('project_search#find in search result buffer no magic search string: '.no_magic_string)
        try
            normal! n
            call matchadd('Search', a:search)
        catch \^Vim(normal):E486:.*\
        endtry

        " This mapping changes the meaning of the enter key in normal mode to do
        " the following while you are in a search result buffer. Move the cursor
        " to the top window, close that window bringing the cursor back to the
        " search results window, go to the beginning of the line, split the window
        " and go to the file and line number under the cursor:
        let b:project_search_current_search = a:search
        nnoremap <buffer><CR> :call project_search#try_go_to_result_under_cursor()<CR>

        " Bring the cursor to the matching search in the results buffer. The 'c' makes
        " it accept a match at the cursor position which allows this to work
        " correctly when the match is at the beginning of the line:
        call search(no_magic_string, 'c')
    catch
        " wrap the exception because Vim does not allow throwing exception prepended with Vim
        let wrapped_exception = 'project_search#find() unhandled exception: ' . v:exception
        call l#log(wrapped_exception)
        throw wrapped_exception
    endtry
    call l#log('project_search#find end')
endfunction

function! project_search#try_go_to_result_under_cursor() abort
    try
        let current_search = b:project_search_current_search
        let current_line_s = L_s(getline('.'))
        try
            let search_result = project_search_result#new(current_line_s)
        catch /project_search_result#new#precondition_failed:.*/
            call l#log('not a valid search result to go to. Handled exception message: ' . v:exception)
            return
        endtry

        let result_window_id = win_getid()
        " go up one window (if one exists above):
        execute "normal! \<C-w>k"
        let possibly_above_window_id = win_getid()
        let possibly_above_buffer_number = bufnr('%')
        let possibly_above_buffer_info = L_null()
        for buffer in getbufinfo()
            if buffer.bufnr == possibly_above_buffer_number
                let possibly_above_buffer_info = buffer
            endif
        endfor
        if possibly_above_buffer_info == L_null()
            throw 'project_search#logic_exception: expected to set possibly_above_buffer_info to buffer info dictionary'
        endif
        let open_result_in_above_window = 0
        if possibly_above_window_id != result_window_id
            let above_buffer_name_s = L_s(possibly_above_buffer_info.name)
            if !above_buffer_name_s.contains(' - project_search_results: ')
                let open_result_in_above_window = 1
            endif
        endif
        if open_result_in_above_window
            execute 'e ' . fnameescape(search_result.file.path)
        else
            call win_gotoid(result_window_id)
            execute 'aboveleft split ' . fnameescape(search_result.file.path)
        endif
        execute '' . search_result.line_number
        call project_search#go_to_first_match_on_current_line(current_search)
    catch
        " wrap the exception because Vim does not allow throwing exception prepended with Vim
        let wrapped_exception = 'project_search#try_go_to_result_under_cursor() unhandled exception: ' . v:exception
        call l#log(wrapped_exception)
        throw wrapped_exception
    endtry
endfunction

function! project_search#go_to_first_match_on_current_line(search_string) abort
    normal! 0
    let current_line_s = L_s(getline('.'))
    let number_characters_to_the_right = current_line_s.index_of(a:search_string)
    while number_characters_to_the_right > 0
        normal! l
        let number_characters_to_the_right -= 1
    endwhile
endfunction

function! project_search#save_result_edits_to_files() abort
    let line_number = 1
    let last_line_number = line('$')
    let buffer_numbers_to_reload = []
    while line_number <= last_line_number
        let buffer_numbers_to_reload =
            \ extend(buffer_numbers_to_reload, project_search#try_save_result_line(line_number))
        let line_number = line_number + 1
    endwhile
    set nomodified
    if len(buffer_numbers_to_reload) < 1
        return
    endif
    call sort(buffer_numbers_to_reload, 'n')
    call uniq(buffer_numbers_to_reload)
    let current_buffer_number = bufnr('%')
    setlocal bufhidden=
    for buffer_number in buffer_numbers_to_reload
        try
            execute buffer_number . 'bufdo e'
        catch \^E37:.*\
        endtry
    endfor
    execute 'buffer ' . current_buffer_number
    setlocal bufhidden=wipe
endfunction

function! project_search#try_save_result_line(line_number) abort
    let buffer_numbers_to_reload = []
    let line_s = L_s(getline(a:line_number))
    try
        let search_result = project_search_result#new(line_s)
    catch /project_search_result#new#precondition_failed:.*/
        call l#log('project-search Could not save search result. Result line could not be converted into a result '
            \ . 'object. Result line number: ' . a:line_number . '. Result line: ' . line_s.str . '. exception: '
            \ . v:exception)
        return buffer_numbers_to_reload
    endtry
    try
        let line_got_replaced = search_result.file.replace_line(search_result.line_number, search_result.line_s)
    catch /L_file#replace_line#precondition_failed:.*/
        call l#log('project-search Could not save search result. Result object was not in a valid state for saving. '
            \ . 'Result line number: ' . a:line_number . '. Result line: ' . line_s.str . '. exception: ' . v:exception)
        return buffer_numbers_to_reload
    endtry
    if !line_got_replaced
        return buffer_numbers_to_reload
    endif
    " refresh buffer contents for any buffer that might be associated with the file we just wrote to:
    for buffer in getbufinfo({'buflisted' : 1, 'bufloaded' : 1})
        if buffer.changed
            " if the buffer has been modified, refreshing the contents would lose the unsaved changes, so will just let
            " the user deal with this on their own
            continue
        endif
        if type(buffer.name) != v:t_string
            " was expecting name to the be the name of the file associated with the buffer
            continue
        endif
        if buffer.name ==# ''
            " was expecting name to the be the name of the file associated with the buffer
            continue
        endif
        let buffer_file = L_file(buffer.name)
        if buffer_file.name ==# search_result.file.name
            let buffer_numbers_to_reload = add(buffer_numbers_to_reload, buffer.bufnr)
        endif
    endfor
    return buffer_numbers_to_reload
endfunction

call l#log('project-search autoload end')

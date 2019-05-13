function! project_search_result#new(line_s) abort
    if a:line_s.str ==# ''
        throw 'project_search_result#new#precondition_failed: empty string'
    endif
    let path_end_index = a:line_s.index_of(':')
    if path_end_index < 0
        throw 'project_search_result#new#precondition_failed: : not found'
    end
    if path_end_index == 0
        throw 'project_search_result#new#precondition_failed: file path missing before :'
    end
    if a:line_s.len == path_end_index + 1
        throw 'project_search_result#new#precondition_failed: line number missing after :'
    end
    let result = {}
    let result.file = L_file(a:line_s.str[0 : path_end_index - 1])
    if !result.file.readable()
        throw 'project_search_result#new#precondition_failed: file path does not map to an existing/readable file: '
            \ . result.file.path
    endif
    let all_text_after_colon = a:line_s.str[path_end_index + 1 : ]
    let result.line_number = str2nr(all_text_after_colon)
    if result.line_number <= 0
        throw 'project_search_result#new#precondition_failed: text immediately following : is either not a number or is'
            \ . ' not greater than 0: ' . all_text_after_colon
    endif
    let line_number_s = L_s('' . result.line_number)
    let result.line_s = L_s(a:line_s.str[path_end_index + line_number_s.len + 2 : ])
    call l#log('project-search valid search result object created. result.file.path: "' . result.file.path
        \ . '" result.line_number: ' . result.line_number . ' result.line_s.str: ' . result.line_s.str)
    return result
endfunction

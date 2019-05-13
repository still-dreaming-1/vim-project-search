UTSuite project_search_result

function! s:setup_script_vars()
    " let s:static_data_dir = L_dir(g:project_search_dir_path.'/static test data')
endfunction

function! s:Setup()
    call s:setup_script_vars()
endfunction

function! s:Teardown()
endfunction

function! s:Test_try_new()
    let exception = ''
    try
        call project_search_result#new(L_s(''))
    catch /project_search_result#new#precondition_failed:.*/
        let exception = v:exception
    endtry
    AssertDiffers(exception, '')

    let exception = ''
    try
        call project_search_result#new(L_s('./tests/result_test.vim'))
    catch /project_search_result#new#precondition_failed:.*/
        let exception = v:exception
    endtry
    AssertDiffers(exception, '')

    let exception = ''
    try
        call project_search_result#new(L_s('./tests/result_test.vim:'))
    catch /project_search_result#new#precondition_failed:.*/
        let exception = v:exception
    endtry
    AssertDiffers(exception, '')

    let exception = ''
    try
        call project_search_result#new(L_s('./tests/result_test.vim:-1'))
    catch /project_search_result#new#precondition_failed:.*/
        let exception = v:exception
    endtry
    AssertDiffers(exception, '')

    let exception = ''
    try
        call project_search_result#new(L_s('./tests/result_test.vim:0'))
    catch /project_search_result#new#precondition_failed:.*/
        let exception = v:exception
    endtry
    AssertDiffers(exception, '')

    let exception = ''
    try
        call project_search_result#new(L_s('./tests/there_is_no_file_with_this_name.vim:1'))
    catch /project_search_result#new#precondition_failed:.*/
        let exception = v:exception
    endtry
    AssertDiffers(exception, '')

    let result = project_search_result#new(L_s('./tests/result_test.vim:1'))
    AssertEquals(result.file.path, './tests/result_test.vim')
    AssertEquals(result.line_number, 1)
    AssertEquals(result.line_s.str, '')

    let result = project_search_result#new(L_s('./tests/result_test.vim:17'))
    AssertEquals(result.file.path, './tests/result_test.vim')
    AssertEquals(result.line_number, 17)
    AssertEquals(result.line_s.str, '')

    let result = project_search_result#new(L_s('./tests/result_test.vim:17:get to work'))
    AssertEquals(result.file.path, './tests/result_test.vim')
    AssertEquals(result.line_number, 17)
    AssertEquals(result.line_s.str, 'get to work')

    let result = project_search_result#new(L_s('./tests/result_test.vim:17: put your face away'))
    AssertEquals(result.file.path, './tests/result_test.vim')
    AssertEquals(result.line_number, 17)
    AssertEquals(result.line_s.str, ' put your face away')
endfunction

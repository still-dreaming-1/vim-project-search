UTSuite when searching for a word in all txt files and only that file exists


function! s:setup_script_vars()
	let s:static_data_dir= L_dir(g:project_search_dir_path.'/static test data')
		let s:static_text_file= s:static_data_dir.get_contained_file('file with one word.txt')
	let s:data_dir= L_dir(g:project_search_dir_path.'/generated test data')
		let s:text_file= s:data_dir.get_contained_file('file with one word.txt')
endfunction

function! s:Setup()
	let s:stopwatch= L_stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert! !s:data_dir.exists()
	call s:data_dir.create()
	Assert! s:data_dir.exists()
	Assert! s:static_data_dir.exists()
	Assert! s:static_text_file.readable()
	call s:static_text_file.copy_to(s:text_file.path)
	Assert! s:text_file.readable()
	call s:text_file.edit()
endfunction

function! s:Teardown()
	call s:setup_script_vars()
	Assert s:data_dir.exists()
	call s:data_dir.delete()
	Assert !s:data_dir.exists()
	let elapsed_milliseconds= s:stopwatch.stop()
	Assert elapsed_milliseconds < 1000
endfunction

function! s:safe_teardown()
	call s:setup_script_vars()
	if s:data_dir.exists()
		call s:data_dir.delete()
	endif
endfunction

function! s:Test_something()
endfunction

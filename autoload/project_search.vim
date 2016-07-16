call l#log('project-search autoload start')

function! project_search#find_word_under_cursor_in_current_file_types()
	call project_search#find_in_current_file_types(L_current_cursor().word())
endfunction

function! project_search#find_in_current_file_types(search)
	call l#log('project_search#find_in_current_file_types start')
	let current_file_extension= L_current_buffer().file().extension
	" create a scratch buffer below the current window
	below new
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	let escaped_search= escape(a:search, '\')
	let out= L_shell().run('grep -Frin --include="*.'.current_file_extension.'" "'.escaped_search.'" .')
	call L_current_buffer().append_line(split(out, '\n'))
	normal! ggdd
	" Vim is designed so that searching in Vimscript does not replace the last search. This is a workaround for that. It still does not highlight the last search term unless the user
	" had already searched on something
	" try to find this backslash \
	let @/ = a:search
	" let @/ = L_s(a:search).get_no_magic().str
	normal! n
	call matchadd("Search", a:search)
	nnoremap <buffer> q :bdelete<CR>
	nnoremap <CR> :Top<CR>:q<CR>^<C-W>Fn
	call l#log('project_search#find_in_current_file_types end')
endfunction

call l#log('project-search autoload end')

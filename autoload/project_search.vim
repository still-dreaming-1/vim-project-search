function! project_search#find_word_under_cursor_in_current_file_types()
	" execute 'Fc '.Current_cursor().word()
	call project_search#find_in_current_file_types(Current_cursor().word())
endfunction

function! project_search#find_in_current_file_types(search)
	let current_file_extension= Current_buffer().file().extension
	" create a scratch buffer below the current window
	below new
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	let cmd= 'read !grep -Frin --include="*.'.current_file_extension.'" "'.a:search.'" .'
	silent exec cmd
	normal! ggdd
	" Vim is designed so that searching in Vimscript does not replace the last search. This is a workaround for that. It still does not highlight the last search term unless the user
	" had already searched on something
	let @/ = a:search
	normal! n
	nnoremap <buffer> q :bdelete<CR>
	nnoremap <CR> :Top<CR>:q<CR>^<C-W>Fn
endfunction

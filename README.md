# vim-project-search
Optimized search workflow

An extremely optimized search workflow that allows you to do things the Vim way. Search results appear in a new buffer in a new window that you can navigate around in the Vim way. There are little workflow tweaks that make working with the search results very efficient.

**Features**

All the features have the following things in common. Searches are for file contents, not file names. None of them use regular expressions, just a raw text search. I think regular expressions should be specifically invoked and separate from non regular expression searches. All searches are recursive in the current working directory. All search results appear in a new window under the previous one. You can see the entire line along with the file the result was found in. Within the search results, the searched on text will be highligted. Press `n` to jump to the next instance of the search text within the buffer. This is actully just doing a normal Vim search, which is why `n` takes you to the next result. When you found the result you want, press enter. You will be taken to the correct file and line number. Also, the search text will be searched for and jumped to so you will also be taken to the correct character in the line you want and what you were searching on may be highlighted depending on your search highlight settings. Once you no longer need to see the search results there is a super fast/easy way to close that buffer, which will probably also close that window for you. Just press q from inside the results. Unfortunately this means you cannot use q to record macros from inside the search results. The search results are inside a normal Vim buffer. This means you can now do a different Vim search within the search results, by pressing `/`. The buffer is editable. This is great when you may want to keep the results up for a while and want to narrow them down to just the ones you are interested in. You can do that by deleting lines in the results that are not of interest to you. Lets say there is an entire directory showing up you don't care about. You can search for that directory name, go into line visual mode, go to the bottom of the file `G`, do a backward search for the same term with `N`, then delete all those results with `d`.

`:Fc` command (find current) followed by what you want to search for. Searches for stuff in all files in the current working directory matching the current file types.

`:Fa` command (find all) followed by what you want to search for. Searches for stuff in the all files in the current working directory regardless of file type.

`<leader>*` in normal mode. This is similar to the Vim feature where you press `*` in normal mode to search for the word under the cursor except this also searches other files in your current working directory that match the current file type.

**Installation**

You will have to install my [vim-elhiv](https://github.com/still-dreaming-1/vim-elhiv) plugin library first before this will work. Then just install this plugin the normal way you install Vim plugins. I recommend using a plugin manager.

**Options**

The <leader>* mapping exposing the find word under cursor feature can be mapped to any key(s) you want if you don't like that default. Just put something like this in your Vim/Neovim config file:

`nmap * <Plug>(project_search-find_word_undor_cursor)`

If you did that, `*` would activate that feature instead of `<leader>*`. Of course then you would lose what `*` normally does. If you keep the default, you should set your leader key to something, if you haven't already. I like setting it space like so:

`let mapleader=" "`

If you set your leader that way, and keep the default mapping, you would activate that feature with space *

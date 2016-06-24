# vim-project-search
Optimized search workflow

This grew out of my config file. I had some cool search features, but one day I found a bug in one of them that I wanted to write a test for. At that point it was easier and cleaner to turn it into a plugin than keep it in my config. I like to share my plugins.

As per what is normal for me, the main idea behind this is to create an extremely optimized workflow that allows you to do things the Vim way. So search results appear in a new buffer in a new window that you can navigate around in around in the Vim way. But there are little workflow tweaks that make working with the search results very efficient.

**Features**

Currently there are 2 features. One is an `:Fc` command followed by what you want to search for and the other requires you press `<leader>*` in normal mode. Neither of them use regular expressions, just a raw text search. I think regular expressions should be specifically invoked and separate from non regular expression searches. Both search features recursively search for the the text in all the files of the same file type in the current working directory. The <leader>* feature is similar to the Vim feature where you press `*` in normal mode to search for the word under the cursor except this also searches other files in your project. The search results appear in a new window under the previous one. You can see the entire line along with the file the result was found in. Within the search results, the searched on text will be highligted. Press n to jump to the next instance of the search text within the buffer. This is actully just doing a normal Vim search, which is why n takes you to the next result. When you found the result you want, press enter. You will be taken to the correct file and line number. Also, the search text will be searched for and jumped to so you will also be taken to the correct part of the line you want and what you were searching on may be highlighted depending on your search highlight settings. Once you no longer need to see the search results there is a super fast/esy way to close that buffer, which will probably also close that windo for you. Just press q from inside the results. Unfortunately this means you cannot use q to record macros from insdie the search results.

You will have to install my vim-elhiv plugin library first before this will work. Then just install this the normal way you install Vim plugins.

**Options**

The <leader>* mapping exposing the find word under cursor feature can be mapped to any key(s) you want if you don't like that default. Just put something like this in your Vim/Neovim config file:

`nmap * <Plug>(project_search-find_word_undor_cursor)`

If you did that, `*` would activate that feature instead of `<leader>*`. Of course then you would lose what * normally does. If you keep the default, you should set your leader key to something, if you haven't already. I like setting it space like so:

`let mapleader=" "`

**Bugs**

Highlighting inside the search results only works if you have previously searched for something with the forward slash.

Once you press enter to navigate to the found result, you will be taken to the wrong line if what you are searching for is at the beginning of the line and it appears for than once in the file. If you suspect this has happened, press N to go back to the correct result inside that file.

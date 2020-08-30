# vim-project-search
Optimized search and edit workflow

An extremely optimized search and edit workflow that allows you to do things the Vim way. Search results appear in a new buffer in a new window that you can navigate around in the Vim way. If you edit the results buffer and save, corresponding changes are saved to the files. There are little workflow tweaks that make working with the search results very efficient, such as pressing enter to go to that line in that file.

**Features**

All the features have the following things in common. Searches are for file contents, not file names. None of them use regular expressions, just a raw text search. I think regular expressions should be specifically invoked and separate from non regular expression searches. All searches are recursive in the current working directory. All search results appear in a new window under the previous one. You can see the entire line along with the file the result was found in. Within the search results, the searched on text will be highligted. Press `n` to jump to the next instance of the search text within the buffer. This is actully just doing a normal Vim search, which is why `n` takes you to the next result. When you found the result you want, press enter. You will be taken to the correct file and line number. Also, the search text will be searched for and jumped to so you will also be taken to the correct character in the line you want and what you were searching on may be highlighted depending on your search highlight settings. The search results are inside a normal Vim buffer. This means you can now do a different Vim search within the search results, by pressing `/`. The buffer is editable. This is great when you may want to keep the results up for a while and want to narrow them down to just the ones you are interested in. You can do that by deleting lines in the results that are not of interest to you. Lets say there is an entire directory showing up you don't care about. You can search for that directory name, go into line visual mode, go to the bottom of the file `G`, do a backward search for the same term with `N`, then delete all those results with `d`. You can even edit the results in the buffer and do a write, and the results will be saved to the corresponding files! If you edit the file names themselves, the new names will be searched for, and if they exist, and it contains at least as many lines as the line number in the edited result, that is the file that will be saved to. Any time a matching filename cannot be found, that result is skipped, but the rest of the results are still processed. If you have one of those edited files already open in a buffer, the buffer will load the latest file contents (if the buffer was has no unsaved changes). If the buffer did have unsaved changes, nothing is done for you in that buffer, it is up to you to decide what to do, but the saved search result edit has been saved to the file system already.

Result buffers get completely wiped after they are no longer visible. So this means, among other things, that if you use `:q` to close the results window, you won't be able to bring it up again. The purpose behind this is to prevent more and more result buffers from staying around as you keep performing additional searches, which is both annoying and dangerous, as they quickly become out of date as you continue to make code changes. As it is now, you are still warned if you try to close the results while there are unsaved changes. Why are these buffers not simply deleted instead of wiped? I tried that, but I could not find any use for it that did not just make things more annoying. For example, if you create a mark in a result buffer, and then delete it without wiping it, you can go back to that mark, but the buffer is just empty. If you wipe it and then try to go to that mark, you get an error message that the buffer does not exist. I am open to deleting instead of wiping if someone presents a case for it.

`:Fc` command (find current) followed by what you want to search for. Searches for stuff in all files in the current working directory matching the current file types.
`:Fsc` command (find case-sensitive current) followed by what you want to search for. Case sensitive version of the Fc command (described on line above).

`:Fa` command (find all) followed by what you want to search for. Searches for stuff in the all files in the current working directory regardless of file type.
`:Fsa` command (find case-sensitive all) followed by what you want to search for. Case sensitive version of the Fa command (described on line above)

`<leader>*` in normal mode. This is similar to the Vim feature where you press `*` in normal mode to search for the word under the cursor except this also searches other files in your current working directory that match the current file type.

**Installation**

You will have to install my [vim-elhiv](https://github.com/still-dreaming-1/vim-elhiv) plugin library first before this will work. The instructions to install that have an extra atypical step, so please read the install instructions for that plugin library. Then just install this plugin the normal way you install Vim plugins. I recommend using a plugin manager such as [vim-plug](https://github.com/junegunn/vim-plug).

**Options**

The <leader>* mapping exposing the find word under cursor feature can be mapped to any key(s) you want if you don't like that default. Just put something like this in your Vim/Neovim config file:

`nmap * <Plug>(project_search-find_word_undor_cursor)`

If you did that, `*` would activate that feature instead of `<leader>*`. Of course then you would lose what `*` normally does. If you keep the default, you should set your leader key to something, if you haven't already. I like setting it space like so:

`let mapleader=" "`

If you set your leader that way, and keep the default mapping, you would activate that feature with space *

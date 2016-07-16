Gizmo385's Dotfiles
=======
These are all of the various configuration files that I use on my various machines. I have worked to
try and make them as portable as possible based on the machines that I have access to.

### Installation

To quickly install these run the following command:

```bash
curl https://raw.githubusercontent.com/gizmo385/dotfiles/master/update_dotfiles | sh
```

After you have the files installed, you can run the `update_dotfiles` alias to redownload and
install the dotfiles.


### Forking the Project
If you wish to fork these dotfiles for yourself, there are a few areas you might wish to change:

* In the `.bash_aliases` file, change variables for the `update_dotfiles` alias

* In the `update_dotfiles` script, change the variable to point the script towards your fork and
  branch

* Update the name in `.gitconfig`

### Known Bugs in Dotfiles

* The Spotify plugin will occassionally fail to load and raise an error.

* On some systems, loading Vim hangs. Cause currently unknown

### Current Vim Plugins
Here is an overview of the various plugins I have installed for Vim:

#### Colorschemes
* [Mustang](https://github.com/croaker/mustang-vim)
* [Solarized](http://ethanschoonover.com/solarized)
* [Xoria256](https://github.com/vim-scripts/xoria256.vim)

#### Quality of life plugins
* [Rainbow Parentheses](https://github.com/kien/rainbow_parentheses.vim) (colors nested parentheses)

* [Taglist](http://vim-taglist.sourceforge.net/) (tags source code elements)

* [NERDTree](https://github.com/scrooloose/nerdtree) (File Browser)

* [NERDComment](https://github.com/scrooloose/nerdcommenter) (Automatically comment in/out lines)

* [Multiple Cursors](https://github.com/terryma/vim-multiple-cursors) (Makes refactoring a breeze)

* [Ctrl-P](https://github.com/kien/ctrlp.vim) (Fuzzy File Finder)

* [Neocompl](https://github.com/Shougo/neocomplcache.vim) (Automatic Completion)

* [Vim-Airline](https://github.com/vim-airline/vim-airline) (Better powerline for Vim)

* [vim-livedown](https://github.com/shime/vim-livedown) (Livedown auto-preview support for Vim)

* [Fugitive](https://github.com/tpope/vim-fugitive) (Git management)

* [Scratch](https://github.com/mtth/scratch.vim) (easy-to-use scratch pad)

* [Spotify.vim](https://github.com/gizmo385/spotify.vim) (control Spotify client from Vim)

#### Python Plugins
* [vim-python-pep8-indent](https://github.com/hynek/vim-python-pep8-indent) (Better indent support for python)

#### Clojure Plugins

* [vim-typedclojure](https://github.com/typedclojure/vim-typedclojure) (Typed Clojure Support)

* [vim-fireplace](https://github.com/tpope/vim-fireplace) (Clojure REPL support)

* [vim-leiningen](https://github.com/tpope/vim-salve) (Vim Leiningen hooks)

* [paredit.vim](https://github.com/vim-scripts/paredit.vim) (Tools to quickly edit S-Expressions)

* [vim-clojure-static](https://github.com/guns/vim-clojure-static) (Better syntax files for Clojure)

* [vim-clojure-highlight](https://github.com/guns/vim-clojure-highlight) (Better syntax highlighting for Clojure)

source $HOME/.vim_settings.vim
source $HOME/.vim_plugins.vim
source $HOME/.vim_plugin_settings.vim
source $HOME/.vim_bindings.vim

" If we're running in neovim, we'll want to additionally pull in some more plugins and settings
if has('nvim')
    source $HOME/.nvim_plugins.vim
    source $HOME/.nvim_settings.vim
endif

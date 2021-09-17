if status is-interactive
    # Fisher plugin manager
    if test -f $HOME/.fisher
        source $HOME/.fisher
    end

    source $HOME/.bash_aliases
end

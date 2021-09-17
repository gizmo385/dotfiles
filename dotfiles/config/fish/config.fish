if status is-interactive
    # Fisher plugin manager
    if test -f $HOME/.fisher
        source $HOME/.fisher
    end

    source $HOME/.bash_aliases

    # Faster git prompt, only show the branch
    function fish_git_prompt
        set_color yellow; printf '[%s] ' (git branch --show-current); set_color normal;
    end
end

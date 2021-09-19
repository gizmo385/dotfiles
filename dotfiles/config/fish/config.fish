if status is-interactive
    # Fisher plugin manager
    if test -f $HOME/.fisher
        source $HOME/.fisher
    end

    source $HOME/.bash_aliases

    if type -q bat
        alias cat bat
    end

    if type -q nvim
        alias vim nvim
    end

    # Faster git prompt, only show the branch
    function fish_git_prompt
        if git branch --show-current > /dev/null 2>&1;
            set_color yellow; printf '[%s] ' (git branch --show-current); set_color normal;
        end
    end
end

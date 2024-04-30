if status is-interactive
    # Fisher plugin manager
    if test -f $HOME/.fisher
        source $HOME/.fisher
    end

    source $HOME/shell_aliases

    if type -q bat
        alias cat bat
    end

    export EDITOR=vim
    if type -q nvim
        alias vim nvim
        export EDITOR=nvim
    end

    # Faster git prompt, only show the branch
    function fish_git_prompt
        if git branch --show-current > /dev/null 2>&1;
            set_color yellow; printf '[%s] ' (git branch --show-current); set_color normal;
        end
    end

    # opam configuration
    source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true


    set -U fish_user_paths "$HOME/.cargo/bin" $fish_user_paths
end

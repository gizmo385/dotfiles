if status is-interactive
    # Fisher plugin manager
    if test -f $HOME/.fisher
        source $HOME/.fisher
    end

    source $HOME/.bash_aliases

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

    # If we're running on an SSH host, let's automatically connect to a tmux session that can
    # maintain our status between disconnects
    if test -z "$TMUX" -a -n "$SSH_CONNECTION"
        tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
    end
end

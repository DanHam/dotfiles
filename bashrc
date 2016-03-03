# Mac bashrc file

# Main Bash Options
#
# Don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
# Set ammount of commands to store in history
export HISTSIZE=20000
# Check window size after each command and update LINES and COLUMNS value
shopt -s checkwinsize

# Prompt
if [ "$TERM" != "dumb" ]; then
    if [ -e ~/.git-prompt.sh ]; then
        . ~/.git-prompt.sh
        PS1='\[\033[01;30m\]\u@\h\[\033[01;34m\] \w \[\033[01;33m\]$(__git_ps1 "\n(%s) ")\[\033[01;34m\]\$\[\033[00m\] '
    else
        PS1='\[\033[01;30m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
    fi
fi

# Colourisation of terminal output
if [ "$TERM" != "dumb" ]; then
    export LS_OPTIONS='--color=auto'
    eval $(dircolors -b $HOME/.dircolors)
fi

# Import Aliases
if [ -f ~/.bashrc_aliases ]; then
    . ~/.bashrc_aliases
fi

# Bash Completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

# Git Bash Completion
if [ -f ~/.git-completion.sh ]; then
    . ~/.git-completion.sh
fi

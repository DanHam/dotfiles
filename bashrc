# Mac bashrc file

# History control
#
# Don't put duplicate lines or lines starting with a space in the history
# Note that erasedups does not work as well as we would hope and some
# duplicates may appear in the history
export HISTCONTROL=ignoreboth:erasedups
# Ignore the following patterns when appending to the history file
# export HISTIGNORE="ls:ll:la:cd**:history**:top:exit:tree**:c:clear"
# Set ammount of commands to store in history
export HISTSIZE=20000
# Synchronise history across multiple sessions;
# history -a appends the current command to the history file. history -c
# then clears the history after which history -r reads and updates the
# current state of the history thereby reading in any changes from other
# sessions. PROMPT_COMMAND is run prior to the issue of the primary prompt.
export PROMPT_COMMAND="history -a;history -c;history -r"
# Avoid overwriting history
shopt -s histappend
# Try to save each line of a multi-line command in the same history entry
shopt -s cmdhist

# Check window size after each command and update LINES and COLUMNS value
shopt -s checkwinsize

# Prompt
if [ "$TERM" != "dumb" ]; then
    # Set location of the git prompt shell script
    GIT_PROMPT_SH="/opt/local/share/git/contrib/completion/git-prompt.sh"
    if [ -e $GIT_PROMPT_SH ]; then
        . $GIT_PROMPT_SH
        PS1='\[\033[01;30m\]\u@\h\[\033[01;34m\] \w \[\033[01;38;5;66m\]$(__git_ps1 "\n[%s] ")\[\033[01;34m\]\$\[\033[0m\] '
    else
        PS1='\[\033[01;30m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
    fi
fi
unset GIT_PROMPT_SH

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

# Git Bash Completion: Set location of the completions file and source
GIT_COMPLETIONS="/opt/local/share/git/contrib/completion/git-completion.bash"
if [ -f $GIT_COMPLETIONS ]; then
    . $GIT_COMPLETIONS
fi
unset GIT_COMPLETIONS

# Travis CI Bash Completion (added by travis gem)
[ -f /Users/dan/.travis/travis.sh ] && source /Users/dan/.travis/travis.sh

# Vagrant Completions
BASE_DIR="/opt/vagrant/embedded/gems/gems"
# Get the latest version of vagrant we have installed on the system
# We could use 'vagrant --version' here but it's very slow. This is ugly
# but much quicker
if [ -d ${BASE_DIR} ]; then
    LATEST="$(ls ${BASE_DIR} | \
              grep -P ^vagrant-[0-9]\.[0-9]\.[0-9] | \
              sort -gr |
              tr -s '\n' ' ' | \
              cut -d' ' -f1)"
fi
VAGRANT_COMPLETIONS="${BASE_DIR}/${LATEST}/contrib/bash/completion.sh"
if [ -f ${VAGRANT_COMPLETIONS} ]; then
  . ${VAGRANT_COMPLETIONS}
fi
unset BASE_DIR LATEST VAGRANT_COMPLETIONS

# Colourisation of man pages
if [ "$TERM" != "dumb" ]; then
    export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
    export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
    export LESS_TERMCAP_me=$'\e[0m'           # end mode
    export LESS_TERMCAP_so=$'\e[01;38;5;154m' # begin standout-mode - info box
    export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
    export LESS_TERMCAP_us=$'\e[04;38;5;72m'  # begin underline
    export LESS_TERMCAP_ue=$'\e[0m'           # end underline
fi

# Use enhancements built around less; See lesspipe(1)
export LESSOPEN='| /opt/local/bin/lesspipe.sh %s'

# Use ssh-agent for per-session caching of ssh keys
#
# Start ssh agent and store required environment variables
if ! $(pgrep -u $USER ssh-agent > /dev/null); then
    ssh-agent > $HOME/.ssh-agent-info 2>&1>/dev/null
fi
# Set required environment variables from stored info
if [[ "$SSH_AGENT_PID" == '' ]]; then
    # Read in from file grepping out the annoying echo command and
    # evaluate to set the environment variables
    eval $(grep -v echo <$HOME/.ssh-agent-info)
fi
# Wrap an alias around ssh to add the key to the agent on first run of ssh
ssh-add -l >/dev/null || \
    alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

# Set default provider for Vagrant
if [ -d "/Applications/VMware Fusion.app/" ]; then
    export VAGRANT_DEFAULT_PROVIDER='vmware_fusion'
fi

# Set up rbenv
if [ -e "/opt/local/bin/rbenv" ]; then
    eval "$(rbenv init -)"
fi

# Mac bashrc file

# Don't process this file if this is not an interactive session
[[ -z "${PS1}" ]] && return 0

# History control
#
# Don't put duplicate lines or lines starting with a space in the history
# Note that erasedups does not work as well as we would hope and some
# duplicates may appear in the history
export HISTCONTROL=ignoreboth:erasedups
# Ignore the following patterns when appending to the history file
# export HISTIGNORE="ls:ll:la:cd**:history**:top:exit:tree**:c:clear"
# Set ammount of commands to store in history
export HISTSIZE=1000000
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
        PS1='\[\033[01;30m\]\u\[\033[01;30m\]@\h\[\033[01;34m\] \w \[\033[01;38;5;66m\]$(__git_ps1 "\n[%s] ")\[\033[01;34m\]\$\[\033[0m\] '
    else
        PS1='\[\033[01;30m\]\u\[\033[01;30m\]@\h\[\033[01;34m\] \w \$\[\033[00m\] '
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

# Vagrant Completions
BASE_DIR="/opt/vagrant/embedded/gems"
if [ -d ${BASE_DIR} ]; then
    LATEST="$(vagrant --version | cut -d' ' -f2)"
fi
VAGRANT_COMPLETIONS="${BASE_DIR}/${LATEST}/gems/vagrant-${LATEST}/contrib/bash/completion.sh"
if [ -f ${VAGRANT_COMPLETIONS} ]; then
  . ${VAGRANT_COMPLETIONS}
fi
unset BASE_DIR LATEST VAGRANT_COMPLETIONS

# Docker Completions
DOCKER_RESOURCES="/Applications/Docker.app/Contents/Resources/etc"
DOCKER_COMPLETIONS="${DOCKER_RESOURCES}/docker.bash-completion"
DOCKER_MACHINE_COMPLETIONS="${DOCKER_RESOURCES}/docker-machine.bash-completion"
DOCKER_COMPOSE_COMPLETIONS="${DOCKER_RESOURCES}/docker-compose.bash-completion"
if [ -f ${DOCKER_COMPLETIONS} ]; then
    source ${DOCKER_COMPLETIONS}
fi
if [ -f ${DOCKER_MACHINE_COMPLETIONS} ]; then
    source ${DOCKER_MACHINE_COMPLETIONS}
fi
if [ -f ${DOCKER_COMPOSE_COMPLETIONS} ]; then
    source ${DOCKER_COMPOSE_COMPLETIONS}
fi
unset DOCKER_RESOURCES DOCKER_COMPLETIONS DOCKER_COMPLETIONS DOCKER_MACHINE_COMPLETIONS

# Google gcloud completions
if [ -f '/Users/dan/.google-cloud-sdk/completion.bash.inc' ]; then
    source '/Users/dan/.google-cloud-sdk/completion.bash.inc'
fi

# tmux completions
# https://github.com/Bash-it/bash-it/blob/master/completion/available/tmux.completion.bash
TMUX_COMPLETIONS='/Users/dan/.bash_completion.d/tmux/tmux_completion.bash'
if [ -f ${TMUX_COMPLETIONS} ]; then
    source ${TMUX_COMPLETIONS}
fi
unset TMUX_COMPLETIONS

# Ansible completions
# https://github.com/dysosmus/ansible-completion.git
ANSIBLE_COMPLETIONS_DIR='/Users/dan/.bash_completion.d/ansible-completion.d'
if [ -d ${ANSIBLE_COMPLETIONS_DIR} ]; then
    # find and xargs don't work with bash builtins so just store and
    # iterate over with a simple do loop
    ANSIBLE_COMPLETIONS="$(find ${ANSIBLE_COMPLETIONS_DIR} -type f -name \
        "*.bash" | tr '\n' ' ')"
    if [ "x${ANSIBLE_COMPLETIONS}" != "x" ]; then
        for i in ${ANSIBLE_COMPLETIONS}
        do
            source $i
        done
    fi
fi
unset ANSIBLE_COMPLETIONS_DIR ANSIBLE_COMPLETIONS

# Terraform completions
if [ -f '/Users/dan/.bin/terraform' ]; then
    complete -C /Users/dan/.bin/terraform terraform
fi

# Test-Kitchen
# https://github.com/MarkBorcherding/test-kitchen-bash-completion
TEST_KITCHEN_COMPLETIONS='/Users/dan/.bash_completion.d/test-kitchen/kitchen-completion.bash'
if [ -f ${TEST_KITCHEN_COMPLETIONS} ]; then
    source ${TEST_KITCHEN_COMPLETIONS}
fi
unset TEST_KITCHEN_COMPLETIONS

# Go command completions
# https://github.com/thomasf/go-bash-completion.git
GO_COMPLETIONS='/Users/dan/.bash_completion.d/go/go-bash-completion.bash'
if [ -f ${GO_COMPLETIONS} ]; then
    source ${GO_COMPLETIONS}
fi
unset GO_COMPLETIONS

# Packer command completions
# https://github.com/mrolli/packer-bash-completion.git
PACKER_COMPLETIONS='/Users/dan/.bash_completion.d/packer/packer-completion.bash'
if [ -f ${PACKER_COMPLETIONS} ]; then
    source ${PACKER_COMPLETIONS}
fi
unset PACKER_COMPLETIONS

# kubectl command completions
if [ "x$(command -v kubectl)" != "x" ]; then
    source <(kubectl completion bash)
fi

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

# Use ssh-agent if for per-session caching of ssh keys
if ! pgrep -u $USER ssh-agent > /dev/null; then
    # Start the agent, simultaneously setting required env vars from the
    # start up output of the ssh-agent command. grep out the annoying echo
    # of the ssh-agent pid
    eval "$(ssh-agent -s | grep -v echo)"
fi

# Set the preferred provider for Vagrant
if [ -d "/Applications/VMware Fusion.app/" ]; then
    export VAGRANT_PREFERRED_PROVIDERS='virtualbox'
fi

# Set up rbenv
if [ -e "$HOME/.rbenv/bin/rbenv" ]; then
    eval "$($HOME/.rbenv/bin/rbenv init -)"
fi

# Functions

# Setup SAWS virtual environment
sawsup () {
    if [ -e ~/.venv-saws/bin/activate ] && \
       [ -e ~/.venv-saws/bin/saws ]; then
        echo "Setting up environment for Super AWS CLI..."
        source ~/.venv-saws/bin/activate
        echo "You can now run 'saws'; Use CTRL-D to exit."
        echo "Run 'deactivate' to close down the environment when done"
        saws
    else
        echo "Virtual env for SAWS not found or SAWS missing: ~/.venv-saws"
    fi
}

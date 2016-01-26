# Add Path to MacPorts 
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# MacPorts GNU Core Utilities
export PATH=/opt/local/libexec/gnubin:$PATH

# MacPorts ManPath
export MANPATH=/opt/local/share/man:$MANPATH

# Local scripts and programs
export PATH=$PATH:~/.bin

# Bash rc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

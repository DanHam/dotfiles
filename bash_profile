# Add Path to MacPorts
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# MacPorts GNU Core Utilities
export PATH=/opt/local/libexec/gnubin:$PATH

# MacPorts ManPath
export MANPATH=/opt/local/share/man:$MANPATH

# Local scripts and programs
export PATH=$PATH:~/.bin

# VMware Fusion binaries
if [ -d "/Applications/VMware Fusion.app/Contents/Library/" ]; then
    export PATH=$PATH:"/Applications/VMware Fusion.app/Contents/Library"
fi

# Python 2.7 PIP packages
PIPBIN27="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin"
if [ -d $PIPBIN27 ]; then
    export PATH=$PATH:$PIPBIN27
fi


# Bash rc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

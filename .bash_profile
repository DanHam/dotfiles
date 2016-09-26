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

# Ruby Environments: rbenv
if [ -e "/opt/local/bin/rbenv" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    if [ -e "/opt/local/bin/ruby-build" ]; then
        export RUBY_CONFIGURE_OPTS=--with-openssl-dir=/opt/local
    fi
fi

# Bash rc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

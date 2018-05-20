# Add Path to MacPorts
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# MacPorts GNU Core Utilities
export PATH=/opt/local/libexec/gnubin:$PATH

# MacPorts ManPath
if [ "x${MANPATH}" = "x" ]; then
    export MANPATH=/opt/local/share/man
else
    export MANPATH=/opt/local/share/man:$MANPATH
fi

# Local scripts and programs
export PATH=$PATH:~/.bin

# VMware Fusion and OVF Tool binaries
FUSIONBINPATH="/Applications/VMware Fusion.app/Contents/Library"
OVFTOOLPATH="${FUSIONBINPATH}/VMware OVF Tool"
if [ -d "${FUSIONBINPATH}" ]; then
    export PATH=$PATH:"${FUSIONBINPATH}"
fi
if [ -d "${OVFTOOLPATH}" ]; then
    export PATH=$PATH:"${OVFTOOLPATH}"
fi
unset FUSIONBINPATH OVFTOOLPATH

# Ruby Environments: rbenv and ruby-build
if [ -e "$HOME/.rbenv/bin/rbenv" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    if [ -e "$HOME/.rbenv/plugins/ruby-build/bin/ruby-build" ]; then
        export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
        export RUBY_CONFIGURE_OPTS=--with-openssl-dir=/opt/local
    fi
fi

# Man pages for Chef and associated utilities
# Set the main directory into which Ruby versions are installed
BASEDIR="/opt/chefdk/embedded/lib/ruby/gems"
# Get the latest version of the embedded Ruby
if [ -d "${BASEDIR}" ]; then
    RUBYLATEST="$(ls ${BASEDIR} | \
        grep -Ex '([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2})' | \
        sort -Vr | \
        tr -s '\n' ' ' | \
        cut -d' ' -f1)"
fi
# Set the directory into which the Chef utils will have been installed
GEMSDIR="${BASEDIR}/${RUBYLATEST}/gems"
# Create an array containing all the utils for which we want to enumerate
# the path to their man page directories.
UTILS=("chef" "foodcritic" "ohai")
# Search for man directories for each package or utility and add each one
# found to the manpath.
if [ -d ${GEMSDIR} ]; then
    for UTIL in ${UTILS[@]}
    do
        UTILDIR="$(ls ${GEMSDIR} | \
            grep -Ex ^${UTIL}-'([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2})' | \
            sort -Vr | \
            tr -s '\n' ' ' | \
            cut -d' ' -f1)"
        MANDIR="$(find ${GEMSDIR}/${UTILDIR} -type d -iname man)"
        if [ "x${MANDIR}" != "x" ]; then
            if [ "x${MANLIST}" = "x" ]; then
                MANLIST="${MANDIR}"
            else
                MANLIST="${MANDIR}:${MANLIST}"
            fi
        fi
    done
    if [ "x${MANLIST}" != "x" ]; then
        if [ "x${MANPATH}" = "x" ]; then
            export MANPATH="${MANLIST}"
        else
            export MANPATH="${MANLIST}:${MANPATH}"
        fi
    fi
fi
unset BASEDIR RUBYLATEST GEMSDIR UTILS UTIL UTILDIR MANDIR MANLIST

# Bash rc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Set GoPath and add Go bin directory to path
export GOPATH=$HOME/working/go
export PATH=$PATH:$GOPATH/bin

# Update PATH for the Google Cloud SDK.
if [ -f '/Users/dan/.google-cloud-sdk/path.bash.inc' ]; then
    source '/Users/dan/.google-cloud-sdk/path.bash.inc';
fi

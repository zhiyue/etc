##############
# The basics #
##############
[ -z "$PS1" ] && return

# explicitly enable term colors.
export TERM="xterm-256color"

if [ "x$OSTYPE" = "xlinux" ]
then
    export MAN_POSIXLY_CORRECT=1

    # running on a linux virtual machine.
    COLORS=dircolors
    SED=sed
    ADD_KEY="no"
    HAS_ITERM="no"
    COMPLETION_PATH=/etc/profile.d/bash_completion.sh
    YELLOW=$(tput setaf 136)
    ORANGE=$(tput setaf 166)
    RED=$(tput setaf 160)
    MAGENTA=$(tput setaf 125)
    VIOLET=$(tput setaf 61)
    BLUE=$(tput setaf 33)
    CYAN=$(tput setaf 37)
    GREEN=$(tput setaf 64)
    RESET=$(tput sgr0)
else
    # running on a macOS machine.
    COLORS=gdircolors
    SED=gsed
    ADD_KEY="yes"
    HAS_ITERM="yes"
    COMPLETION_PATH=/usr/local/etc/bash_completion
    YELLOW=$(tput setaf 136)
    ORANGE=$(tput setaf 166)
    RED=$(tput setaf 160)
    MAGENTA=$(tput setaf 125)
    VIOLET=$(tput setaf 61)
    BLUE=$(tput setaf 33)
    CYAN=$(tput setaf 37)
    GREEN=$(tput setaf 64)
    RESET=$(tput sgr0)
fi
    
xiaketDIR=~/.xiaket
bashrcdir=$xiaketDIR"/etc"

export PATH="~/.xiaket/etc/bin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/opt/coreutils/bin:/usr/local/share/npm/bin:~/.xiaket/go/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

############
# sourcing #
#############

# For things that can be used as alias
. $bashrcdir/alias

# For things that can only be done as a bash function.
. $bashrcdir/bash_functions

# For Pronto settings
. $bashrcdir/pronto

# For bash completion.
. $COMPLETION_PATH

# If we are logging through tty, set locale to en_US.UTF-8
TTY=`tty | grep tty -c`
if [ $TTY == 1 ] || [ "x$OSTYPE" = "xlinux" ]
then
    export LANG=en_US.UTF-8
else
    export LANG=zh_CN.UTF-8
fi

 

# use ascii colors to show whether we are root.
if [ $UID -eq 0 ]
then
    export PS1="[\[${RED}\]\u@\[$CYAN\]\h \[$BLUE\]\w\[$RESET\]]" 
else
    export PS1="[\[${ORANGE}\]\u\[$CYAN\]@\h \[$BLUE\]\w\[$RESET\]]" 
fi


################
# bash history #
################

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# unlimited playback.
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
# append to the history file, don't overwrite it
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n"

#########################
# environment variables #
#########################

# Setup Python PATH, so our python libraries would be portable.
export PYTHONPATH="$PYTHONPATH:/Users/xiaket/.xiaket/python/lib"
export PYTHONSTARTUP=~/.pythonrc
export PYTHONDONTWRITEBYTECODE="False"
export GOPATH="/Users/xiaket/.xiaket/go"
export SVN_EDITOR=nvim
export GIT_EDITOR=nvim
export VISUAL=nvim
export EDITOR=nvim

#################
# accessibility #
#################

export LS_OPTIONS='--color=auto'
eval `"$COLORS" "$HOME/.xiaket/etc/dir_colors"`

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#####################
# ssh agent forward #
#####################
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    content=`/usr/bin/ssh-agent | sed "/^echo/d"`
    [ -f $SSH_ENV ] && return 0 || echo $content > $SSH_ENV
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
    /usr/bin/ssh-add ~/.ssh/id_ed25519.git
    /usr/bin/ssh-add ~/.ssh/id_ed25519.vps
}

if [ "x$ADD_KEY" = "xyes" ]
then
    # Source SSH settings, if applicable
    lockfile -1 /tmp/ssh.lock
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps auwxx | grep ${SSH_AGENT_PID} | grep -q ssh-agent$
        if [ $? -ne 0 ]
        then
            rm -f ${SSH_ENV}
            start_agent
        fi
    else
        start_agent;
    fi
    rm -f /tmp/ssh.lock
fi

if [ "x$HAS_ITERM" = "xyes" ]
then
    # For iTerm 3 shell integration.
    . ~/.iterm2_shell_integration.bash
fi

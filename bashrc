# ~/.bashrc
# Snippets of bashrc.
# Modify according to taste!

# Bail unless an interactive shell!
[ -z "$PS1" ] && return

###############################################################################
# Command aliases
###############################################################################

# List files in color.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)"
    [ $? ] || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# List file aliases that group directories first.
alias l='ls --group'
alias ll='ls --group -lh'

# Disable annoying interactive mode for common file commands.
unalias cp 2> /dev/null
unalias mv 2> /dev/null
unalias rm 2> /dev/null

# Grep in color.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# List processes with extended info.
# - process hierarchy, priority, scheduling, memory, running time
alias pl='ps -o pid,ppid,pgid,lwp,nlwp,psr,cls,pri,state,vsz,rss,bsdstart,bsdtime,user,cmd'

# Open file in already started Emacs running in server mode (M-x server-start).
# Useful to hide Emacs startup cost when editing config files from the shell.
alias edit='emacsclient -n'

###############################################################################
# Python
###############################################################################

export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

###############################################################################
# Git version control
###############################################################################

# Setup git autocompletion and PS1 integration
for v in ~/.local/etc/git-completion.bash ~/.local/etc/git-prompt.sh; do
    [ -r "$v" ] && . "$v"
done
unset v

# GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\W\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

# Regular bash prompt if the above is slow
#PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\W\[\033[31m\]\[\033[00m\]\$ '

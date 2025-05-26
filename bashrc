# ~/.bashrc
# Snippets of bashrc

###############################################################################
# Git version control
###############################################################################

# Set git autocompletion and PS1 integration
for a in ~/.local/etc/git-completion.bash ~/.local/etc/git-prompt.sh; do
    [ -r "$a" ] && . "$a"
done

# GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\W\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

# Regular bash prompt if the above is slow
#PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\W\[\033[31m\]\[\033[00m\]\$ '

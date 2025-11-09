# ~/.profile or ~/.bash_profile
# This file serves as a shell login profile example.
# It contains paths specific to my local environment!

# Only supports bash!
[ -z "$BASH_VERSION" ] && return

# Include .bashrc if it exists
[ -f ~/.bashrc ] && . ~/.bashrc

# Set preferred editor invoked by some command line tools.
export EDITOR="emacs -nw"

# Set the COLORTERM variable to "truecolor" if the terminal supports it.
# Workaround for SSH to remote system from Tmux session.
if [ "$TERM" = tmux-256color ]; then
   export COLORTERM=truecolor
fi

###############################################################################
# ENVIRONMENT PATH VARIABLES MANIPULATION BELOW
###############################################################################

# my_dirs_fetch splits a comma separated path string into an array. Path
# components are de-duplicated using an auxiliary associative array.
#
# Example: my_dirs_fetch path "$PATH"
#
# The result is stored into the variables "my_path_arr" and
# "my_path_set". The names are constructed from the first argument.
# These variables must have been declared prior to calling the function.

my_dirs_fetch() {
    local split path
    declare -n dst_arr1="my_${1}_arr"
    declare -n dst_set1="my_${1}_set"
    IFS=: read -ra split <<<"$2"
    unset IFS
    for path in "${split[@]}"; do
	path=$(realpath -q -s -e "$path") || continue
	[[ -v dst_set1["$path"] ]] && continue
        dst_set1["$path"]=1
	dst_arr1+=("$path")
    done
}

# my_dirs_prepend prepends directories to the locally maintained
# directory array.
#
# Example: path /usr/local/bin ~/.local/bin
#
# Prepend directories "/usr/local/bin" and "~/.local/bin" to the array
# "my_path_arr" if they exist and have not already been added to the
# array as indicated by the associative array "my_path_set".
#
# Both "my_path_arr" and "my_path_set" must have been declared prior to
# calling the function.

my_dirs_prepend() {
    local path
    declare -n dst_arr2="my_${1}_arr"
    declare -n dst_set2="my_${1}_set"
    shift
    for path in "$@"; do
	path=$(realpath -q -s -e "$path") || return
	[[ -v dst_set2["$path"] ]] && return
	dst_set2["$path"]=1
	dst_arr2=("$path" "${dst_arr2[@]}")
    done
}

my_path_arr=()
declare -A my_path_set
my_dirs_fetch   path "$PATH"
my_dirs_prepend path "$HOME/config/bin"
my_dirs_prepend path "$HOME/.local/bin"

# Zig programming language.
# - https://ziglang.org/
my_dirs_prepend path /opt/zig-x86_64-linux-0.15.1

# SML (SML/NJ) programming language.
# - https://www.smlnj.org/
my_dirs_prepend path /opt/smlnj/bin

# Go programming language.
# - https://go.dev
export GOPATH="$HOME/.local"
export GOROOT="/opt/go"
my_dirs_prepend path "$GOROOT/bin"

# OCaml programming language.
# - https://ocaml.org/
if [ -f "$HOME/.opam/opam-init/init.sh" ]; then
    . "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true
fi

my_manpath_arr=()
declare -A my_manpath_set
my_dirs_fetch   manpath "$MANPATH"
my_dirs_prepend manpath "$HOME/.local/share/man"

my_pkgconfigpath_arr=()
declare -A my_pkgconfigpath_set
my_dirs_fetch   pkgconfigpath "$PKG_CONFIG_PATH"
my_dirs_prepend pkgconfigpath "$HOME/.local/lib/pkgconfig"

# Export path environment variables as prepared by this script.
IFS=:
export PATH="${my_path_arr[*]}"
export MANPATH="${my_manpath_arr[*]}"
export PKG_CONFIG_PATH="${my_pkgconfigpath_arr[*]}"
unset IFS

# Cleanup helper functions and variables so they don't pollute the started shell.
for v in my_dirs_fetch my_dirs_prepend; do
    unset -f $v
done
for v in path manpath pkgconfigpath; do
    unset my_${v}_arr
    unset my_${v}_set
done
unset v

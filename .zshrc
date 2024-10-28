## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
chpwd() {
  ls --color=auto --group-directories-first
}

export D=/run/media/satori/ExtraLinux450
export PR="$D/Programming"

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
export SAM_CLI_TELEMETRY=0
export TERMINAL="kitty"
export VIDEO_PLAYER="totem"

vim() {
  local dir="${PWD}"
  while [[ "${dir}" != "/" ]]; do
    if [[ -e "${dir}/.no_plugin" ]]; then
      echo "Starting Vim without plugins..."
      command vim -u NONE -U NONE "$@"
      return
    fi
    dir=$(dirname "${dir}")
  done
  command vim "$@"
}

export VISUAL="vim"
export EDITOR="/usr/bin/vim"
export FILE_MANAGER="nautilus"                                  # Note: Other file managers might not use the --new-window parameter
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

if WINE="$(which wine)"; then
  export WINE
fi

if WINETRICKS="$(which winetricks)"; then
  export WINETRICKS
fi


## Keybindings section
bindkey -e
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                     # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

function dup() {
  # Create another instance of the terminal in the same working directory

  # Check if TERMINAL is "cool-retro-term", if so, use the --workdir="$PWD" parameter
  if [[ "$TERMINAL" == "cool-retro-term" ]]; then
    $TERMINAL --workdir . &!
  # If it's alacritty, use --working-directory="$PWD"
  elif [[ "$TERMINAL" == "alacritty" ]]; then
    $TERMINAL --working-directory . &!
  # Anything else, open the terminal normally
  elif [[ "$TERMINAL" == "kitty" ]]; then
    $TERMINAL --directory . &!
  else
    echo "Terminal not recognized, opening without working directory, set it up in .zshrc"
    $TERMINAL -d . &!
  fi
}

## Alias section 
alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias q='exit'
alias vid="$VIDEO_PLAYER --no-video"
alias pc='$FILE_MANAGER --new-window "$PWD" &!'
alias tmpi='sudo mount -o remount,size=12G /tmp/'
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
# alias copy='xclip -selection CLIPBOARD -r'

function ssh() {
  # Workaround for remote computers not coming with the terminfo file for alacritty
  TERM="xterm-256color" /usr/bin/ssh "$@"
}

function ssh2() {
  # A better solution would be to copy the terminal settings to the remote computer
  # Get the user and host from the first argument
  user=$(echo "$1" | cut -d "@" -f 1)
  host=$(echo "$1" | cut -d "@" -f 2)
  # Remove the first argument from the list of arguments
  shift
  infocmp | /usr/bin/ssh $user@$host 'tic -x -'

  # Connect to the remote computer
  /usr/bin/ssh $user@$host "$@"

  # Function usage: ssh user@host
}

function copy() {
  # Function for copying to the clipboard

  # Check if the first argument is a file
  if [[ -f "$1" ]]; then
    # Copy the file to the clipboard
    xclip -selection CLIPBOARD -i "$1"
  else
    # Copy the output of the previous command to the clipboard
    cat - | xclip -selection CLIPBOARD -r
  fi
}


search-package () {
  paru --color=always -Ss $1 | less
}

uwu() {
  if [[ "$1" == "-Ss" ]]; then
    if [ $# -lt 2 ]; then
        echo "Expected a search prompt" >&2
        return 1
    fi
    echo "Searching for $2..."
    command paru --color=always "$@" | less
  else
    command paru --color=always "$@"
  fi
}

upgrade() {
    setopt err_exit
    setopt pipe_fail

    # Check argument count
    if [[ $# -gt 1 ]]; then
        echo "Error: Too many arguments. Usage: upgrade [full]" >&2
        return 1
    fi

    # Validate argument if present
    if [[ $# -eq 1 && "$1" != "full" ]]; then
        echo "Error: Invalid argument. Usage: upgrade [full]" >&2
        return 1
    fi

    # If full update requested, run pacman-mirrors
    if [[ $# -eq 1 && "$1" == "full" ]]; then
        echo "Updating mirrors..."
        sudo pacman-mirrors --fasttrack || { echo "Mirror update failed" >&2; return 1; }
    fi

    echo "Upgrading Flatpak..."
    flatpak update || { echo "Flatpak update failed" >&2; return 1; }

    echo "Updating packages..."
    paru -Syyu || { echo "Package update failed" >&2; return 1; }

    # read doesn't work well with set -e, so temporarily disable it
    setopt no_err_exit
    read "answer?Would you like to remove previous packages? (Y/n) "
    setopt err_exit

    if [[ "$answer" =~ ^[Yy]$ || -z "$answer" ]]; then
        echo "Removing previous packages..."
        sudo paccache -r || { echo "Package cleanup failed" >&2; return 1; }
    else
        echo "Packages were not removed."
    fi

    setopt no_err_exit
}

yutubi () {
    local url="$1"
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local output_dir=~/Videos/Youtube
    local output_file="${output_dir}/${timestamp}.%(ext)s"

    mkdir -p "$output_dir"
    yt-dlp -o "$output_file" "$url"

    if [[ $? -eq 0 ]]; then
        local video_file=$(ls "${output_dir}/${timestamp}."*)
        echo "Command to open the video:"
        echo "$VIDEO_PLAYER \"$video_file\""
    else
        echo "Failed to download the video."
    fi 
}

# Theming section  
autoload -U compinit colors zcalc
compinit -d
colors

# enable substitution for prompt
setopt prompt_subst

# Prompt (on left side) similar to default bash prompt, or redhat zsh prompt with colors
 #PROMPT="%(!.%{$fg[red]%}[%n@%m %1~]%{$reset_color%}# .%{$fg[green]%}[%n@%m %1~]%{$reset_color%}$ "
# Maia prompt
PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b " # Print some system information when the shell is first started
# Print a greeting message when shell is started
echo $USER@$HOST  $(uname -srm) $(lsb_release -rcs)
## Prompt on right side:
#  - shows status of git when in git repository (code adapted from https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html)
#  - shows exit status of previous command (if previous command finished with an error)
#  - is invisible, if neither is the case

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

parse_git_branch() {
  # Show Git branch/tag, or name-rev if on detached head
  ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
  # Show different symbols as appropriate for various Git repository states
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"
  
  # If inside a Git repository, print its branch and state
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
  
  # If not inside the Git repo, print exit codes of last command (only if it failed)
  [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}

# Right prompt with exit status of previous command if not successful
 #RPROMPT="%{$fg[red]%} %(?..[%?])" 
# Right prompt with exit status of previous command marked with ✓ or ✗
 #RPROMPT="%(?.%{$fg[green]%}✓ %{$reset_color%}.%{$fg[red]%}✗ %{$reset_color%})"


# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r


## Plugins section: Enable fish style features
# Use syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up			
bindkey '^[[B' history-substring-search-down

# Apply different settigns for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in
  login)
    	RPROMPT="%{$fg[red]%} %(?..[%?])" 
    	alias x='startx ~/.xinitrc'      # Type name of desired desktop after x, xinitrc is configured for it
    ;;
#  'tmux: server')
#        RPROMPT='$(git_prompt_string)'
#		## Base16 Shell color themes.
#		#possible themes: 3024, apathy, ashes, atelierdune, atelierforest, atelierhearth,
#		#atelierseaside, bespin, brewer, chalk, codeschool, colors, default, eighties, 
#		#embers, flat, google, grayscale, greenscreen, harmonic16, isotope, londontube,
#		#marrakesh, mocha, monokai, ocean, paraiso, pop (dark only), railscasts, shapesifter,
#		#solarized, summerfruit, tomorrow, twilight
#		#theme="eighties"
#		#Possible variants: dark and light
#		#shade="dark"
#		#BASE16_SHELL="/usr/share/zsh/scripts/base16-shell/base16-$theme.$shade.sh"
#		#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
#		# Use autosuggestion
#		source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#		ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
#  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
#     ;;
  *)
        RPROMPT='$(git_prompt_string)'
		# Use autosuggestion
		source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
		ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
    ;;
esac
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# For cool-terminal-emulator's bug with backspaces:
# Check if backspace is already sending ^?
if ! stty -a | grep -E -q '\berase = \^\?'; then
    # If not, bind ^H to the backspace function
    bindkey '^H' backward-delete-char
fi

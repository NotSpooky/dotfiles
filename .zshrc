# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/histfile
HISTSIZE=2000
SAVEHIST=2000
unsetopt beep nomatch
setopt AUTO_CD MENU_COMPLETE HIST_FIND_NO_DUPS 
# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# bindkey -v # vi mode
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/satori/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias yolo=sudo
alias dog=cat
alias vim=nvim
alias dup='lilyterm &'
alias vid='mpv --no-video'
alias q=exit
alias -g G='|grep'
alias -g L='|less'
alias pc='pcmanfm &!'
alias temp=sensors
setopt NO_HUP

# Make cd show all the files.
function chpwd () {
	emulate -L zsh
	ls -a
}

setopt menu_complete # Automatically prompts when using tab.
autoload -Uz promptinit
promptinit
prompt walters

# History searching.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey "^[[1;5D" backward-word
bindkey "^[[1;6D" forward-word
export VISUAL="nvim"

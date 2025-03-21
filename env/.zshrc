ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

autoload -U compinit && compinit

# Enable vi mode
bindkey -v
export KEYTIMEOUT=28
bindkey -M viins 'jk' vi-cmd-mode
bindkey "^?" backward-delete-char

bindkey -M viins '^F' autosuggest-accept
bindkey -M vicmd '^F' autosuggest-accept

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.

preexec() {
  echo -ne '\e[5 q'; # Use beam shape cursor for each new prompt.
}

export MANPAGER="nvim -c 'Man!' -c 'set number relativenumber' -"

export EDITOR=nvim

export GALLIUM_DRIVER=d3d12

export PATH="$PATH:/usr/bin"
export PATH="$PATH:$HOME/fzf/bin"
export PATH="$PATH:$HOME/.local/scripts"
export PATH="$PATH:/home/jonas/.local/bin"
export TERM=tmux-256color
export OPENAI_API_KEY="<PASTE_API_KEY_HERE>"
export XDG_CONFIG_HOME=$HOME/.config
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins"

export ANDROID_HOME=$HOME/android/
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export ANDROID_AVD_HOME=$HOME/.config/.android/avd/
export PATH=$HOME/flutter/bin:$PATH

export ROS_DOMAIN_ID=1

zinit cdreplay -q

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/themes/bubblesextra.omp.json)"

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#make tmux XDG compliant
alias tmux='tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf'

alias ls='ls --color'
alias la='ls -a --color'
alias ll='ls -la --color'
alias vi='nvim'

#obsidian alias
alias of='create_obsidian_note.sh fact_note'
alias oc='create_obsidian_note.sh code_note'
alias oq='create_obsidian_note.sh quote_note'
alias ob='create_obsidian_note.sh blank_note'
alias ot='create_obsidian_note.sh tool_note'
alias og='create_obsidian_note.sh guide_note'

eval "$(zoxide init zsh --cmd k)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'

export FZF_DEFAULT_OPTS="--bind 'alt-j:down' --bind 'alt-k:up'"

bindkey -s ^g "tmux-sessionizer\n"
bindkey '^[k' history-search-backward
bindkey '^[j' history-search-forward

# I want to use $@ for all arguments but they don't contain space for me
function flutter-watch(){
  tmux send-keys "flutter run $1 $2 $3 $4 --pid-file=/tmp/tf1.pid" Enter \;\
  split-window -v \;\
  send-keys 'npx -y nodemon -e dart -x "cat /tmp/tf1.pid | xargs kill -s USR1"' Enter \;\
  resize-pane -y 5 -t 1 \;\
  select-pane -t 0 \;
}

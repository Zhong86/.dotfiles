# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

#Download Zinit if not yet (pkg manager)
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

#Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

autoload -U compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#History
HISTSIZE=1000
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

#completion styling
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

#aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cmatrix='cmatrix -ab -C red'
alias fastfetch="/home/Zhong/.config/fastfetch/autoPoke.sh; fastfetch"
alias nvimo='nvim $(fzf --preview="cat {}")'
alias fzf='fzf --preview="cat {}"'
alias du='du -h --max-depth=1 2>/dev/null | sort -h'
alias clear='clear; fastfetch'
alias vpn='protonvpn signin billy3rlvin@gmail.com; protonvpn connect'
#Command Scripts
commandDir='/home/Zhong/Documents/Commands/'
alias encrypt="python $commandDir/encryptor.py"
alias db="bash $commandDir/db.sh"
alias chwall="bash $commandDir/chwall.sh"
alias dcUpdate="bash $commandDir/discord_update.sh"

#shell integration
eval "$(fzf --zsh)"

#Keybinds
bindkey '\t' autosuggest-accept
bindkey '^[[Z' fzf-completion

#ENV
set -a
[ -f ~/.env ] && source ~/.env
set +a


# ~/.bashrc - optimized shell configuration
# Applies to bash 4.0+, works across WSL, Linux, and macOS

# Only load interactive shell features if running interactively
case $- in *i*) ;; *) return ;; esac

# ==============================================================================
# Locale & Environment
# ==============================================================================
export LANG=C.UTF-8
unset LC_ALL
export TERM=xterm-256color
export GPG_TTY=$(tty)

# ==============================================================================
# History (single authoritative config)
# ==============================================================================
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T  "
shopt -s histappend
PROMPT_COMMAND='history -a; history -c; history -r; '"$PROMPT_COMMAND"

# ==============================================================================
# Shell Options
# ==============================================================================
shopt -s checkwinsize autocd cdspell extglob
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'TAB:menu-complete'
bind '"\e[Z": menu-complete-backward'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ==============================================================================
# Less Pager
# ==============================================================================
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export LESS='-R'

# ==============================================================================
# Colors & ls
# ==============================================================================
if command -v dircolors >/dev/null 2>&1; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ==============================================================================
# Aliases (core utilities)
# ==============================================================================
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ..='cd ..'
alias ...='cd ../..'
alias please='sudo $(fc -ln -1)'
alias path='echo $PATH | tr ":" "\n"'         # readable PATH
alias ports='ss -tulnp'                        # what's listening on which port
alias myip='curl -s https://ifconfig.me'       # your public IP
alias reload='source ~/.bashrc && echo "✓ bashrc reloaded"'
alias bashrc='${EDITOR:-nano} ~/.bashrc'       # quick edit this file
alias starshiprc='${EDITOR:-nano} ~/.config/starship.toml'

# ==============================================================================
# Aliases (git)
# ==============================================================================
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull --rebase --autostash'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gsw='git switch'

# ==============================================================================
# Safer delete: moves to ~/.trash instead of permanent delete
# Usage: trash file.txt   |   trash-restore   |   trash-empty
# ==============================================================================
TRASH_DIR="$HOME/.trash"
mkdir -p "$TRASH_DIR"

trash() {
  if [ $# -eq 0 ]; then
    echo "Usage: trash <file|dir> [file2 ...]"
    echo "Moves files to ~/.trash instead of deleting permanently."
    return 1
  fi
  for item in "$@"; do
    if [ ! -e "$item" ]; then
      echo "trash: '$item' not found"
      continue
    fi
    local dest="$TRASH_DIR/$(basename "$item")_$(date +%s)"
    mv "$item" "$dest"
    echo "🗑️  Trashed: $item → $dest"
  done
}

trash-restore() {
  echo "Contents of trash (~/.trash):"
  ls -lh "$TRASH_DIR" 2>/dev/null || echo "(empty)"
  echo ""
  echo "To restore a file: mv ~/.trash/<filename> ./"
}

trash-empty() {
  read -rp "Empty trash? This is permanent. [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] && rm -rf "$TRASH_DIR"/* && echo "🧹 Trash emptied." || echo "Cancelled."
}

# ==============================================================================
# mkcd: make a directory and cd into it in one step
# Usage: mkcd my-new-project
# ==============================================================================
mkcd() {
  if [ -z "$1" ]; then echo "Usage: mkcd <dirname>"; return 1; fi
  mkdir -p "$1" && cd "$1" && echo "📁 Created and entered: $(pwd)"
}

# ==============================================================================
# extract: universal archive extractor - one command for all archive types
# Usage: extract archive.tar.gz   |   extract file.zip
# ==============================================================================
extract() {
  if [ -z "$1" ]; then
    echo "Usage: extract <archive>"
    echo "Supports: .tar.gz .tar.bz2 .tar.xz .zip .gz .bz2 .rar .7z .tar"
    return 1
  fi
  if [ ! -f "$1" ]; then
    echo "extract: '$1' not found"
    return 1
  fi
  echo "📦 Extracting $1..."
  case "$1" in
    *.tar.gz|*.tgz)   tar xzf "$1"   ;;
    *.tar.bz2|*.tbz2) tar xjf "$1"   ;;
    *.tar.xz)         tar xJf "$1"   ;;
    *.tar)            tar xf  "$1"   ;;
    *.zip)            unzip   "$1"   ;;
    *.gz)             gunzip  "$1"   ;;
    *.bz2)            bunzip2 "$1"   ;;
    *.rar)            unrar x "$1"   ;;
    *.7z)             7z x    "$1"   ;;
    *)                echo "Unknown archive format: $1"; return 1 ;;
  esac
  echo "✓ Done"
}

# ==============================================================================
# sysinfo: quick system overview
# Usage: sysinfo
# ==============================================================================
sysinfo() {
  local _b="\033[1m" _r="\033[0m" _g="\033[0;32m" _c="\033[0;36m"
  echo ""
  echo -e "${_b}System Info${_r}"
  echo -e "${_c}OS:${_r}       $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')"
  echo -e "${_c}Kernel:${_r}   $(uname -r)"
  echo -e "${_c}Host:${_r}     $HOSTNAME"
  echo -e "${_c}Uptime:${_r}   $(uptime -p 2>/dev/null || uptime)"
  echo -e "${_c}Shell:${_r}    $BASH_VERSION"
  echo ""
  echo -e "${_b}Resources${_r}"
  echo -e "${_c}CPU:${_r}      $(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2 | xargs)"
  echo -e "${_c}Memory:${_r}   $(free -h | awk '/^Mem:/{print $3 " used / " $2 " total"}')"
  echo -e "${_c}Disk:${_r}     $(df -h ~ | awk 'NR==2{print $3 " used / " $2 " total (" $5 " full)"}')"
  echo ""
  echo -e "${_b}Network${_r}"
  echo -e "${_c}Local IP:${_r} $(hostname -I 2>/dev/null | awk '{print $1}')"
  echo ""
}

# ==============================================================================
# cheat: plain-english command examples (no man page walls of text)
# Uses cheat.sh - works anywhere with curl
# Usage: cheat grep   |   cheat tar   |   cheat git
# ==============================================================================
cheat() {
  if [ -z "$1" ]; then
    echo "Usage: cheat <command>"
    echo "Examples: cheat grep | cheat tar | cheat git | cheat curl"
    return 1
  fi
  if command -v curl >/dev/null 2>&1; then
    curl -s "https://cheat.sh/$1" | ${PAGER:-less}
  else
    echo "cheat requires curl. Install it with: sudo apt install curl"
  fi
}

# ==============================================================================
# tips: random bash tip - shown on shell open, also callable manually
# Usage: tips
# ==============================================================================
__bash_tips=(
  "Press Ctrl+R to search your command history. Start typing to find old commands."
  "Press Ctrl+L to clear the screen (same as typing 'clear')."
  "Press Ctrl+A to jump to the start of a line, Ctrl+E to jump to the end."
  "Press Ctrl+W to delete the last word you typed."
  "Press Ctrl+U to wipe the entire current line."
  "Run 'history' to see your last commands. Run '!42' to re-run command #42."
  "Use Tab to autocomplete filenames and commands. Double-Tab shows all options."
  "Use 'cd -' to jump back to the last directory you were in."
  "Add a space before a command to keep it out of your history: '  secret-command'"
  "Use 'mkdir -p a/b/c' to create nested directories in one step."
  "Use '!!' to repeat the last command. Useful with 'sudo !!' when you forget sudo."
  "Use 'less file.txt' to read a file page by page. Press Q to quit."
  "Ctrl+Z suspends a running process. Type 'fg' to bring it back, 'bg' to background it."
  "Use '> file.txt' to save command output to a file. Use '>>' to append instead."
  "Use 'which <command>' to find out where a program is installed."
  "Wildcards: '*.txt' matches all .txt files. '?' matches any single character."
  "Use 'cat file1 file2 > combined.txt' to merge files."
  "Use 'wc -l file.txt' to count the number of lines in a file."
  "Use 'grep -r searchterm .' to search all files recursively in the current directory."
  "Run 'cheat <command>' for quick real-world examples of any command."
)

tips() {
  local _b="\033[1;36m" _r="\033[0m" _y="\033[1;33m"
  local idx=$(( RANDOM % ${#__bash_tips[@]} ))
  echo -e "${_y}💡 Tip:${_r} ${__bash_tips[$idx]}"
  echo -e "   ${_b}Run 'tips' anytime for another. Run 'cheat <cmd>' for examples.${_r}"
}

# ==============================================================================
# helpme: beginner-friendly help index
# Usage: helpme   |   helpme files   |   helpme git
# ==============================================================================
helpme() {
  local _b="\033[1m" _r="\033[0m" _g="\033[1;32m" _c="\033[0;36m" _y="\033[1;33m"
  local topic="${1:-}"

  if [ -z "$topic" ]; then
    echo ""
    echo -e "${_b}${_g}  Quick Help - type 'helpme <topic>' for more${_r}"
    echo ""
    echo -e "  ${_y}helpme files${_r}     navigating and managing files"
    echo -e "  ${_y}helpme search${_r}    finding files and text"
    echo -e "  ${_y}helpme git${_r}       version control basics"
    echo -e "  ${_y}helpme network${_r}   networking commands"
    echo -e "  ${_y}helpme process${_r}   running processes and jobs"
    echo -e "  ${_y}helpme shortcuts${_r} keyboard shortcuts"
    echo ""
    echo -e "  ${_c}cheat <cmd>${_r}      real-world examples for any command"
    echo -e "  ${_c}tips${_r}             random useful tip"
    echo -e "  ${_c}sysinfo${_r}          system overview"
    echo ""
    return
  fi

  case "$topic" in
    files)
      echo -e "\n${_b}File Navigation & Management${_r}"
      echo -e "  ${_c}ls -lah${_r}               list files (long format, human sizes, hidden)"
      echo -e "  ${_c}cd <dir>${_r}               enter a directory"
      echo -e "  ${_c}cd ..${_r}                  go up one directory"
      echo -e "  ${_c}cd -${_r}                   go back to last directory"
      echo -e "  ${_c}pwd${_r}                    show where you are"
      echo -e "  ${_c}mkcd <name>${_r}            create a directory and enter it"
      echo -e "  ${_c}cp <src> <dest>${_r}        copy a file"
      echo -e "  ${_c}mv <src> <dest>${_r}        move or rename a file"
      echo -e "  ${_c}trash <file>${_r}           safely delete (recoverable)"
      echo -e "  ${_c}extract <archive>${_r}      unzip/untar anything"
      echo -e "  ${_c}cat <file>${_r}             print file contents"
      echo -e "  ${_c}less <file>${_r}            read file page by page (Q to quit)"
      echo ""
      ;;
    search)
      echo -e "\n${_b}Finding Things${_r}"
      echo -e "  ${_c}grep 'text' file${_r}           search for text in a file"
      echo -e "  ${_c}grep -r 'text' .${_r}           search recursively in current dir"
      echo -e "  ${_c}find . -name '*.txt'${_r}        find files by name"
      echo -e "  ${_c}find . -mtime -1${_r}            find files modified in last 24h"
      echo -e "  ${_c}history | grep 'git'${_r}        search your command history"
      echo -e "  ${_c}Ctrl+R${_r}                      interactive history search"
      echo ""
      ;;
    git)
      echo -e "\n${_b}Git Basics${_r}"
      echo -e "  ${_c}gs${_r}  (git status)        see what's changed"
      echo -e "  ${_c}gd${_r}  (git diff)           see exactly what changed"
      echo -e "  ${_c}ga .${_r} (git add)           stage all changes"
      echo -e "  ${_c}gc -m 'message'${_r}          commit with a message"
      echo -e "  ${_c}gp${_r}  (git push)           push to remote"
      echo -e "  ${_c}gl${_r}  (git pull)           pull latest changes"
      echo -e "  ${_c}gb${_r}  (git branch)         list branches"
      echo -e "  ${_c}gsw <branch>${_r}             switch to a branch"
      echo -e "  ${_c}cheat git${_r}                more git examples"
      echo ""
      ;;
    network)
      echo -e "\n${_b}Networking${_r}"
      echo -e "  ${_c}myip${_r}                    your public IP address"
      echo -e "  ${_c}hostname -I${_r}             your local IP address"
      echo -e "  ${_c}ports${_r}                   what's listening on which port"
      echo -e "  ${_c}ping google.com${_r}         test internet connectivity"
      echo -e "  ${_c}curl <url>${_r}              fetch a URL"
      echo -e "  ${_c}wget <url>${_r}              download a file"
      echo -e "  ${_c}ssh user@host${_r}           connect to a remote server"
      echo ""
      ;;
    process)
      echo -e "\n${_b}Processes & Jobs${_r}"
      echo -e "  ${_c}ps aux${_r}                  list all running processes"
      echo -e "  ${_c}top${_r} / ${_c}htop${_r}           live process monitor"
      echo -e "  ${_c}kill <pid>${_r}              stop a process by ID"
      echo -e "  ${_c}killall <name>${_r}          stop all processes by name"
      echo -e "  ${_c}Ctrl+C${_r}                  cancel a running command"
      echo -e "  ${_c}Ctrl+Z${_r}                  suspend a running command"
      echo -e "  ${_c}fg${_r}                      bring suspended job to foreground"
      echo -e "  ${_c}command &${_r}               run a command in the background"
      echo ""
      ;;
    shortcuts)
      echo -e "\n${_b}Keyboard Shortcuts${_r}"
      echo -e "  ${_c}Ctrl+R${_r}     search command history"
      echo -e "  ${_c}Ctrl+L${_r}     clear the screen"
      echo -e "  ${_c}Ctrl+C${_r}     cancel current command"
      echo -e "  ${_c}Ctrl+Z${_r}     suspend current command"
      echo -e "  ${_c}Ctrl+A${_r}     jump to start of line"
      echo -e "  ${_c}Ctrl+E${_r}     jump to end of line"
      echo -e "  ${_c}Ctrl+W${_r}     delete last word"
      echo -e "  ${_c}Ctrl+U${_r}     delete entire line"
      echo -e "  ${_c}Tab${_r}        autocomplete"
      echo -e "  ${_c}↑ / ↓${_r}      scroll through history"
      echo ""
      ;;
    *)
      echo "Unknown topic: $topic"
      echo "Available: files, search, git, network, process, shortcuts"
      ;;
  esac
}

# ==============================================================================
# command_not_found_handle: friendly suggestion when a command doesn't exist
# ==============================================================================
command_not_found_handle() {
  local _r="\033[0m" _y="\033[1;33m" _c="\033[0;36m"
  echo -e "${_y}Command not found:${_r} $1"

  # Suggest install if apt-cache knows about it
  if command -v apt-cache >/dev/null 2>&1; then
    local suggestion
    suggestion=$(apt-cache search "^$1$" 2>/dev/null | head -1)
    if [ -n "$suggestion" ]; then
      echo -e "${_c}Try installing it:${_r} sudo apt install $1"
    fi
  fi

  # Common typo/alias suggestions
  case "$1" in
    vim|vi)    echo -e "${_c}Tip:${_r} Try 'nano' if you don't have vim: sudo apt install vim" ;;
    python)    echo -e "${_c}Tip:${_r} Try 'python3' instead" ;;
    pip)       echo -e "${_c}Tip:${_r} Try 'pip3' instead" ;;
    cls)       echo -e "${_c}Tip:${_r} On Linux, 'clear' clears the screen (or Ctrl+L)" ;;
    dir)       echo -e "${_c}Tip:${_r} On Linux, use 'ls' to list files" ;;
    ipconfig)  echo -e "${_c}Tip:${_r} On Linux, use 'ip addr' or 'hostname -I'" ;;
    ifconfig)  echo -e "${_c}Tip:${_r} Try: sudo apt install net-tools" ;;
  esac

  echo -e "  Run ${_c}cheat <command>${_r} for examples, or ${_c}helpme${_r} for a quick reference."
  return 127
}

# ==============================================================================
# Bash Completion
# ==============================================================================
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ==============================================================================
# Starship Prompt
# ==============================================================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  PS1='\u@\h:\w\$ '
fi

# ==============================================================================
# Debian Chroot Detection
# ==============================================================================
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# ==============================================================================
# Optional: ble.sh (autosuggestions + syntax highlighting)
# ==============================================================================
if [ -f ~/.ble.sh/out/ble.sh ]; then
  source ~/.ble.sh/out/ble.sh
fi

# ==============================================================================
# Optional: FZF Integration
# ==============================================================================
if [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
fi

# ==============================================================================
# Node Version Manager (nvm)
# ==============================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

__nvm_auto_switch() {
  if [ -f ".nvmrc" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat .nvmrc)")
    local current_node_version
    current_node_version=$(nvm version)
    if [ "$nvmrc_node_version" != "$current_node_version" ]; then
      if [ "$nvmrc_node_version" = "N/A" ]; then
        echo "Node version in .nvmrc not installed. Installing..."
        nvm install
      else
        nvm use --silent
      fi
    fi
  fi
}

cd() {
  builtin cd "$@" && __nvm_auto_switch
}

__nvm_auto_switch

# ==============================================================================
# Python Version Manager (pyenv)
# ==============================================================================
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - bash)"
fi

# ==============================================================================
# Directory Environment Manager (direnv)
# ==============================================================================
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# ==============================================================================
# WSL-Specific Configuration
# ==============================================================================
is_wsl() { grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; }
if is_wsl; then
  if command -v clip.exe >/dev/null 2>&1; then
    alias clip='clip.exe'
    alias pbcopy='clip.exe'
    alias pbpaste='powershell.exe -NoLogo -NoProfile -Command Get-Clipboard'
  fi
  command -v wslview >/dev/null 2>&1 && alias open='wslview'
  export WSL_UTF8=1
fi

# ==============================================================================
# PATH Configuration
# ==============================================================================
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ]        && PATH="$HOME/bin:$PATH"
[ -d "$HOME/projects" ]   && alias proj='cd "$HOME/projects"'
export PATH

# ==============================================================================
# Corepack
# ==============================================================================
if command -v corepack >/dev/null 2>&1; then
  corepack enable >/dev/null 2>&1 || true
fi

# ==============================================================================
# Kubernetes Configuration
# ==============================================================================
export KUBECONFIG="/mnt/c/Users/GrantRigby/.kube/config"

# ==============================================================================
# Startup Message
# ==============================================================================
if [[ $- == *i* ]]; then
  printf "\033[1;32mHost:\033[0m %s | \033[1;32mUser:\033[0m %s\n" "$HOSTNAME" "$USER"
  tips
fi

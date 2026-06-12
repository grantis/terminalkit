# Neovim Setup Guide

Neovim is a modern text editor that lives in the terminal.
It's what the video uses for notes, code, and everything text-based.
This guide uses LazyVim - a pre-configured setup so you don't start from nothing.

---

## Install

```bash
# Ubuntu/Debian
sudo apt install neovim

# Arch
sudo pacman -S neovim

# Or get the latest version directly
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz
sudo mv nvim-linux64 /opt/nvim
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
```

---

## Install LazyVim (recommended for beginners)

LazyVim is a pre-configured Neovim setup. Think of it like getting VS Code
with all the good extensions already installed.

```bash
# Back up any existing config first
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# Install LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Open neovim - it will auto-install everything
nvim
```

Wait for it to finish installing plugins, then restart nvim.

---

## Essential Keybindings (learn these first)

Neovim has modes. This is the big thing to understand.

| Mode | How to enter | What it does |
|---|---|---|
| Normal | `Esc` | Navigate, run commands |
| Insert | `i` | Type text |
| Visual | `v` | Select text |
| Command | `:` | Run editor commands |

### Survival basics (Normal mode)

| Key | Action |
|---|---|
| `i` | Start typing (insert mode) |
| `Esc` | Stop typing (back to normal) |
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `h j k l` | Move left/down/up/right |
| `gg` | Jump to top of file |
| `G` | Jump to bottom |
| `u` | Undo |
| `Ctrl+R` | Redo |
| `/searchterm` | Search in file |
| `n` | Next search result |

### LazyVim specific

| Key | Action |
|---|---|
| `Space` | Open command menu (the main one) |
| `Space f f` | Find file |
| `Space f g` | Search in files |
| `Space e` | Toggle file explorer |
| `Space b d` | Close buffer (tab) |

---

## Set as default editor

Add this to your `.bashrc` (already included if you used the kit):

```bash
export EDITOR=nvim
export VISUAL=nvim
alias vim='nvim'
alias vi='nvim'
```

---

## Use for notes (Obsidian-style)

Create a notes directory:

```bash
mkdir -p ~/notes
alias note='nvim ~/notes/$(date +%Y-%m-%d).md'
alias notes='nvim ~/notes/'
```

Open today's note with just: `note`

---

## Useful plugins (already in LazyVim)

- **Telescope** - fuzzy file finder
- **Neo-tree** - file explorer sidebar
- **Treesitter** - syntax highlighting for everything
- **LSP** - language server (autocomplete, errors)
- **Which-key** - shows available keybindings as you type

---

## Cheatsheet

```bash
cheat nvim     # real-world examples
```

Or inside nvim: `:Tutor` for the built-in interactive tutorial (30 mins, worth it)

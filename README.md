# Terminal Kit - Friendly Linux From Scratch

A minimal, beginner-friendly terminal setup that works on any fresh Linux install.
Tested on Ubuntu Server, Arch, and Debian. One script, two config files, done.

---

## What You Get

- A beautiful, informative prompt (Starship)
- Friendly help system built into the shell (`helpme`, `tips`, `cheat`)
- Safer file handling (trash instead of delete)
- Git shortcuts
- Smart command-not-found handler (tells you what to install)
- A random tip every time you open a terminal

---

## Quick Install (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/terminal-kit/main/install.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/YOUR_USERNAME/terminal-kit.git
cd terminal-kit
chmod +x install.sh
./install.sh
```

---

## What Gets Installed

### Core Tools
| Tool | Why |
|---|---|
| `starship` | Fast, pretty prompt |
| `curl` | Powers the `cheat` command |
| `git` | Version control |
| `fzf` | Fuzzy search (Ctrl+R becomes amazing) |
| `tldr` | Plain-english man pages |
| `htop` | Better process monitor than top |
| `tree` | Visual directory structure |
| `unzip` / `p7zip` | Archive support for `extract` command |

### Optional Tools (prompted during install)
| Tool | Why |
|---|---|
| `neovim` | Modern text editor (replaces nano/vim) |
| `lazygit` | Terminal git UI |
| `taskwarrior` | Terminal task/todo manager |
| `nvm` | Node version manager |
| `fzf` | Fuzzy finder |

---

## Config Files

```
configs/
  .bashrc          # shell config with all helpers and aliases
  starship.toml    # prompt config (goes in ~/.config/starship.toml)
```

---

## After Install

Open a new terminal and try:

```bash
helpme            # friendly help index
helpme files      # file navigation cheatsheet
helpme git        # git basics
tips              # random bash tip
cheat tar         # real-world command examples
sysinfo           # system overview
```

---

## File Locations

| File | Where it goes |
|---|---|
| `.bashrc` | `~/.bashrc` |
| `starship.toml` | `~/.config/starship.toml` |

---

## Going Further

See `docs/` for guides on:
- `neovim.md` - setting up a full editor
- `taskwarrior.md` - terminal task management
- `i3.md` - tiling window manager (for bare installs with a display)
- `fonts.md` - installing JetBrains Mono Nerd Font
- `wsl.md` - Windows Subsystem for Linux specific setup
# terminalkit

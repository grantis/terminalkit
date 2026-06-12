# Taskwarrior - Terminal Task Management

Taskwarrior is a fast CLI to-do list. Add tasks from anywhere, tag them,
set priorities and due dates. All stored locally as plain text.

---

## Install

```bash
# Ubuntu/Debian
sudo apt install taskwarrior

# Arch
sudo pacman -S task

# macOS
brew install task
```

---

## Basic Usage

```bash
task add Buy milk
task add "Fix the login bug" project:work priority:H due:tomorrow
task add "Read that article" +reading +later
task list
task done 1
```

---

## Quick Reference

### Adding tasks

```bash
task add <description>
task add <description> project:<name>     # assign to a project
task add <description> priority:H        # H, M, or L
task add <description> due:tomorrow      # due dates in plain english
task add <description> +tag              # add a tag
```

### Viewing tasks

```bash
task list                  # all tasks
task next                  # what to do next (smart sorted)
task project:work          # filter by project
task +reading              # filter by tag
task due:today             # due today
```

### Managing tasks

```bash
task 1 done                # mark task 1 complete
task 1 delete              # delete task 1
task 1 modify priority:H   # change priority
task 1 modify due:friday   # change due date
task projects              # list all projects
task tags                  # list all tags
task summary               # project overview
```

---

## Taskwarrior TUI (taskwarrior-tui)

A visual interface on top of Taskwarrior. Much friendlier for beginners.

```bash
# Install (Arch)
sudo pacman -S taskwarrior-tui

# Install (Ubuntu/Debian - via cargo)
cargo install taskwarrior-tui

# Or download binary
curl -LO https://github.com/kdheepak/taskwarrior-tui/releases/latest/download/taskwarrior-tui-x86_64-unknown-linux-musl.tar.gz
tar -xzf taskwarrior-tui*.tar.gz
sudo mv taskwarrior-tui /usr/local/bin/

# Run it
taskwarrior-tui
# or
tt
```

### TUI keybindings

| Key | Action |
|---|---|
| `a` | Add task |
| `d` | Mark done |
| `e` | Edit task |
| `D` | Delete task |
| `j/k` | Navigate up/down |
| `q` | Quit |
| `/` | Filter/search |

---

## Useful aliases (add to .bashrc)

```bash
alias t='task'
alias tl='task list'
alias tn='task next'
alias ta='task add'
alias tt='taskwarrior-tui'
```

---

## Daily workflow tip

Combine with your daily note in neovim:

```bash
# Open daily note and task list side by side (in tmux or i3)
note        # opens today's markdown note
tt          # open taskwarrior TUI in another pane
```

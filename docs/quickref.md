# Terminal Quick Reference

Print this out or keep it open in another tab when you're starting out.

---

## Navigation

```
pwd              where am I right now?
ls               list files here
ls -lah          list files with sizes and hidden files
cd foldername    enter a folder
cd ..            go up one level
cd -             go back to last folder
cd ~             go to home directory
tree             visual folder structure (install: sudo apt install tree)
```

---

## Files

```
cat file.txt          print file contents
less file.txt         read file (scroll with arrows, Q to quit)
nano file.txt         edit a file (Ctrl+S save, Ctrl+X quit)
nvim file.txt         edit in neovim (i to type, Esc then :wq to save+quit)
cp file.txt copy.txt  copy a file
mv old.txt new.txt    rename or move a file
trash file.txt        safely delete (recoverable from ~/.trash)
mkdir foldername      create a folder
mkcd foldername       create a folder and enter it
extract file.zip      unzip/untar anything
```

---

## Finding things

```
grep "text" file.txt          search for text in a file
grep -r "text" .              search recursively in current folder
find . -name "*.txt"          find files by name
find . -mtime -1              files modified in last 24h
history                       your command history
history | grep git            search history for git commands
Ctrl+R                        live history search (type to filter)
```

---

## System

```
sysinfo          quick overview (this kit)
htop             live process monitor (Q to quit)
df -h            disk usage
free -h          memory usage
uptime           how long system has been running
whoami           your username
uname -r         kernel version
```

---

## Network

```
myip             your public IP (this kit)
hostname -I      your local IP
ping google.com  test internet connection (Ctrl+C to stop)
curl https://...  fetch a URL
wget https://...  download a file
ports            what's listening on which port (this kit)
ssh user@host    connect to another machine
```

---

## Packages (Ubuntu/Debian)

```
sudo apt update              update package list
sudo apt install <name>      install a package
sudo apt remove <name>       uninstall a package
sudo apt upgrade             upgrade all packages
apt search <name>            search for a package
dpkg -l | grep <name>        check if something is installed
```

## Packages (Arch)

```
sudo pacman -Sy              update package list
sudo pacman -S <name>        install
sudo pacman -R <name>        remove
sudo pacman -Syu             full system upgrade
pacman -Ss <name>            search
```

---

## Git (short versions from this kit)

```
gs        git status
gd        git diff (what changed)
ga .      git add all
gc -m ""  git commit
gp        git push
gl        git pull
gb        git branch
gsw name  git switch branch
```

---

## Keyboard Shortcuts

```
Ctrl+R      search command history
Ctrl+C      cancel current command
Ctrl+Z      suspend (pause) command
Ctrl+L      clear screen
Ctrl+A      jump to start of line
Ctrl+E      jump to end of line
Ctrl+W      delete last word
Ctrl+U      delete entire line
Tab         autocomplete
Up/Down     scroll through history
```

---

## This Kit's Commands

```
helpme              help index
helpme files        file help
helpme git          git help
helpme shortcuts    keyboard shortcuts
tips                random tip
cheat <cmd>         real-world examples for any command
sysinfo             system overview
trash <file>        safe delete
trash-restore       see what's in trash
trash-empty         empty trash
mkcd <name>         make dir and enter it
extract <file>      unzip/untar anything
myip                public IP
ports               open ports
reload              reload .bashrc
bashrc              edit .bashrc
starshiprc          edit starship prompt config
```

---

## Pipe tricks (combining commands)

```
ls -la | grep ".txt"        filter ls output
cat file.txt | wc -l        count lines in a file
history | tail -20          last 20 commands
command > file.txt          save output to file
command >> file.txt         append output to file
command1 && command2        run command2 only if command1 succeeds
```

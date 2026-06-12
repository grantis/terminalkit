# WSL Setup Guide (Windows Subsystem for Linux)

WSL lets you run a full Linux terminal inside Windows.
It's the best way to get a proper dev environment on Windows
without dual booting.

---

## Install WSL (if you haven't already)

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

This installs Ubuntu by default. Restart when prompted.

For a specific distro:

```powershell
wsl --install -d Ubuntu-22.04
wsl --install -d Arch    # if you want Arch
```

---

## First time setup

After WSL installs, open Ubuntu from the Start menu.
It'll ask for a username and password - this is your Linux user, not your Windows login.

Then run the Terminal Kit installer:

```bash
# Get the kit
git clone https://github.com/YOUR_USERNAME/terminal-kit.git
cd terminal-kit
bash install.sh
```

---

## Windows Terminal (recommended)

Windows Terminal is far better than the default console.
Install from the Microsoft Store or:

```powershell
winget install Microsoft.WindowsTerminal
```

### Set WSL as default

1. Open Windows Terminal
2. Settings (Ctrl+,)
3. Startup > Default profile > Ubuntu (or your distro)
4. Save

### Set the font

1. Settings > Ubuntu profile > Appearance
2. Font face: `JetBrainsMono Nerd Font`
3. Font size: 13
4. Save

---

## Accessing Windows files from WSL

Your Windows drives are mounted under `/mnt/`:

```bash
ls /mnt/c/Users/YourName/
cd /mnt/c/Users/YourName/Downloads/
```

Copy files from Windows to Linux home:

```bash
cp /mnt/c/Users/YourName/Downloads/somefile.txt ~/
```

---

## Accessing WSL files from Windows

In Windows Explorer, type in the address bar:

```
\\wsl$\Ubuntu\home\yourusername
```

Or open Explorer from WSL:

```bash
explorer.exe .    # opens current directory in Explorer
```

---

## Clipboard integration

Already set up in the bashrc if you're on WSL:

```bash
echo "hello" | pbcopy      # copy to Windows clipboard
pbpaste                    # paste from Windows clipboard
```

---

## Open files in Windows apps from WSL

```bash
# Open current folder in VS Code
code .

# Open a file in Notepad
notepad.exe file.txt

# Open a URL in the default browser
wslview https://google.com
# or
open https://google.com    # (alias set up in bashrc)
```

---

## Performance tips

- Store your projects in the Linux filesystem (`~/projects/`) not on `/mnt/c/`
  Linux filesystem is significantly faster for git and node_modules
- Add `.wslconfig` to your Windows home for resource limits:

```ini
# C:\Users\YourName\.wslconfig
[wsl2]
memory=8GB
processors=4
```

---

## Common WSL issues

**Port forwarding** - WSL apps are accessible from Windows at `localhost`

**Slow git on /mnt/c** - Move your repos to `~/` in Linux

**No sound** - WSL2 supports audio natively, but may need PulseAudio config for older setups

**GUI apps** - WSL2 supports Linux GUI apps natively on Windows 11
Just install them and run:
```bash
sudo apt install gedit
gedit &
```

# Installing JetBrains Mono Nerd Font

Nerd Fonts patch regular fonts with thousands of extra icons and symbols.
JetBrains Mono is clean, readable, and designed for code.
Without it, your Starship prompt will show broken boxes instead of icons.

---

## Linux (automatic via install.sh)

The install script handles this. If you want to do it manually:

```bash
# Download
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

# Install to user fonts
mkdir -p ~/.local/share/fonts
unzip JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono/

# Refresh font cache
fc-cache -fv

# Verify
fc-list | grep JetBrains
```

---

## Windows (for WSL users)

Your terminal app runs on Windows, so the font needs to be installed in Windows.

1. Download from: https://www.nerdfonts.com/font-downloads
   (search for JetBrainsMono)
2. Unzip the file
3. Select all `.ttf` files, right click, Install for all users
4. Open Windows Terminal settings (Ctrl+,)
5. Click your profile (Ubuntu/WSL)
6. Appearance tab
7. Font face: `JetBrainsMono Nerd Font`
8. Save

---

## macOS

```bash
# Via Homebrew (easiest)
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

Then set your terminal (iTerm2 / Terminal.app / Alacritty) to use `JetBrainsMono Nerd Font`.

---

## Alacritty

```toml
# ~/.config/alacritty/alacritty.toml
[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
bold   = { family = "JetBrainsMono Nerd Font", style = "Bold" }
size   = 13.0
```

---

## Verify it works

After installing, open a terminal and run:

```bash
echo "  Test icons:       "
```

If you see actual icons (not boxes), you're good.

---

## Alternative Nerd Fonts worth trying

| Font | Vibe |
|---|---|
| `FiraCode Nerd Font` | Ligatures, popular with devs |
| `Hack Nerd Font` | Clean, minimal |
| `CascadiaCode Nerd Font` | Microsoft's monospace, great on Windows |
| `Iosevka Nerd Font` | Very narrow, fits more on screen |

All available at: https://www.nerdfonts.com/font-downloads

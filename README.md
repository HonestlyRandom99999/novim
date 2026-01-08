# novim

A friendly terminal editor for vibe coders. Not vim.

## Install

```bash
curl -fsSL novim.dev/install | bash
```

## Uninstall

```bash
rm -rf ~/.local/bin/novim ~/.local/share/novim
```

## Usage

```bash
novim              # Open editor
novim file.txt     # Open file
```

Press `?` for help.

## Shortcuts

| Key | Action |
|-----|--------|
| Ctrl+S | Save |
| Ctrl+Z | Undo |
| Ctrl+Shift+Z | Redo |
| Ctrl+A | Select all |
| Ctrl+C | Copy |
| Ctrl+V | Paste |
| Esc Esc | Quit |
| ? | Help |

## Features

- Mouse support (click, drag, select)
- Standard keyboard shortcuts
- File tree on the left
- No vim knowledge required

## Requirements

- Neovim 0.8+ (installed automatically if not found)
- macOS, Linux, or WSL

## Credits

novim is powered by [Neovim](https://neovim.io/), licensed under Apache 2.0 and Vim License.

## License

MIT

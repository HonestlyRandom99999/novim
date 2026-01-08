<p align="center">
  <img src="docs/logo.png" alt="novim" width="100%">
</p>

<h1 align="center">novim</h1>

<p align="center">A friendly terminal editor for vibe coders. Not vim.</p>

## Install

```bash
curl -fsSL novim.dev/install | bash
```

## Update

```bash
novim --update
```

## Uninstall

```bash
novim --uninstall
```

## Usage

```bash
novim              # Open editor
novim file.txt     # Open file
novim --help       # Show help
novim --version    # Show version
```

Press `?` for help inside the editor.

## Shortcuts

| Key | Action |
|-----|--------|
| Ctrl+S | Save |
| Ctrl+Z | Undo |
| Ctrl+Shift+Z | Redo |
| Ctrl+A | Select all |
| Ctrl+C | Copy (keeps selection) |
| Ctrl+V | Paste |
| Ctrl+X | Cut |
| Esc Esc | Quit (with save confirmation) |
| ? | Help |

Mac users: Cmd key also works (Cmd+S, Cmd+Z, etc.)

## Features

- **VSCode-like experience** - Just type to edit, no modes to learn
- **Mouse support** - Click, drag, select, double-click to open
- **Standard shortcuts** - Ctrl+S, Ctrl+Z, Ctrl+C/V work as expected
- **File tree** - Built-in file browser on the left (1/3 of screen)
- **Dynamic hints** - Status bar shows relevant shortcuts for current context
- **Change highlighting** - Modified lines are highlighted until saved
- **Safe quit** - Prompts to save unsaved changes on exit
- **No vim knowledge required**

## Requirements

- Neovim 0.8+ (installed automatically if not found)
- macOS, Linux, or WSL

## Credits

novim is powered by [Neovim](https://neovim.io/), licensed under Apache 2.0 and Vim License.

## License

MIT

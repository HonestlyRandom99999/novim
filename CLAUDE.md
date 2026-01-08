# novim - Project Documentation

## Overview

novim is a Neovim wrapper that provides a VSCode-like editing experience for users who are unfamiliar with Vim. It uses a custom Neovim configuration to offer standard keyboard shortcuts and mouse-based operation.

## Project Structure

```
novim/
├── bin/novim           # Main executable (bash script)
├── config/nvim/
│   └── init.lua        # Neovim configuration
├── docs/
│   ├── index.html      # Landing page (novim.dev)
│   ├── install         # Install script for web
│   └── CNAME           # Domain configuration
├── install.sh          # Installation script
├── VERSION             # Version number (single source of truth)
└── .github/workflows/
    ├── ci.yml          # ShellCheck linting
    └── release.yml     # Automated releases
```

## Key Design Decisions

### VSCode-like Behavior (ADR-001)
- Normal mode typing enters insert mode automatically
- Visual mode typing replaces selection
- Standard Ctrl shortcuts (Ctrl+S, Ctrl+Z, Ctrl+C, Ctrl+V)
- No vim knowledge required

### Dynamic Hints System (ADR-002)
- Status bar shows context-aware shortcuts
- File tree: fixed hints (Esc Esc Quit, ? Help)
- Editor: dynamic hints based on state (modified, selecting, etc.)

### Safe Exit (ADR-003)
- Esc Esc triggers quit with confirmation dialog
- Uses `vim.ui.select()` for VSCode-like options
- Options: Save and Quit, Quit without Saving, Cancel

### File Tree Mouse Operations (ADR-004)
- Double-click: Open file in editor / expand directory
- Ctrl+click: Open file with system default app (macOS: `open`, Linux: `xdg-open`)
- Useful for images, PDFs, and other non-text files

## Implementation Notes

### bin/novim
- Resolves symlinks for correct path detection
- Sets XDG directories to isolate config from user's nvim
- Includes --update and --uninstall commands

### config/nvim/init.lua
- Sections: Display, Mouse, Backspace, Shortcuts, File Tree, Help, Hints, Layout, Exit
- Changed lines highlighted with namespace-based highlights
- netrw configured for tree view with 1/3 screen width

### install.sh
- Version comparison without `sort -V` (BSD compatibility)
- Uses snap for Debian/Ubuntu (apt has old neovim)
- Cleanup on error via trap

## Version Management

Version is stored in `VERSION` file. Release workflow:
1. Tag with `v*` (e.g., `v0.1.0`)
2. GitHub Actions updates version in bin/novim
3. Creates tarball and GitHub release

## Testing Checklist

- [ ] `novim --help` shows help
- [ ] `novim --version` shows version
- [ ] File tree opens on left (1/3 width)
- [ ] Double-click expands directories
- [ ] Ctrl+click opens file with system app (images, etc.)
- [ ] Typing inserts text (no vim commands)
- [ ] Ctrl+S saves with "Saved!" message
- [ ] Esc Esc shows quit confirmation
- [ ] Changed lines are highlighted
- [ ] Hints update based on context

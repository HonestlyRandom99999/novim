# How novim Works

## TL;DR

**novim is just a Neovim configuration file.** That's it.

There's no special binary, no fork, no magic. It's a single `init.lua` file that remaps keys to make Neovim behave like a "normal" editor.

---

## What novim Actually Is

```
novim/
├── bin/novim              # Bash script (just runs nvim with custom config)
├── config/nvim/init.lua   # THE configuration file (all the magic is here)
└── config/nvim/pack/...   # gitsigns.nvim plugin
```

### The Wrapper Script (`bin/novim`)

The wrapper does ONE thing: set environment variables so Neovim uses novim's config instead of your personal config.

```bash
export XDG_CONFIG_HOME="$NOVIM_CONFIG"
export XDG_DATA_HOME="$NOVIM_CONFIG/data"
export XDG_STATE_HOME="$NOVIM_CONFIG/state"
exec nvim "$@"
```

That's literally it. No special logic.

### The Configuration (`config/nvim/init.lua`)

This is where everything happens. The entire "magic" of novim is in this ~670 line Lua file.

---

## Key Techniques

### 1. Normal Mode → Just Type

In Vim, Normal mode is for commands. In novim, we remap all printable characters to enter Insert mode:

```lua
-- Printable ASCII characters (32-126) enter insert mode and type
for i = 32, 126 do
  local char = string.char(i)
  if char ~= "?" and char ~= "\\" then
    vim.keymap.set("n", char, "i" .. char, { noremap = true, silent = true })
  end
end
```

So when you press `a` in Normal mode, it becomes `ia` (enter insert mode, type 'a').

### 2. Visual Mode → Selection Replaces

In VSCode, when you have text selected and type, the selection is replaced. We do the same:

```lua
-- Printable ASCII characters replace selection and enter insert mode
for i = 32, 126 do
  local char = string.char(i)
  vim.keymap.set("v", char, '"_c' .. char, { noremap = true, silent = true })
end
```

`"_c` means "delete to black hole register and enter insert mode", so the selection disappears and you start typing.

### 3. Standard Shortcuts

Simple remaps:

```lua
-- Save
vim.keymap.set({ "n", "i", "v" }, "<C-s>", save_file, { silent = true })

-- Undo
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<Esc>u", { silent = true })

-- Copy (keep selection after)
vim.keymap.set("v", "<C-c>", '"+ygv', { silent = true })

-- Paste
vim.keymap.set({ "n", "i", "v" }, "<C-v>", '"+p', { silent = true })
```

### 4. Safe Quit Dialog

Uses Neovim's built-in `vim.ui.select()` for a VSCode-like dialog:

```lua
vim.ui.select(
  { "Save and Quit", "Quit without Saving", "Cancel" },
  { prompt = "You have unsaved changes:" },
  function(choice)
    if choice == "Save and Quit" then
      vim.cmd("wa")
      vim.cmd("qa")
    elseif choice == "Quit without Saving" then
      vim.cmd("qa!")
    end
  end
)
```

### 5. File Tree

Just netrw with some options:

```lua
vim.g.netrw_browse_split = 4   -- Open in previous window
vim.g.netrw_altv = 1           -- Split right
vim.g.netrw_liststyle = 3      -- Tree view
vim.g.netrw_banner = 0         -- No banner
vim.g.netrw_winsize = 33       -- 1/3 width
```

Mouse behavior:
- Double-click: Open file in editor / expand directory
- Ctrl+click: Open file with system default app (for images, PDFs, etc.)

### 6. Color Scheme

Tokyo Night colors are hardcoded directly in the config:

```lua
local colors = {
  bg = "#1a1b26",
  fg = "#c0caf5",
  blue = "#7aa2f7",
  green = "#9ece6a",
  -- ...
}
```

No external colorscheme plugin needed.

---

## For Neovim Users

If you already use Neovim, you have options:

### Option 1: Use novim's config directly
```bash
# Just look at it
cat ~/.local/share/novim/config/nvim/init.lua
```

### Option 2: Copy specific parts
The config is organized into sections. Copy what you need:
- Lines 17-144: Color scheme
- Lines 222-263: Backspace/Delete handling
- Lines 266-300: Ctrl shortcuts
- Lines 462-495: Safe quit dialog

### Option 3: Use as inspiration
The techniques (remapping normal mode keys, visual mode replace, etc.) can be adapted to your own config.

---

## Why Not Just a Plugin?

[novim-mode](https://github.com/tombh/novim-mode) exists as a Vim plugin with similar goals. novim takes a different approach:

| | novim | novim-mode |
|---|---|---|
| Type | Standalone wrapper | Vim plugin |
| Installation | One curl command | Plugin manager |
| Isolation | Separate config | Uses your config |
| Target | Complete beginners | Vim users |

novim is designed for people who will **never** learn Vim commands. The standalone approach means they don't need to understand plugin managers, vimrc, or any Vim concepts.

---

## The Philosophy

> "The best config is one you don't know exists."

novim users shouldn't need to know they're using Neovim. They just open `novim`, type, save with Ctrl+S, and quit with Esc Esc.

That's why it's a wrapper and not a plugin. The complexity is hidden.

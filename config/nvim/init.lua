----------------------------------------------------------------------
-- novim - A friendly terminal editor for vibe coders
-- https://github.com/ogawariku/novim
--
-- Features:
--   - Mouse-based operation
--   - Standard shortcuts (Ctrl+S, Ctrl+Z, etc.)
--   - File tree on the left
--   - No vim knowledge required
----------------------------------------------------------------------


----------------------------------------------------------------------
-- 1. Display and Input Settings
----------------------------------------------------------------------

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true

-- Hide mode display (INSERT/NORMAL) for VSCode-like feel
vim.opt.showmode = false

-- Allow cursor to go one past end of line (for right-edge click)
vim.opt.virtualedit = "onemore"

-- Make Backspace work properly in Insert mode
vim.opt.backspace = { "indent", "eol", "start" }


----------------------------------------------------------------------
-- 2. Mouse Settings
----------------------------------------------------------------------

vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

-- Share clipboard with OS
vim.opt.clipboard = "unnamedplus"


----------------------------------------------------------------------
-- 3. Backspace / Delete Support
-- Handle terminal differences (<BS> / <C-h>)
----------------------------------------------------------------------

-- Normal mode: delete one character
vim.keymap.set("n", "<BS>", "X", { silent = true })
vim.keymap.set("n", "<C-h>", "X", { silent = true })

-- Visual mode: delete selection
vim.keymap.set("v", "<BS>", "d", { silent = true })
vim.keymap.set("v", "<C-h>", "d", { silent = true })
vim.keymap.set("v", "<Del>", "d", { silent = true })


----------------------------------------------------------------------
-- 4. Ctrl / Cmd Shortcuts
----------------------------------------------------------------------

-- Select all
vim.keymap.set({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { silent = true })
vim.keymap.set({ "n", "i", "v" }, "<D-a>", "<Esc>ggVG", { silent = true })

-- Save
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc>:w<CR>", { silent = true })
vim.keymap.set({ "n", "i", "v" }, "<D-s>", "<Esc>:w<CR>", { silent = true })

-- Undo
vim.keymap.set({ "n", "i" }, "<C-z>", "<Esc>u", { silent = true })
vim.keymap.set({ "n", "i" }, "<D-z>", "<Esc>u", { silent = true })
vim.keymap.set("v", "<C-z>", "<Esc>u", { silent = true })
vim.keymap.set("v", "<D-z>", "<Esc>u", { silent = true })

-- Redo
vim.keymap.set({ "n", "i", "v" }, "<C-S-z>", "<Esc><C-r>", { silent = true })
vim.keymap.set({ "n", "i", "v" }, "<D-S-z>", "<Esc><C-r>", { silent = true })

-- Copy / Paste
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
vim.keymap.set("n", "<C-c>", '"+yy', { silent = true })
vim.keymap.set({ "n", "i", "v" }, "<C-v>", '"+p', { silent = true })


----------------------------------------------------------------------
-- 5. File Tree (netrw)
----------------------------------------------------------------------

vim.g.netrw_browse_split = 4   -- Open selected file in right pane
vim.g.netrw_altv = 1           -- Vertical split opens on right
vim.g.netrw_liststyle = 3      -- Tree view
vim.g.netrw_banner = 0         -- Hide banner


----------------------------------------------------------------------
-- 6. Help Screen (Press ? to show)
----------------------------------------------------------------------

local function show_help()
  local lines = {
    "",
    "              Welcome to novim",
    "",
    "  BASIC EDITING",
    "    Click anywhere      Move cursor",
    "    Type                Insert text",
    "    Backspace/Delete    Remove text",
    "    Drag to select      Select text",
    "",
    "  SHORTCUTS",
    "    Ctrl+S              Save",
    "    Ctrl+Z              Undo",
    "    Ctrl+Shift+Z        Redo",
    "    Ctrl+A              Select all",
    "    Ctrl+C              Copy",
    "    Ctrl+V              Paste",
    "",
    "  FILE TREE (left panel)",
    "    Click file          Open in editor",
    "    Enter on file       Open in editor",
    "",
    "  EXIT",
    "    Esc Esc (twice)     Quit editor",
    "",
    "        Press any key to close...",
    "",
  }

  local width = 46
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Close on any key
  local close_keys = { "<CR>", "q", "<Esc>", "<Space>", "<BS>", "?" }
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "", {
      callback = function()
        vim.api.nvim_win_close(win, true)
      end,
      noremap = true,
      silent = true,
    })
  end
end

-- Press ? to show help
vim.keymap.set("n", "?", show_help, { silent = true })


----------------------------------------------------------------------
-- 7. Startup Layout
-- Opens file tree on left, editor on right
----------------------------------------------------------------------

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() > 0 then return end

    vim.cmd("Vex")
    vim.cmd("wincmd H")
    vim.cmd("wincmd l")

    -- Show hint at bottom
    vim.defer_fn(function()
      vim.api.nvim_echo({{ "Press ? for help", "Comment" }}, false, {})
    end, 100)
  end,
})


----------------------------------------------------------------------
-- 8. Exit
----------------------------------------------------------------------

-- Press Esc twice to quit (even with unsaved changes)
vim.keymap.set("n", "<Esc><Esc>", ":qa!<CR>", { silent = true })


-- Press ? for help

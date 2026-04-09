-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.title = true

opt.relativenumber = true
opt.number = true

-- Tabs / Indentation
opt.expandtab = true -- convert tabs to spaces
opt.tabstop = 4 -- number of spaces inserted for tab character
opt.softtabstop = 4 -- number of spaces inserted for <Tab> key
opt.shiftwidth = 4 -- number of spaces inserted for each indentation level
opt.autoindent = true
opt.smartindent = true -- enable smart indentation
opt.breakindent = true -- enable line breaking indentation

opt.wrap = false

-- Searching Behaviours
opt.hlsearch = true -- highlight all matches in search
opt.incsearch = true
opt.ignorecase = true -- ignore case in search
opt.smartcase = true -- match case if explicitly stated
opt.smartcase = true -- match case if explicitly statedvim.opt.smartcase = true -- match case if explicitly stated

opt.showcmd = true
opt.cmdheight = 0
opt.laststatus = 0
opt.inccommand = "split"

-- Turn On termguicolors for tokyonight colorscheme to work
opt.termguicolors = true -- enable term GUI colors
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

opt.scrolloff = 8 -- number of lines to keep above/below cursor
opt.isfname:append("@-@")

-- Backspace
opt.backspace = { "indent", "eol", "start" } -- allow backspace on indent, end of line or insert mode start position

-- Clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

opt.conceallevel = 0 -- show concealed characters in markdown files
opt.fileencoding = "utf-8" -- set file encoding to UTF-8

-- Split Windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
opt.splitkeep = "cursor" -- keep the curson in the same position while closing the window

-- Turn Off swapfile
opt.swapfile = false -- creates a swapfile

opt.backup = false -- disable backup file creation
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true -- enable persistent undo

opt.path:append({ "**" })
opt.wildignore:append({ "*/node_modules/*" })

opt.updatetime = 50 -- set faster completion
opt.writebackup = false -- prevent editing of files being edited elsewhere
opt.cursorline = true -- highlight current line

opt.formatoptions:append({ "r" }) -- Add asterisks in clock comments

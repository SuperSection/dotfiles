vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- Tabs / Indentation
opt.expandtab = true -- convert tabs to spaces
opt.tabstop = 2 -- number of spaces inserted for tab character
opt.softtabstop = 2 -- number of spaces inserted for <Tab> key
opt.shiftwidth = 2 -- number of spaces inserted for each indentation level
opt.smartindent = true -- enable smart indentation
opt.breakindent = true -- enable line breaking indentation

opt.wrap = false

-- Searching Behaviours
opt.hlsearch = true -- highlight all matches in search
opt.incsearch = true
opt.ignorecase = true -- ignore case in search
opt.smartcase = true -- match case if explicitly stated
opt.smartcase = true -- match case if explicitly statedvim.opt.smartcase = true -- match case if explicitly stated

opt.cursorline = true

-- Turn On termguicolors for tokyonight colorscheme to work
opt.termguicolors = true -- enable term GUI colors
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

opt.scrolloff = 8 -- number of lines to keep above/below cursor
opt.isfname:append("@-@")

-- Backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- Clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

opt.conceallevel = 0 -- show concealed characters in markdown files
opt.fileencoding = "utf-8" -- set file encoding to UTF-8

-- Split Windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Turn Off swapfile
opt.swapfile = false -- creates a swapfile

opt.backup = false -- disable backup file creation
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true -- enable persistent undo

opt.updatetime = 50 -- set faster completion
opt.writebackup = false -- prevent editing of files being edited elsewhere
opt.cursorline = true -- highlight current line

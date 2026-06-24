vim.g.mapleader = " "

local function map(mode, lhs, rhs, desc)
    local opts = { silent = true }
    if desc then
        opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Save
map("n", "<leader>w", "<CMD>update<CR>")

-- Quit
map("n", "<leader>q", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- New Windows
map("n", "<leader>o", "<CMD>vsplit<CR>")
map("n", "<leader>p", "<CMD>split<CR>")

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

map("n", "gD", vim.lsp.buf.declaration, "Show method declaration")
map("n", "gd", vim.lsp.buf.definition, "Go to method definition")
map("n", "gi", vim.lsp.buf.implementation, "Go to method implementation")
map("n", "K", vim.lsp.buf.hover, "Show hover")
map("n", "gr", vim.lsp.buf.references, "Show method references")
map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
map("n", "gK", vim.lsp.buf.signature_help, "Show method signatures")
map("n", "<leader>rn", vim.lsp.buf.rename, "Rename method/class")
map("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
end, "Format code")
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

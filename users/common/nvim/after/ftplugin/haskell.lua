local ht = require("haskell-tools")

vim.keymap.set(
  "n",
  "<leader>ch",
  ht.hoogle.hoogle_signature,
  { noremap = true, silent = true, desc = "Hoogle signature search" }
)

vim.keymap.set(
  "n",
  "<leader>ea",
  ht.lsp.buf_eval_all,
  { noremap = true, silent = true, desc = "[e]valuate [a]ll expressions in buffer" }
)

vim.keymap.set("n", "<leader>rr", ht.repl.toggle, { noremap = true, silent = true, desc = "Toggle Haskell [R]EPL" })
vim.keymap.set("n", "<leader>rf", function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, { noremap = true, silent = true, desc = "Toggle Haskell [R]EPL for current [f]ile" })
vim.keymap.set("n", "<leader>rq", ht.repl.quit, { noremap = true, silent = true, desc = "Haskell [R]EPL: [q]uit" })


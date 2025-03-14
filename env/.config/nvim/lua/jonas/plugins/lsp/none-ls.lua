return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    require("mason-null-ls").setup({
      ensure_installed = { "ruff", "prettier", "shfmt", "mypy", "stylua" },
      automatic_installation = true,
    })
    local nls = require("null-ls")
    local sources = {
      require("none-ls.formatting.ruff").with({
        extra_args = {
          "--extend-select",
          "I",
        },
      }),
      require("none-ls.formatting.ruff_format"),
      nls.builtins.diagnostics.mypy.with({
        extra_args = function()
          local args = {
            "--disable-error-code=attr-defined",
            "--disable-error-code=name-defined",
          }
          -- Only add python-executable if virtual env exists
          local venv = vim.fn.getenv("VIRTUAL_ENV")
          if type(venv) == "string" and venv ~= "" then
            table.insert(args, "--python-executable=" .. venv .. "/bin/python")
          end
          return args
        end,
        runtime_condition = function(params)
          local full_path = vim.api.nvim_buf_get_name(params.bufnr)
          return not (full_path:match(".venv/") or full_path:match("venv/"))
        end,
      }),
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.prettier.with({
        filetypes = {
          "json",
          "yaml",
          "markdown",
        },
      }),
    }
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    nls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })
  end,
}

local present, null_ls = pcall(require, "null-ls-nvim")

if not present then
  return
end

null_ls.setup({
  sources = {
    -- Code actions
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.code_actions.shellcheck,

    -- Diagnostics/linters
    null_ls.bultins.diagnostics.ansiblelint,
    null_ls.bultins.diagnostics.checkmake,
    null_ls.bultins.diagnostics.codespell,
    null_ls.bultins.diagnostics.cspell,
    null_ls.bultins.diagnostics.curlylint,
    null_ls.bultins.diagnostics.gitlint,
    null_ls.bultins.diagnostics.golangci_lint,
    null_ls.bultins.diagnostics.jsonlint,
    null_ls.bultins.diagnostics.luacheck,
    null_ls.bultins.diagnostics.shellcheck,
    null_ls.bultins.diagnostics.sqlfluff,
    null_ls.bultins.diagnostics.stylelint,
    null_ls.bultins.diagnostics.tidy,
    null_ls.bultins.diagnostics.vale,
    null_ls.bultins.diagnostics.yamllint,
    null_ls.bultins.diagnostics.zsh,

    -- Formatting
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.mdformat,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.puppet_lint,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.shellharden,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.tidy,
  },
})

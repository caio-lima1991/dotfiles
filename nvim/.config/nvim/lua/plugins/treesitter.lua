vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local ts_ok, ts = pcall(require, "nvim-treesitter")
if not ts_ok then
	return
end

local languages = {
	"bash",
	"diff",
	"graphql",
	"html",
	"http",
	"java",
	"javadoc",
	"javascript",
	"query",
	"sql",
	"typescript",
	"lua",
}

ts.install(languages)

vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function()
		pcall(vim.treesitter.start)

		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
	end,
})

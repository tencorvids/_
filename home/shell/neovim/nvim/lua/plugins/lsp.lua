return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- LSP keymappings
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("<LEADER>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<LEADER>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<LEADER>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Set up document highlight
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- LSP server configurations
			-- Add or modify server configurations here
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							completion = { callSnippet = "Replace" },
						},
					},
				},
				gopls = {},
				nil_ls = {},
				astro = {},
				svelte = {},
				tailwindcss = {},
				csharp_ls = {},
			}

			local lspconfig = require("lspconfig")
			for server, config in pairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
					settings = config.settings,
				})
			end
		end,
	},

	-- Autoformat
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt" },
				nix = { "alejandra" },
				-- Add more formatters here
			},
		},
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<RETURN>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "nil" },
					{ name = "tailwindcss" },
					-- Add more sources here
				},
			})
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"lua",
					"vim",
					"vimdoc",
					"c",
					"go",
					"nix",
					-- Add more languages here
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}

-- -- LSP, Treesitter, and Completions
-- -- Auto completions, syntax highlighting, go to definitions, etc.
-- -- Copy-pasted from kickstart's init.lua
-- -- Great, sensible defaults, full credit to that project
-- -- https://github.com/nvim-lua/kickstart.nvim
-- return {
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		dependencies = {
-- 			-- Useful status updates for LSP.
-- 			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
-- 			{ "j-hui/fidget.nvim", opts = {} },
-- 		},
-- 		config = function()
-- 			-- Brief Aside: **What is LSP?**
-- 			--
-- 			-- LSP is an acronym you've probably heard, but might not understand what it is.
-- 			--
-- 			-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- 			-- and language tooling communicate in a standardized fashion.
-- 			--
-- 			-- In general, you have a "server" which is some tool built to understand a particular
-- 			-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
-- 			-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- 			-- processes that communicate with some "client" - in this case, Neovim!
-- 			--
-- 			-- LSP provides Neovim with features like:
-- 			--  - Go to definition
-- 			--  - Find references
-- 			--  - Autocompletion
-- 			--  - Symbol Search
-- 			--  - and more!
-- 			--
-- 			-- Thus, Language Servers are external tools that must be installed separately from
-- 			-- Neovim. This is where `mason` and related plugins come into play.
-- 			--
-- 			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- 			-- and elegantly composed help section, `:help lsp-vs-treesitter`
--
-- 			--  This function gets run when an LSP attaches to a particular buffer.
-- 			--    That is to say, every time a new file is opened that is associated with
-- 			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
-- 			--    function will be executed to configure the current buffer
-- 			vim.api.nvim_create_autocmd("LspAttach", {
-- 				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
-- 				callback = function(event)
-- 					-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- 					-- to define small helper and utility functions so you don't have to repeat yourself
-- 					-- many times.
-- 					--
-- 					-- In this case, we create a function that lets us more easily define mappings specific
-- 					-- for LSP related items. It sets the mode, buffer and description for us each time.
-- 					local map = function(keys, func, desc)
-- 						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
-- 					end
--
-- 					-- Jump to the definition of the word under your cursor.
-- 					--  This is where a variable was first declared, or where a function is defined, etc.
-- 					--  To jump back, press <C-T>.
-- 					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
--
-- 					-- WARN: This is not Goto Definition, this is Goto Declaration.
-- 					--  For example, in C this would take you to the header
-- 					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
--
-- 					-- Find references for the word under your cursor.
-- 					-- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
--
-- 					-- Jump to the implementation of the word under your cursor.
-- 					--  Useful when your language has ways of declaring types without an actual implementation.
-- 					-- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
--
-- 					-- Jump to the type of the word under your cursor.
-- 					--  Useful when you're not sure what type a variable is and you want to see
-- 					--  the definition of its *type*, not where it was *defined*.
-- 					map("<LEADER>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
--
-- 					-- Fuzzy find all the symbols in your current document.
-- 					--  Symbols are things like variables, functions, types, etc.
-- 					-- map("<LEADER>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
--
-- 					-- Fuzzy find all the symbols in your current workspace
-- 					--  Similar to document symbols, except searches over your whole project.
-- 					-- map(
-- 					-- 	"<LEADER>ws",
-- 					-- 	require("telescope.builtin").lsp_dynamic_workspace_symbols,
-- 					-- 	"[W]orkspace [S]ymbols"
-- 					-- )
--
-- 					-- Rename the variable under your cursor
-- 					--  Most Language Servers support renaming across files, etc.
-- 					map("<LEADER>rn", vim.lsp.buf.rename, "[R]e[n]ame")
--
-- 					-- Execute a code action, usually your cursor needs to be on top of an error
-- 					-- or a suggestion from your LSP for this to activate.
-- 					map("<LEADER>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
--
-- 					-- Opens a popup that displays documentation about the word under your cursor
-- 					--  See `:help K` for why this keymap
-- 					map("K", vim.lsp.buf.hover, "Hover Documentation")
--
-- 					-- The following two autocommands are used to highlight references of the
-- 					-- word under your cursor when your cursor rests there for a little while.
-- 					--    See `:help CursorHold` for information about when this is executed
-- 					--
-- 					-- When you move your cursor, the highlights will be cleared (the second autocommand).
-- 					local client = vim.lsp.get_client_by_id(event.data.client_id)
-- 					if client and client.server_capabilities.documentHighlightProvider then
-- 						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
-- 							buffer = event.buf,
-- 							callback = vim.lsp.buf.document_highlight,
-- 						})
--
-- 						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
-- 							buffer = event.buf,
-- 							callback = vim.lsp.buf.clear_references,
-- 						})
-- 					end
-- 				end,
-- 			})
--
-- 			-- LSP servers and clients are able to communicate to each other what features they support.
-- 			--  By default, Neovim doesn't support everything that is in the LSP Specification.
-- 			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
-- 			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
-- 			local capabilities = vim.lsp.protocol.make_client_capabilities()
-- 			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
--
-- 			-- Enable the following language servers
-- 			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
-- 			--
-- 			--  Add any additional override configuration in the following tables. Available keys are:
-- 			--  - cmd (table): Override the default command used to start the server
-- 			--  - filetypes (table): Override the default list of associated filetypes for the server
-- 			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
-- 			--  - settings (table): Override the default settings passed when initializing the server.
-- 			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
-- 			local servers = {
-- 				gopls = {},
--
-- 				tsserver = {},
--
-- 				astro = {},
--
-- 				svelte = {},
--
-- 				tailwindcss = {},
--
-- 				lua_ls = {
-- 					settings = {
-- 						Lua = {
-- 							runtime = { version = "LuaJIT" },
-- 							workspace = {
-- 								checkThirdParty = false,
-- 								-- Tells lua_ls where to find all the Lua files that you have loaded
-- 								-- for your neovim configuration.
-- 								library = {
-- 									"${3rd}/luv/library",
-- 									unpack(vim.api.nvim_get_runtime_file("", true)),
-- 								},
-- 								-- If lua_ls is really slow on your computer, you can try this instead:
-- 								-- library = { vim.env.VIMRUNTIME },
-- 							},
-- 							completion = {
-- 								callSnippet = "Replace",
-- 							},
-- 							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
-- 							-- diagnostics = { disable = { 'missing-fields' } },
-- 						},
-- 					},
-- 				},
-- 			}
--
-- 			local lspconfig = require("lspconfig")
--
-- 			for server, config in pairs(servers) do
-- 				lspconfig[server].setup({
-- 					capabilities = capabilities,
-- 					settings = config.settings,
-- 				})
-- 			end
-- 		end,
-- 	},
-- 	{ -- Autoformat
-- 		"stevearc/conform.nvim",
-- 		opts = {
-- 			notify_on_error = false,
-- 			format_on_save = {
-- 				timeout_ms = 500,
-- 				lsp_fallback = true,
-- 			},
-- 			formatters_by_ft = {
-- 				lua = { "stylua" },
-- 				go = { "gofmt" },
-- 				typescript = { "prettier", "prettierd" },
-- 				-- astro = { "prettier", "prettierd" },
-- 				-- svelte = { "prettier", "prettierd" },
-- 			},
-- 		},
-- 	},
--
-- 	{ -- Autocompletion
-- 		"hrsh7th/nvim-cmp",
-- 		event = "InsertEnter",
-- 		dependencies = {
-- 			-- Snippet Engine & its associated nvim-cmp source
-- 			{
-- 				"L3MON4D3/LuaSnip",
-- 				build = (function()
-- 					-- Build Step is needed for regex support in snippets
-- 					-- This step is not supported in many windows environments
-- 					-- Remove the below condition to re-enable on windows
-- 					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
-- 						return
-- 					end
-- 					return "make install_jsregexp"
-- 				end)(),
-- 			},
-- 			"saadparwaiz1/cmp_luasnip",
--
-- 			-- Adds other completion capabilities.
-- 			--  nvim-cmp does not ship with all sources by default. They are split
-- 			--  into multiple repos for maintenance purposes.
-- 			"hrsh7th/cmp-nvim-lsp",
-- 			"hrsh7th/cmp-path",
--
-- 			-- If you want to add a bunch of pre-configured snippets,
-- 			--    you can use this plugin to help you. It even has snippets
-- 			--    for various frameworks/libraries/etc. but you will have to
-- 			--    set up the ones that are useful for you.
-- 			-- 'rafamadriz/friendly-snippets',
-- 		},
-- 		config = function()
-- 			-- See `:help cmp`
-- 			local cmp = require("cmp")
-- 			local luasnip = require("luasnip")
-- 			luasnip.config.setup({})
--
-- 			cmp.setup({
-- 				snippet = {
-- 					expand = function(args)
-- 						luasnip.lsp_expand(args.body)
-- 					end,
-- 				},
-- 				completion = { completeopt = "menu,menuone,noinsert" },
--
-- 				-- For an understanding of why these mappings were
-- 				-- chosen, you will need to read `:help ins-completion`
-- 				--
-- 				-- No, but seriously. Please read `:help ins-completion`, it is really good!
-- 				mapping = cmp.mapping.preset.insert({
-- 					-- Select the [n]ext item
-- 					["<C-n>"] = cmp.mapping.select_next_item(),
-- 					-- Select the [p]revious item
-- 					["<C-p>"] = cmp.mapping.select_prev_item(),
--
-- 					-- Accept ([y]es) the completion.
-- 					-- Changed to <RETURN> but willing to try defaul <C-y> binding in the future
-- 					--  This will auto-import if your LSP supports it.
-- 					--  This will expand snippets if the LSP sent a snippet.
-- 					["<RETURN>"] = cmp.mapping.confirm({ select = true }),
--
-- 					-- Manually trigger a completion from nvim-cmp.
-- 					--  Generally you don't need this, because nvim-cmp will display
-- 					--  completions whenever it has completion options available.
-- 					["<C-Space>"] = cmp.mapping.complete({}),
--
-- 					-- Think of <c-l> as moving to the right of your snippet expansion.
-- 					--  So if you have a snippet that's like:
-- 					--  function $name($args)
-- 					--    $body
-- 					--  end
-- 					--
-- 					-- <c-l> will move you to the right of each of the expansion locations.
-- 					-- <c-h> is similar, except moving you backwards.
-- 					["<C-l>"] = cmp.mapping(function()
-- 						if luasnip.expand_or_locally_jumpable() then
-- 							luasnip.expand_or_jump()
-- 						end
-- 					end, { "i", "s" }),
-- 					["<C-h>"] = cmp.mapping(function()
-- 						if luasnip.locally_jumpable(-1) then
-- 							luasnip.jump(-1)
-- 						end
-- 					end, { "i", "s" }),
-- 				}),
-- 				sources = {
-- 					{ name = "nvim_lsp" },
-- 					{ name = "luasnip" },
-- 					{ name = "path" },
-- 					{ name = "buffer" },
-- 					{ name = "tsserver" },
-- 					{ name = "astro" },
-- 					{ name = "tailwindcss" },
-- 					{ name = "svelte" },
-- 					-- { name = "css-lsp" },
-- 				},
-- 			})
-- 		end,
-- 	},
--
-- 	{ -- Treesitter: Highlight, edit, and navigate code
-- 		"nvim-treesitter/nvim-treesitter",
-- 		build = ":TSUpdate",
-- 		config = function()
-- 			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--
-- 			---@diagnostic disable-next-line: missing-fields
-- 			require("nvim-treesitter.configs").setup({
-- 				ensure_installed = {
-- 					"bash",
-- 					"lua",
-- 					"vim",
-- 					"vimdoc",
-- 					"c",
-- 					"go",
-- 					"nix",
-- 					"html",
-- 					"css",
-- 					"javascript",
-- 					"typescript",
-- 					"astro",
-- 					"svelte",
-- 				},
-- 				-- Autoinstall languages that are not installed
-- 				auto_install = true,
-- 				highlight = { enable = true },
-- 				indent = { enable = true },
-- 			})
--
-- 			-- There are additional nvim-treesitter modules that you can use to interact
-- 			-- with nvim-treesitter. You should go explore a few and see what interests you:
-- 			--
-- 			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
-- 			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
-- 			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- 		end,
-- 	},
-- }

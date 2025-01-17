local get_colors = function()
	local colors_path = 'oxocarbon-lua.colors'
	local background = vim.api.nvim_get_option('background')

	if background == 'dark' then
		return require(colors_path).dark
	elseif background == 'light' then
		return require(colors_path).light
	else
		vim.notify('Error: Background not set.', vim.log.levels.ERROR)
		return nil
	end
end

local set_terminal_colors = function(colors)
	if vim.g.oxocarbon_lua_keep_terminal then
		return
	end

	vim.api.nvim_set_var('terminal_color_background', colors[1])
	vim.api.nvim_set_var('terminal_color_foreground', colors[5])

	for x = 0,15 do
		vim.api.nvim_set_var('terminal_color_' .. x, colors[x + 1])
	end
end

local conditional_italic = function()
	if vim.g.oxocarbon_lua_disable_italic then
		return nil
	else
		return {'italic'}
	end
end

local conditional_bg = function(arg)
	if vim.g.oxocarbon_lua_transparent then
		return 'none'
	else
		return arg
	end
end

local extend_with_attributes = function(orig, attrs)
	if not attrs then
		return orig
	end

	for k, v in pairs(attrs) do
		if type(k) == "number" then
			-- Value is the attribute name
			orig[v] = 1
		else
			-- Key is the attribute name
			orig[k] = v
		end
	end
	return orig
end

return {
	load = function()
		local colors = get_colors()

		if not colors then
			return
		end

		vim.g.colors_name = "oxocarbon-lua"
		vim.api.nvim_set_option('termguicolors', true)
		set_terminal_colors(colors)

		local function highlight(name, fg, bg, attrs)
			local fg_color = type(fg) == "number" and colors[fg] or fg
			local bg_color = type(bg) == "number" and colors[bg] or bg

			vim.api.nvim_set_hl(
				0,
				name,
				extend_with_attributes(
					{
						fg = fg_color,
						bg = bg_color,
					},
					attrs
				)
			)
		end

		local function link(from, to)
			vim.api.nvim_set_hl(0, from, { link = to })
		end

		-- editor
		highlight('ColorColumn', 18, 2)
		highlight('Cursor', 1, 5)
		highlight('CursorLine', 18, 2)
		highlight('CursorColumn', 18, 2)
		highlight('CursorLineNr', 5, conditional_bg(18))
		highlight('QuickFixLine', 18, 2)
		highlight('Error', 5, 12)
		highlight('LineNr', 4, conditional_bg(1))
		highlight('NonText', 3, conditional_bg(18))
		highlight('Normal', 5, conditional_bg(1))
		highlight('Pmenu', 5, 2)
		highlight('PmenuSbar', 5, 2)
		highlight('PmenuSel', 9, 3)
		highlight('PmenuThumb', 9, 3)
		highlight('SpecialKey', 4, 18)
		highlight('Visual', 18, 3)
		highlight('VisualNOS', 18, 3)
		highlight('TooLong', 18, 3)
		highlight('Debug', 14, 18)
		highlight('Macro', 8, 18)
		highlight('MatchParen', 18, 3, {'underline'})
		highlight('Bold', 18, 18, {'bold'})
		highlight('Italic', 18, 18, {'italic'})
		highlight('Underlined', 18, 18, {'underline'})

		-- diagnostics
		highlight('DiagnosticWarn', 9, 18)
		highlight('DiagnosticError', 11, 18)
		highlight('DiagnosticInfo', 10, 18)
		highlight('DiagnosticHint', 5, 18)
		highlight('DiagnosticUnderlineWarn', 9, 18, {'undercurl'})
		highlight('DiagnosticUnderlineError', 11, 18, {'undercurl'})
		highlight('DiagnosticUnderlineInfo', 5, 18, {'undercurl'})
		highlight('DiagnosticUnderlineHint', 5, 18, {'undercurl'})

		-- lsp
		highlight('LspReferenceText', 18, 4)
		highlight('LspReferenceread', 18, 4)
		highlight('LspReferenceWrite', 18, 4)
		highlight('LspSignatureActiveParameter', 9, 18)

		-- gutter
		highlight('Folded', 4, conditional_bg(2))
		highlight('FoldColumn', 4, conditional_bg(1))
		highlight('SignColumn', 2, conditional_bg(1))

		-- navigation
		highlight('Directory', 9, 18)

		-- prompts
		highlight('EndOfBuffer', 2, 18)
		highlight('ErrorMsg', 11, 18)
		highlight('ModeMsg', 5, 18)
		highlight('MoreMsg', 9, 18)
		highlight('Question', 5, 18)
		highlight('Substitute', 5, 18)
		highlight('WarningMsg', 14, 18)
		highlight('WildMenu', 9, 2)

		-- search
		highlight('IncSearch', 7, 11)
		highlight('Search', 2, 9)

		-- tabs
		highlight('TabLine', 5, 2)
		highlight('TabLineFill', 5, 2)
		highlight('TabLineSel', 9, 4)

		-- window
		highlight('Title', 5, 18)
		highlight('VertSplit', 2, 1)

		-- regular syntax
		highlight('Boolean', 10, 18)
		highlight('Character', 15, 18)
		highlight('Comment', 4, 18)
		highlight('Conceal', 18, 18)
		highlight('Conditional', 10, 18)
		highlight('Constant', 5, 18)
		highlight('Decorator', 13, 18)
		highlight('Define', 10, 18)
		highlight('Delimeter', 7, 18)
		highlight('Exception', 10, 18)
		highlight('Float', 16, 18)
		highlight('Function', 9, 18)
		highlight('Identifier', 5, 18)
		highlight('Include', 10, 18)
		highlight('Keyword', 10, 18)
		highlight('Label', 10, 18)
		highlight('Number', 16, 18)
		highlight('Operator', 10, 18)
		highlight('PreProc', 10, 18)
		highlight('Repeat', 10, 18)
		highlight('Special', 5, 18)
		highlight('SpecialChar', 5, 18)
		highlight('SpecialComment', 9, 18)
		highlight('Statement', 10, 18)
		highlight('StorageClass', 10, 18)
		highlight('String', 15, 18)
		highlight('Structure', 10, 18)
		highlight('Tag', 5, 18)
		highlight('Todo', 14, 18)
		highlight('Type', 10, 18)
		highlight('Typedef', 10, 18)

		-- diff
		highlight('diffAdded', 8, 18)
		highlight('diffChanged', 10, 18)
		highlight('diffRemoved', 11, 18)
		highlight('DiffAdd', "#122f2f", 18)
		highlight('DiffChange', "#222a39", 18)
		highlight('DiffText', "#2f3f5c", 18)
		highlight('DiffDelete', "#361c28", 18)

		-- Spell
		highlight('SpellBad', 18, 18, { sp = colors[11], 'undercurl' })
		highlight('SpellCap', 18, 18, { sp = colors[10], 'undercurl' })
		highlight('SpellRare', 18, 18, { sp = colors[15], 'undercurl' })
		highlight('SpellLocal', 18, 18, { sp = colors[9], 'undercurl' })

		-- treesitter
		highlight('@annotation', 13, 18)
		highlight('@attribute', 16, 18)
		highlight('@boolean', 10, 18)
		highlight('@character', 15, 18)
		-- highlight('@character.special', 15, 18)
		highlight('@comment', 4, 18, conditional_italic())
		-- highlight('@conceal', 15, 18)
		highlight('@conditional', 10, 18)
		highlight('@constant', 15, 18)
		highlight('@constant.builtin', 8, 18)
		highlight('@constant.macro', 8, 18)
		highlight('@constructor', 10, 18)
		-- highlight('@debug', 15, 18)
		-- highlight('@define', 15, 18)
		highlight('@current.scope', 18, 18, {'bold'})
		highlight('@error', 12, 18)
		highlight('@exception', 16, 18)
		highlight('@field', 5, 18)
		highlight('@float', 16, 18)
		highlight('@function', 13, 18, {'bold'})
		highlight('@function.builtin', 13, 18)
		highlight('@function.macro', 8, 18)
		highlight('@include', 10, 18)
		highlight('@keyword', 10, 18)
		highlight('@keyword.function', 9, 18)
		highlight('@keyword.operator', 9, 18)
		highlight('@label', 16, 18)
		-- highlight('@macro', 15, 18)
		highlight('@method', 8, 18)
		highlight('@namespace', 5, 18)
		-- highlight('@none', 15, 18)
		-- highlight('@nospell', 15, 18)
		highlight('@number', 16, 18)
		highlight('@operator', 10, 18)
		highlight('@parameter', 5, 18)
		highlight('@parameter.reference', 5, 18)
		highlight('@preproc', 15, 18)
		highlight('@property', 11, 18)
		-- highlight('@punctuation', 15, 18)
		highlight('@punctuation.bracket', 9, 18)
		highlight('@punctuation.delimiter', 9, 18)
		highlight('@punctuation.special', 9, 18)
		highlight('@repeat', 10, 18)
		-- highlight('@spell', 15, 18)
		-- highlight('@storageclass', 15, 18)
		highlight('@string', 15, 18)
		highlight('@string.escape', 16, 18)
		-- highlight('@string.special', 15, 18)
		highlight('@string.regex', 8, 18)
		highlight('@structure', 15, 18)
		highlight('@symbol', 16, 18, {'bold'})
		highlight('@tag', 5, 18)
		highlight('@tag.delimiter', 16, 18)
		highlight('@text', 5, 18)
		highlight('@text.emphasis', 11, 18, {'bold'})
		highlight('@text.literal', 5, 18)
		-- highlight('@text.math', 15, 18)
		-- highlight('@text.reference', 15, 18)
		highlight('@text.strikethrough', 11, 18, {'strikethrough'})
		highlight('@text.strong', 18, 18, {'bold'})
		highlight('@text.title', 11, 18)
		-- highlight('@text.todo', 15, 18)
		highlight('@text.underline', 11, 18, {'underline'})
		highlight('@text.uri', 15, 18, {'underline'})
		highlight('@type', 10, 18)
		-- highlight('@type.definition', 15, 18)
		highlight('@type.builtin', 5, 18)
		highlight('@variable', 5, 18)
		highlight('@variable.builtin', 5, 18)
		highlight('treesittercontext', 18, 2)

		-- neovim
		highlight('NvimInternalError', 1, 9)
		highlight('NormalFloat', 6, 17)
		highlight('FloatBorder', 17, 17)
		highlight('NormalNC', 6, 1)
		highlight('TermCursor', 1, 5)
		highlight('TermCursorNC', 1, 5)

		-- statusline/winbar
		highlight('StatusLine', 4, 1)
		highlight('StatusLineNC', 3, 1)
		highlight('StatusReplace', 1, 9)
		highlight('StatusInsert', 1, 13)
		highlight('StatusVisual', 1, 15)
		highlight('StatusTerminal', 1, 12)
		highlight('StatusLineDiagnosticWarn', 15, 1, {'bold'})
		highlight('StatusLineDiagnosticError', 9, 1, {'bold'})
		highlight('WinBar', 20, 1, {'bold'})
		highlight('StatusPosition', 20, 1, {'bold'})
		highlight('StatusNormal', 20, 1, {'underline'})
		highlight('StatusCommand', 20, 1, {'underline'})

		-- vimhelp
		link("helpHyperTextJump", "Function")
		link("helpSpecial", "Boolean")
		link("helpHeadline", "TSTitle")
		link("helpHeader", "Number")

		-- man.vim
		link("manHeader", "String")
		link("manSectionHeading", "helpHeadline")
		link("manSubHeading", "helpHeader")
		link("manOptionDesc", "helpSpecial")

		-- telescope
		highlight('TelescopeBorder', 17, 17)
		highlight('TelescopePromptBorder', 3, 3)
		highlight('TelescopePromptNormal', 6, 3)
		highlight('TelescopePromptPrefix', 9, 3)
		highlight('TelescopeNormal', 18, 17)
		highlight('TelescopePreviewTitle', 3, 12)
		highlight('TelescopePromptTitle', 3, 9)
		highlight('TelescopeResultsTitle', 17, 17)
		highlight('TelescopeSelection', 18, 3)
		highlight('TelescopePreviewLine', 18, 2)

		-- notify
		highlight('NotifyERRORBorder', 9, 18)
		highlight('NotifyWARNBorder', 16, 18)
		highlight('NotifyINFOBorder', 6, 18)
		highlight('NotifyDEBUGBorder', 14, 18)
		highlight('NotifyTRACEBorder', 14, 18)
		highlight('NotifyERRORIcon', 9, 18)
		highlight('NotifyWARNIcon', 16, 18)
		highlight('NotifyINFOIcon', 6, 18)
		highlight('NotifyDEBUGIcon', 14, 18)
		highlight('NotifyTRACEIcon', 14, 18)
		highlight('NotifyERRORTitle', 9, 18)
		highlight('NotifyWARNTitle', 16, 18)
		highlight('NotifyINFOTitle', 6, 18)
		highlight('NotifyDEBUGTitle', 14, 18)
		highlight('NotifyTRACETitle', 14, 18)

		-- cmp
		highlight('CmpItemAbbrMatchFuzzy', 5, 18)
		highlight('CmpItemKindInterface', 12, 18)
		highlight('CmpItemKindText', 9, 18)
		highlight('CmpItemKindVariable', 14, 18)
		highlight('CmpItemKindProperty', 11, 18)
		highlight('CmpItemKindKeyword', 10, 18)
		highlight('CmpItemKindUnit', 15, 18)
		highlight('CmpItemKindFunction', 13, 18)
		highlight('CmpItemKindMethod', 8, 18)
		highlight('CmpItemAbbrMatch', 6, 18, {'bold'})
		highlight('CmpItemAbbr', 20, 18, {'bold'})

		-- nvimtree
		highlight('NvimTreeImageFile', 13, 18)
		highlight('NvimTreeFolderIcon', 13, 18)
		highlight('NvimTreeWinSeperator', 1, 1)
		highlight('NvimTreeFolderName', 10, 18)
		highlight('NvimTreeIndentMarker', 3, 18)
		highlight('NvimTreeEmptyFolderName', 16, 18)
		highlight('NvimTreeOpenedFolderName', 16, 18)
		highlight('NvimTreeNormal', 5, 17)

		-- neogit
		highlight('NeogitBranch', 11, 18)
		highlight('NeogitRemote', 10, 18)
		highlight('NeogitDiffAddHighlight', 14, 3)
		highlight('NeogitDiffDeleteHighlight', 10, 3)
		highlight('NeogitDiffContextHighlight', 5, 2)
		highlight('NeogitHunkHeader', 5, 3)
		highlight('NeogitHunkHeaderHighlight', 5, 4)

		-- gitsigns
		highlight('GitSignsAdd', 9, 18)
		highlight('GitSignsChange', 10, 18)
		highlight('GitSignsDelete', 15, 18)

		-- parinfer
		highlight('Trailhighlight', 4, 18)

		-- hydra
		highlight('HydraRed', 13, 18)
		highlight('HydraBlue', 10, 18)
		highlight('HydraAmaranth', 11, 18)
		highlight('HydraTeal', 9, 18)
		highlight('HydraPink', 15, 18)
		highlight('HydraHint', 18, 17)

		-- dashboard
		highlight('DashboardShortCut', 11, 18)
		highlight('DashboardHeader', 16, 18)
		highlight('DashboardCenter', 15, 18)
		highlight('DashboardFooter', 9, 18)
	end
}

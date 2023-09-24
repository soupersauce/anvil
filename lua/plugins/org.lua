local M = {
	{ -- ORGMODE:
		'nvim-orgmode/orgmode',
		ft = 'org',
		opts = {
			org_hide_emphasis_markers = true,
			org_indent_mode = 'indent',
			org_tags_column = 0,
			org_agenda_files = '~/Documents/org/**/*',
			org_default_notes_file = '~/Documents/org/refile.org',
			-- Capture Templates
			org_capture_templates = {
				t = { description = 'Task', template = '* TODO %?\n %u' },
				s = 'ServiceNow',
				sc = {
					description = 'sCatalogTask',
					template = '** TODO %?%\n %T \n %^{Requested For}\n %^{extension}\n %^{Short Description}\n %^{Description}\n',
					target = '~/Documents/org/YCCD/yccdtodo.org',
					headline = 'Catalog Tasks',
				},
				si = {
					description = 'INC',
					template = '** TODO %?\n %T%',
					target = '~/Documents/org/YCCD/yccdtodo.org',
					headline = 'Incidents',
				},
			},

			org_todo_keywords = {
				'TODO',
				'INCIDENT',
				'ONHOLD',
				'|',
				'DELEGATED',
				'DONE',
			},
		},
		config = function(opts)
			local org = require('orgmode')
			org.setup(opts)
			org.setup_ts_grammar()
		end,
	},
	{ -- HEADLINES:
		'lukas-reineke/headlines.nvim',
		enabled = true,
		init = function()
			vim.cmd([[
      highlight Headline1 guibg=#883388
      highlight Headline2 guibg=#725c7b
      highlight Headline3 guibg=#5c846f
      highlight Headline4 guibg=#46ad62
      highlight Headline5 guibg=#30d556
      highlight Headline6 guibg=#1afe49
      highlight CodeBlock guibg=#1c1c1c
      highlight Dash guibg=#D19A66 gui=bold
      ]])
		end,
		opts = {
			org = {
				headline_highlights = {
					'Headline1',
					'Headline2',
					'Headline3',
					'Headline4',
					'Headline5',
					'Headline6',
					'Headline5',
					'Headline4',
					'Headline3',
					'Headline2',
					'Headline1',
				},
				fat_headline_upper_string = '▃',
				fat_headline_lower_string = 'ﮋ',
				fat_headlines = false,
			},
		},
	},
	{ -- BULLETS:
		'akinsho/org-bullets.nvim',
		enabled = true,
		opts = {
			concealcursor = true,
			indent = true,
		},
	},
	{ -- ORGWIKI:
		'ranjithshegde/orgWiki.nvim',
		config = function()
			local wiki = require('orgWiki')

			local wkpath = '~/Documents/org/wiki/'
			local diary = '~/Documents/org/diary/'

			wiki.setup {
				wiki_path = wkpath,
				diary_path = diary,
			}
		end,
	},
	-- TABLEMODE:
	'dhruvasagar/vim-table-mode',
}

return M

local org_ok, org = pcall(require, 'orgmode')
local wiki_ok, wiki = pcall(require, 'orgWiki')
local bull_ok, bullets = pcall(require, 'org-bullets')
local hl_ok, headlines = pcall(require, 'headlines')

if not org_ok then
	print('Org not ok')
	return
end

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

-- Directories
local agendas = '~/Documents/org/**/*'
local notes = '~/Documents/org/refile.org'
local wkpath = '~/Documents/org/wiki/'
local diary = '~/Documents/org/diary/'

-- Capture Templates
local templates = {
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
}

local todo_keywords = {
	'TODO',
	'INCIDENT',
	'ONHOLD',
	'|',
	'DELEGATED',
	'DONE',
}

org.setup {
	org_agenda_files = agendas,
	org_default_notes_file = notes,
	org_capture_templates = templates,
	org_todo_keywords = todo_keywords,
	org_hide_emphasis_markers = true,
	org_indent_mode = 'indent',
	org_tags_column = 0,
}

if hl_ok then
	headlines.setup {
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
	}
end

if bull_ok then
	bullets.setup {
		concealcursor = true,
		indent = true,
	}
end

if wiki_ok then
	wiki.setup {
		wiki_path = wkpath,
		diary_path = diary,
	}
else
	print('orgWiki not ok')
end

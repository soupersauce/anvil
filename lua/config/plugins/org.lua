local M = { -- orgmode
		'nvim-orgmode/orgmode',
    ft = 'org',
}

function M.config()
	local org = require('orgmode')
	-- Directories
	local agendas = '~/Documents/org/**/*'
	local notes = '~/Documents/org/refile.org'
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
org.setup_ts_grammar()
end
return M

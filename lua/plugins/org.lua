local org_ok, org = pcall(require, 'orgmode')
local wiki_ok, wiki = pcall(require, 'orgWiki')

if not org_ok then
	print('Org not ok')
	return
end

-- Directories
local agendas = '~/Documents/org/*'
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
		target = '~/Documents/org/tickets.org',
		headline = 'Catalog Tasks',
	},
	si = {
		description = 'INC',
		template = '** TODO %?\n %T%',
		target = '~/Documents/org/tickets.org',
		headline = 'Incidents',
	},
}

org.setup {
	org_agenda_files = agendas,
	org_default_notes_file = notes,
	org_capture_templates = templates,
}

if wiki_ok then
	wiki.setup {
		wiki_path = wkpath,
		diary_path = diary,
	}
else
	print('orgWiki not ok')
end

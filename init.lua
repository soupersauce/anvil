-- Base NeoVim configuration

-- Only load plugins when not running as root
if (vim.fn.exists('$SUDO_USER') == 0) then
  require('plugins')
end
--
-- Configure NeoVim
require('configuration')

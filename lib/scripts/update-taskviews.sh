#!/usr/bin/zsh

# Make sure we have a somewhat reasonable PATH
PATH="/usr/local/bin:/bin:/usr/bin:$PATH"

cd /u/apps/crantastic/current

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

rvm use 1.9.3-p547@crantastic

RAILS_ENV=production bundle exec rake crantastic:update_taskviews

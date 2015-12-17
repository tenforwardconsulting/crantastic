#!/bin/bash

# Make sure we have a somewhat reasonable PATH
PATH="/usr/local/bin:/bin:/usr/bin:$PATH"

cd /u/apps/crantastic/current

# Update to the latest available code
git pull

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

rvm use 1.9.3-p547@crantastic

RAILS_ENV=production bundle exec rake crantastic:update_packages

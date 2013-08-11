#!/bin/bash

#source /Users/christo/.rvm/scripts/rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
#eval "$(rbenv init -)"

#rvm list
rvm use 1.9.3@dyndns-host-update >/dev/null
ruby `dirname $0`/dyndns-host-update.rb

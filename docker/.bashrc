MY_APP_ROOT=/app

export MY_APP_ROOT

alias bash_prof="vi ~/.bash_profile"
alias bash_run="source ~/.bash_profile"

alias pull="git pull origin develop"
alias tt="touch $MY_APP_ROOT/tmp/restart.txt"
alias asset="cd $MY_APP_ROOT; rails assets:precompile RAILS_ENV=production"

alias log="sudo tail -f $MY_APP_ROOT/log/production.log"
alias console="spring stop; rails c -e production"

alias db_drop="rake db:drop RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
alias create="rake db:create RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
alias migrate="rake db:migrate RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
alias dump="rake db:schema:dump RAILS_ENV=production EISABLE_DATABASE_ENVIRONMENT_CHECK=1"
alias dbdbdb="db_drop; create; migrate"
alias credit="EDITOR=vi rails credentials:edit"
alias safety_check="ls -al | grep .env && ls -al config | grep master.key"

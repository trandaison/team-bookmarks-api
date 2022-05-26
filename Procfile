web: bundle exec rake db:migrate
web: bundle exec rake rswag:specs:swaggerize
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}

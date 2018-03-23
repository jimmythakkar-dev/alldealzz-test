# Admin Fandy
-------

###Using : 
*ruby-2.2.1*
*Rails 4.2.3*

###Project setup :

```
#!ruby
rake db:create db:migrate db:seed
```

###Note :

```
heroku pg:backups capture
curl -o latest.dump `heroku pg:backups public-url`

pg_restore --verbose --clean --no-acl --no-owner -h localhost -p 5432 -U postgres -d fandy_development_heroku latest.dump

pg_dump -h localhost -p 5432 -U postgres -d fandy_development_heroku > fandy_development_heroku.sql
psql -h localhost -p 5432 -U postgres -d fandy_development_heroku < fandy_development_heroku.sql

heroku restart -a alldealz
heroku logs -t
heroku run console
```
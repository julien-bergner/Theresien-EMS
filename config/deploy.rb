# include uberspacify base recipes
require 'uberspacify/base'

# comment this if you don't use MySQL
require 'uberspacify/mysql'

# the Uberspace server you are on
server 'lacerta.uberspace.de', :web, :app, :db, :primary => true

# your Uberspace username
set :user, 'theresa'

# a name for your app, [a-z0-9] should be safe, will be used for your gemset,
# databases, directories, etc.
set :application, 'TheresienEms2013'

# the repo where your code is hosted
set :shell, '/usr/bin/bash'
set :scm, :git
set :repository, 'git@github.com:julien-bergner/theresien-ems-2013.git'

# optional stuff from here

# By default, your app will be available in the root of your Uberspace. If you
# have your own domain set up, you can configure it here

# By default, uberspacify will generate a random port number for Passenger to
# listen on. This is fine, since only Apache will use it. Your app will always
# be available on port 80 and 443 from the outside. However, if you'd like to
# set this yourself, go ahead.
# set :passenger_port, 20019

# By default, Ruby Enterprise Edition 1.8.7 is used for Uberspace. If you
# prefer Ruby 1.9 or any other version, please refer to the RVM documentation
# at https://rvm.io/integration/capistrano/ and set this variable.
# set :rvm_ruby_string, 'ruby-2.0.0-p247@SesusoEmsDanceDiscounter'
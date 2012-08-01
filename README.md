[![Build Status](https://secure.travis-ci.org/darrendao/ringring.png?branch=master)](http://travis-ci.org/darrendao/ringring)

#RingRing
RingRing is a Rails webapp that allows organizations to manage their oncall lists. It has support for Twilio VoIP and allows teams to use just 1 oncall number for everyone. When the oncall number is called, the call will be redirected to whoever is oncall. If the oncall person doesn't pickup the phone, RingRing can retry and/or escalate the call to the team's manager.

##Requirements
* Ruby 1.8.7 or higher
* Rails 3.2.x

##Getting Started
* Check out the code to your server
* To install all the dependencies, run 

        bundle install
    
    
* Run DB migration and populate DB with seed data

        bundle exec rake db:migrate
        bundle exec rake db:seed
    
* Start the app

        rails server
    
* Browse to http://your_server:3000. Log in as admin/password
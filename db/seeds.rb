# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Initial usernames and roles
admin = Role.find_or_create_by_name('SuperAdmin')
Role.find_or_create_by_name('Moderator')
user = User.find_or_create_by_username('admin', :email => 'admin@darrendao.net', :password => 'password', :password_confirmation => 'password')
user.roles << admin
user.save


# Populate initial data for phone carrier info
#PhoneCarrier.create(:name => 'Verizon Wireless', :sms_gateway => 'vtext.com')
#PhoneCarrier.create(:name => 'T-Mobile USA', :sms_gateway => 'tmomail.net')


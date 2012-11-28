require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

CallList.blueprint do 
  name { "name #{sn}" }
  call_list_owners { [CallListOwner.make, CallListOwner.make] }
end

CallListOwner.blueprint do 
  user { User.make }
end

User.blueprint do
  email { "username#{sn}@example.com" }
  password { "password#{sn}" }
  sms_email { "sms@example.com" }
  time_zone { "Central Time (US & Canada)" }
  phone_number_info { PhoneNumberInfo.make(:number => "123456789", :user => object) }
end

OncallAssignment.blueprint do
  starts_at { Time.zone.now - 7 }
  ends_at { Time.zone.now + 7 }
  timezone_offset { 0 }
  assigned_by { 'test' }
end

OncallAssignmentsGen.blueprint do
  enable { true }
  cycle_day { 1 }
  cycle_time { Time.zone.parse("8:00") }
  timezone_offset { 0 }
end

PhoneNumberInfo.blueprint do
  
end

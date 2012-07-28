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
  phone_number_info { PhoneNumberInfo.make(:number => "123456789", :user => object) }
end

OncallAssignment.blueprint do
  starts_at { DateTime.now - 7 }
  ends_at { DateTime.now + 7 }
  timezone_offset { 0 }
end

PhoneNumberInfo.blueprint do
  
end

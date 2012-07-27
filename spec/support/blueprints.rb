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
end

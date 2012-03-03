module UsersHelper
  def setup_user(user)
    user.phone_number_info ||= PhoneNumberInfo.new
    return user
  end
end

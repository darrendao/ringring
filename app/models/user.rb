class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_one :phone_number_info
  accepts_nested_attributes_for :phone_number_info, :allow_destroy => true,
                                                    :reject_if => proc{|attrs| attrs[:number].nil?}

  has_many :oncall_assignments, :dependent => :destroy
  has_many :call_escalations, :dependent => :destroy

  has_many :call_list_owners, :dependent => :destroy
  has_many :call_list, :through => :call_list_owners, :source => :call_list
  has_many :call_list_memberships, :dependent => :destroy
  has_many :vacations, :dependent => :destroy

  before_save :set_username_from_email

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable,
  #devise :ldap_authenticatable,
  devise AppConfig.authentication_method, :trackable, :validatable

  #attr_accessor :login


  # Setup accessible (or protected) attributes for your model
  attr_accessible :time_zone, :email, :password, :password_confirmation, :remember_me, :username, :first_name, :last_name, :role_ids, :phonetic_name, :phone_number_info_attributes, :sms_email

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:email)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end

  def roles_names
    roles.map{|role|role.name}.join(", ") if roles
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def name_to_greet
    phonetic_name.blank? ? (full_name.empty? ? username : full_name) : phonetic_name
  end

  def phone_number
    ret = nil
    if phone_number_info
      ret = phone_number_info.number
    end
    ret
  end

  def old_sms_email
    ret = phone_number_info ? phone_number_info.sms_email : nil
  end

  def on_vacation?
    now = Time.zone.now
    vacations.each do |vacation|
      return true if vacation.starts_at <= now && now <= vacation.ends_at
    end
    false
  end

  private
  def set_username_from_email
    if self.email && self.username.nil?
      self.username = self.email.split("@")[0]
    end
  end
end

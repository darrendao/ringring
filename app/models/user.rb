class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  belongs_to :call_escalation
#  acts_as_list :scope => :call_escalation

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable,
  #devise :ldap_authenticatable,
  devise AppConfig.authentication_method,
         :recoverable, :rememberable, :trackable, :validatable

  #attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :first_name, :last_name, :phone_number, :login, :role_ids
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :first_name, :last_name, :phone_number, :role_ids, :phonetic_name

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
    phonetic_name || full_name || username
  end
end

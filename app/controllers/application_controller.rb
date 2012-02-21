class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  protect_from_forgery


  private
  def force_ssl
    if !request.ssl?
      redirect_to :protocol => 'https'
    end
  end
end

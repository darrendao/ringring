class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { render :template => "shared/forbidden", :status => 403 }
      format.js { render :js => "alert('You do not have permission to do that')" }
    end
  end
  protect_from_forgery

  private
  def force_ssl
    if !request.ssl?
      redirect_to :protocol => 'https'
    end
  end
end

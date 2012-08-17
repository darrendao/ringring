module ActiveSupport
  class TimeWithZone
    def zone=(new_zone = ::Time.zone)
      # Reinitialize with the new zone and the local time
      initialize(nil, ::Time.__send__(:get_zone, new_zone), time)
    end
  end
end

class ApplicationController < ActionController::Base
  before_filter :set_timezone

  def set_timezone
    Time.zone = current_user.time_zone if current_user
  end

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

  def set_tz_offset(attr)
    if params[attr] && params[attr][:starts_at]
      params[attr][:timezone_offset] = DateTime.parse(params[attr][:starts_at]).utc_offset
    end
  end
end

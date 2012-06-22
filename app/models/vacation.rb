class Vacation < ActiveRecord::Base
  belongs_to :user

  def as_json(options = {})
    {
      :id => "#{self.id}_vacation",
      :title => self.user.username + " on vacation",
      :description => "description",
      :start => starts_at.iso8601,
      :end => ends_at.iso8601,
      :allDay => false,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.user_vacation_path(self.user, id)
    }
  end
end

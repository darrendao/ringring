class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @call_lists = []
    (current_user.call_list_owners | current_user.call_list_memberships).each do |clo|
      @call_lists << clo.call_list
    end

    @call_lists.uniq!
    @call_lists.compact!

    @oncall_assignments = current_user.oncall_assignments.where("ends_at > ?", DateTime.now).order('ends_at')
  end
end

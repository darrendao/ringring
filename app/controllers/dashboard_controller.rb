class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @call_lists = []
    (current_user.call_list_owners | current_user.call_list_memberships).each do |clo|
      @call_lists << clo.call_list
    end

    @call_lists.uniq!
    @call_lists.compact!
    @call_lists.sort!{|x,y| x.name <=> y.name}

    @oncall_assignments = current_user.oncall_assignments.where("ends_at > ?", Time.zone.now).order('ends_at')
  end
end

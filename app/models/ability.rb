class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user

    if user.role? :super_admin
      can :manage, :all
    elsif user.role? :moderator
      can :manage, CallEscalation
    else
      # User can create new call_list, and edit call_lists that they own
      can :create, CallList
      can :manage, CallList do |call_list|
        call_list.owners.include? user
      end
      can :manage, CallEscalation do |call_escalation|
        call_escalation.call_list.owners.include? user
      end

      # User can sort call_escalations that they belong to 
      can :sort, CallEscalation do |call_escalation|
        call_escalation.call_list.escalations.include? user
      end

      # User can add and remove themselves to oncall_assignments and call_escalations
      can :manage, OncallAssignment do |oncall_assignment|
        oncall_assignment.user == user
      end
      can :manage, CallEscalation do |call_escalation|
        call_escalation.user == user
      end
     
      # User can update their own account
      can :update, User, :id => user.id

      # User can read everything
      can :read, :all
    end
  end
end

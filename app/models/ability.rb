class Ability
  include CanCan::Ability

  def initialize(user)
    if !user.nil? && (user.has_role? :admin)
        can :manage, :all
    #elsif user.has_role? :beautystar
    else
        can :read, :all
        can :manage, Comment, :id => Comment.with_role(:author, user).pluck("comments.id") if !user.nil?
        can :manage, Picture, :id => Picture.with_role(:author, user).pluck("Pictures.id") if !user.nil? && (user.has_role? :beautystar)
        
        can :create, Tutorial if !user.nil? && (user.has_role? :beautystar)
        can :manage, Tutorial, :id => Tutorial.with_role(:author, user).pluck("tutorials.id")  if !user.nil? && (user.has_role? :beautystar)
        
        can :create, Beautyclass if !user.nil? && (user.has_role? :beautystar)
        can :manage, Beautyclass, :id => Beautyclass.with_role(:author, user).pluck("beautyclasses.id")  if !user.nil? && (user.has_role? :beautystar)

        can :manage, User, :id => user.id if !user.nil? 
        can :manage, Beautystar, :id => user.profile.id if !user.nil? && (user.has_role? :beautystar)
        can :manage, Member, :id => user.profile.id if !user.nil? && (user.has_role? :member)

    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end

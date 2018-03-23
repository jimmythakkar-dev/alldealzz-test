class Ability
  include CanCan::Ability

  def initialize(user)
    can [:new, :create], [Store]
    can [:new, :create], [Mall]
    can [:index], :dashboard
    can [:api_json_lookup], :app_helper

    if user
      if user.super_admin?
        can :manage, :all

      elsif user.stores_admin?
        can :manage, [User], id: user.id
        can :manage, [Deal, PremiumNotification, Store, Mall]
        can [:manage], Quotum

      elsif user.sales_admin?
        # can :manage, [User], id: user.id
        # can :manage, [Deal, PremiumNotification, Store, Mall,Quotum] 
        # can :manage, [SalesUser]
        can :manage, :all
        cannot :index, :notifications 

      elsif user.store_admin?
        store = user.store

        can :manage, [User], id: user.id
        can :manage, [Deal, PremiumNotification], 
          store_id: store.id
        can [:read, :update, :dashboard, :analytics, :credentials, 
          :analytics_chart], [Store], user_id: user.id
        cannot :index, [Store]
      elsif user.mall_admin?
        mall = user.mall
        stores = mall.stores

        can :manage, [User], id: user.id
        can :manage, [Deal, PremiumNotification], {store: {manageable: mall} }
        can [:index, :read, :update, :dashboard, :analytics, :credentials, 
          :analytics_chart, :change_status], [Store], manageable_id: mall.id
        can [:read, :update, :dashboard, :credentials],
          [Mall], user_id: user.id
        cannot :index, [Mall]
      else
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
      # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    
    else
    end
  end
end

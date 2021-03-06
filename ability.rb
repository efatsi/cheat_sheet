class Ability
  include CanCan::Ability

  def initialize(user)
  
		user ||= User.new # guest user (not logged in)
		
		if user.role? :admin
			can :manage, :all
		elsif user.role? :manager
			can :update, OTHER do |b|
				b.id == user.other_id
			end
		else
		 	can :read, :all
		end
  end
  
end

class AdministratorAbility
  include CanCan::Ability

  def initialize
    can :manage, :all
    cannot [:create, :update], Bio
    cannot [:create, :update], Book
  end
end

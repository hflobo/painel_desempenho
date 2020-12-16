class DashboardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def update?
    record.user == user
  end

  def show?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end

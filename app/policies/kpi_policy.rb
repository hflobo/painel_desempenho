class KpiPolicy < ApplicationPolicy
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
    record.dashboard.user == user
  end

  def show?
    record.dashboard.user == user
  end

  def destroy?
    record.dashboard.user == user
  end
end

class AlertPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def update?
    true
  end

  def alerts_sent?
    true
  end

  def destroy?
    record.criador == user
  end
end

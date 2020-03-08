module BudgetHelper
  def percentage_of_maxbudget(budget_item)
    Integer(
      (budget_item.amount.to_f / budget_item.camp.maxbudget_realcurrency).round(2)*100
    )
  end

  def sum_of_budget(camp)
    camp.budget_items.pluck(:amount).compact.sum
  end

  def percentage_of_maxbudget_for_dream(camp)
    ((sum_of_budget(@camp).to_f / camp.maxbudget_realcurrency).round(3)*100).to_i
  end

  def divide_for_percentage(sum, divider)
    ((sum.to_f / divider).round(2)*100).to_i
  end
end

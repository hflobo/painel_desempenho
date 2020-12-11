class ChangePaiIndicatorIdToIndicator < ActiveRecord::Migration[6.0]
  def change
    change_column_null :indicators, :pai_indicator_id, true
  end
end

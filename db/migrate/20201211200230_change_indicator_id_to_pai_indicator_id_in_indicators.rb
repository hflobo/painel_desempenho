class ChangeIndicatorIdToPaiIndicatorIdInIndicators < ActiveRecord::Migration[6.0]
  def change
    rename_column :indicators, :indicator_id, :pai_indicator_id
  end
end

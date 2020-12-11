class RemoveIndexPaiIndicatorIdOnIndicators < ActiveRecord::Migration[6.0]
  def change
    remove_index :indicators, name: "index_indicators_on_pai_indicator_id"
  end
end

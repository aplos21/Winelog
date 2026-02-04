class RemoveRegionIdFromWines < ActiveRecord::Migration[8.1]
  def change
    remove_column :wines, :region_id, :bigint
  end
end

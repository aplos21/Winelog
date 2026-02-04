class AddLocalToWines < ActiveRecord::Migration[8.1]
  def change
    add_column :wines, :local, :string
  end
end

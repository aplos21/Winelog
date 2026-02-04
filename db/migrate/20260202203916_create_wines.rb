class CreateWines < ActiveRecord::Migration[8.1]
  def change
    create_table :wines do |t|
      t.references :user, null: false, foreign_key: true
      t.references :region, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :rating

      t.timestamps
    end
  end
end

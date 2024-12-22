class CreateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :sections do |t|
      t.string :name, null: false
      t.string :dimensions, null: false
      t.timestamps
    end
  end
end

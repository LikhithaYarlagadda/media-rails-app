class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :media_url
      # t.references :section, foreign_key: true # Comment this out
      t.references :approved_by, foreign_key: { to_table: :users }
      t.string :status, default: 'Pending', null: false
      t.timestamps
    end
  end
end

class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.references :parent_comment, foreign_key: { to_table: :comments } # For nested comments
      t.timestamps
    end
  end
end

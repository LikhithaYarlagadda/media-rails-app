class CreateArticleUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :article_users do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false # 'Primary', 'Contributor'
      t.timestamps
    end
  end
end

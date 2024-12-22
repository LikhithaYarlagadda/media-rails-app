class AddSectionToArticles < ActiveRecord::Migration[7.2]
  def change
    add_reference :articles, :section, null: false, foreign_key: true
  end
end

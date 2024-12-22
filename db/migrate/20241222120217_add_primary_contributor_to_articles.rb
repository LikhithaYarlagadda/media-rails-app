class AddPrimaryContributorToArticles < ActiveRecord::Migration[7.2]
  def change
    add_reference :articles, :primary_contributor, foreign_key: { to_table: :users }, index: true
  end
end

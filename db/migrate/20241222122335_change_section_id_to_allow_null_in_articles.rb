class ChangeSectionIdToAllowNullInArticles < ActiveRecord::Migration[7.2]
  def change
    change_column_null :articles, :section_id, true
  end
end

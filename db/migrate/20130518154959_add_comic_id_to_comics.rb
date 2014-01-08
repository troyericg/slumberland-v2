class AddComicIdToComics < ActiveRecord::Migration
  def change
    add_column :comics, :comic_id, :integer
  end
end

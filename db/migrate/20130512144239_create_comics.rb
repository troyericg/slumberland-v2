class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.string :title
      t.string :author
      t.string :date_display
      t.date :date_published
      t.text :summary
      t.text :characters
      t.text :contents
      t.string :notes
      t.boolean :transcript
      t.text :transcript_text
      t.string :img
      t.string :img_thumb
      t.string :img_link

      t.timestamps
    end
  end
end

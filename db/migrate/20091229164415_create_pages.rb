class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :title_slug
      t.text :body
      t.text :body_html
      
      t.timestamps
    end
    
    add_index :pages, :title_slug
  end

  def self.down
    remove_index :pages, :title_slug
    drop_table :pages
  end
end

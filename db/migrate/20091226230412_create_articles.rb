class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :title_slug
      t.text :body
      t.text :body_html
      
      t.timestamps
    end
    
    add_index :articles, :title_slug
  end

  def self.down
    remove_index :articles, :title_slug
    
    drop_table :articles
  end
end

class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.text :body_html
      
      t.timestamps
    end
    
    add_index :articles, :slug
  end

  def self.down
    remove_index :articles, :slug
    
    drop_table :articles
  end
end

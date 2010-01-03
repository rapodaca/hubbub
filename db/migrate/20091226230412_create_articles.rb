class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :title_slug
      t.text :body
      t.text :body_html
      t.integer :user_id
      
      t.timestamps
    end
    
    add_index :articles, :title_slug
    add_index :articles, :user_id
  end

  def self.down
    remove_index :articles, :title_slug
    remove_index :articles, :user_id
    
    drop_table :articles
  end
end

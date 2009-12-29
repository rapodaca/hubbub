class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.text :body_html
      
      t.timestamps
    end
    
    add_index :pages, :slug
  end

  def self.down
    remove_index :pages, :slug
    drop_table :pages
  end
end

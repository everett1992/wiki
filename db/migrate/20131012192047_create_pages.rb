class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
    end
  end
end

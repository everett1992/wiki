class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :from
      t.references :to
    end
  end
end

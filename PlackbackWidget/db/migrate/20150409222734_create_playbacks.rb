class CreatePlaybacks < ActiveRecord::Migration
  def change
    create_table :playbacks do |t|

      t.timestamps
    end
  end
end

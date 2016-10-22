class QueueJobForChat < ActiveRecord::Migration
  def change
    create_table :chatjobs do |t|
    	t.integer :message_id

      t.timestamps
    end
  end
end

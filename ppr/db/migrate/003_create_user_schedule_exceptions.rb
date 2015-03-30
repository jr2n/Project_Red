class CreateUserScheduleExceptions < ActiveRecord::Migration
  def change
    create_table :user_schedule_exceptions do |t|
      t.references :user
      t.timestamp :time_start
      t.timestamp :time_end
      t.text :comments
    end
    add_index :user_schedule_exceptions, :user_id
  end
end

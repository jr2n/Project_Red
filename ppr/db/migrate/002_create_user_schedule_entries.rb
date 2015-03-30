class CreateUserScheduleEntries < ActiveRecord::Migration
  def change
    create_table :user_schedule_entries, :id => false do |t|
      t.references :user
      t.integer :days_of_week
      t.integer :hours
    end
    add_index :user_schedule_entries, :user_id
  end
end

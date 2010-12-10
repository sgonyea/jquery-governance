class CreateActiveMemberships < ActiveRecord::Migration
  def up
    create_table :active_memberships do |t|
      t.belongs_to :member
      t.timestamp :start_time, :end_time

      t.timestamps
    end
  end

  def down
    drop_table :active_memberships
  end
end

class ChangeStatusToBeIntInTasks < ActiveRecord::Migration[5.1]
  def up
    change_column :tasks, :status, :integer
  end

  def down
    change_column :tasks, :status, :string
  end
end

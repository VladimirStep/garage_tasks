class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { in: 2..50 }
  
  def reorder_tasks(new_order)
    new_order.each_with_index {|id, index| self.tasks&.find(id.to_i)&.set_list_position(index + 1)}
  end
end

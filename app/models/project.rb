class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { in: 2..50 }

  scope :tasks_count_desc, -> { order(tasks_count: :desc).pluck(:tasks_count) }
  scope :tasks_count_order_by_project_name, -> { order(:name).pluck(:tasks_count) }
  scope :containing_letter_shows_tasks_count, -> (char) { where('name LIKE ?', ('%' + char + '%')).pluck(:name, :tasks_count) }
  scope :over_ten_completed_tasks, -> { joins(:tasks)
                                            .where('tasks.status = ?', 'completed')
                                            .group(:name)
                                            .having('COUNT(*) > ?', 10)
                                            .order(:id)
                                            .count }
  
  def reorder_tasks(new_order)
    new_order.each_with_index {|id, index| self.tasks&.find(id.to_i)&.set_list_position(index + 1)}
  end
end

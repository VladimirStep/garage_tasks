class Task < ApplicationRecord
  belongs_to :project, counter_cache: true

  validates :name, presence: true, length: { in: 2..50 }
  validates :priority, presence: true, numericality: { only_integer: true }, on: :update
  validates :status, presence: true, inclusion: { in: %w(new in-progress completed) }, on: :update

  before_create :set_defaults
  after_destroy :update_priority

  def set_defaults
    self.status = 'new'
    self.priority = self.project.tasks.count
  end

  def update_priority
    self.project&.tasks.find_each do |task|
      task.update_attribute(:priority, task.priority -= 1)
    end
  end
end

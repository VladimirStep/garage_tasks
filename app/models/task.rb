class Task < ApplicationRecord
  enum status: ['new task', 'in-progress', 'completed']

  belongs_to :project, counter_cache: true
  acts_as_list scope: :project, column: :priority

  validates :name, presence: true, length: { in: 2..50 }
  validates :priority, presence: true,
                       numericality: { only_integer: true },
                       on: :update
  validates :status, presence: true, on: :update

  before_create :set_defaults
  before_destroy :check_status

  scope :statuses_ordered_asc, -> { statuses.keys.sort }
  scope :begins_with_letter, ->(char) { where('name LIKE ?', (char + '%')) }
  scope :with_duplicate_names,
        lambda {
          select(:name).group(:name).having('COUNT(*) > ?', 1)
                       .order(:name).pluck(:name)
        }
  scope :exact_match_from_project,
        lambda { |project_name|
          joins(:project).where('projects.name = ?', project_name)
                         .group(:name, :status).having('COUNT(*) > ?', 1)
                         .order('COUNT(*)').count.to_a
        }

  def set_defaults
    self.status = 'new task'
  end

  def check_status
    return unless status == 'in-progress'
    errors.add(:base, :task_is_not_completed,
               message: 'Task can not be deleted until it is in progress')
    throw(:abort)
  end
end

class Task < ApplicationRecord
  belongs_to :project, counter_cache: true
  acts_as_list scope: :project, column: :priority

  validates :name, presence: true, length: { in: 2..50 }
  validates :priority, presence: true, numericality: { only_integer: true }, on: :update
  validates :status, presence: true, inclusion: { in: %w(new in-progress completed) }, on: :update

  before_create :set_defaults
  before_destroy :check_status

  scope :statuses_ordered_asc, -> { select(:status).distinct.order(status: :asc).pluck(:status) }
  scope :begins_with_letter, -> (char) { where('name LIKE ?', (char + '%')) }
  scope :with_duplicate_names, -> { select(:name).group(:name).having('COUNT(*) > ?', 1).order(:name).pluck(:name) }
  scope :exact_match_from_project, -> (project_name) { joins(:project)
                                                           .where('projects.name = ?', project_name)
                                                           .group(:name, :status)
                                                           .having('COUNT(*) > ?', 1)
                                                           .order('COUNT(*)')
                                                           .count
                                                           .to_a }

  def set_defaults
    self.status = 'new'
  end

  def check_status
    unless self.status == 'completed'
      errors.add(:base, :task_is_not_completed, message: 'Task can not be deleted until it is not completed')
      throw(:abort)
    end
  end
end

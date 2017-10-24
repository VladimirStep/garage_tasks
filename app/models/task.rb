class Task < ApplicationRecord
  belongs_to :project, counter_cache: true
  acts_as_list scope: :project, column: :priority

  validates :name, presence: true, length: { in: 2..50 }
  validates :priority, presence: true, numericality: { only_integer: true }, on: :update
  validates :status, presence: true, inclusion: { in: %w(new in-progress completed) }, on: :update

  before_create :set_defaults

  def set_defaults
    self.status = 'new'
  end
end

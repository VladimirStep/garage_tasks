class Task < ApplicationRecord
  belongs_to :project, counter_cache: true

  validates :name, presence: true, length: { in: 2..50 }
  validates :priority, presence: true, numericality: { only_integer: true }
  validates :status, presence: true, inclusion: { in: %w(new in-progress completed) }
end

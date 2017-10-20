class Project < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { in: 2..100 }
end

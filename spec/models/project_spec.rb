require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    expect(build(:project)).to be_valid
  end

  let(:project) { create(:project) }

  subject { project }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2) }
    it { should validate_length_of(:name).is_at_most(50) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks) }
    it { should have_db_column(:tasks_count).of_type(:integer) }
  end

  describe 'scopes' do

  end

  # it 'pp' do
  #   puts project.user.inspect
  #   puts project.inspect
  # end
end

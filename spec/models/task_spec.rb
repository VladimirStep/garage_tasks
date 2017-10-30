require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'has a valid factory' do
    expect(build(:task)).to be_valid
  end

  let(:task) { build(:task) }

  subject { task }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_presence_of(:status).on(:update) }
    it { should validate_inclusion_of(:status).in_array(%w(new in-progress completed)).on(:update) }
    it { should validate_presence_of(:priority).on(:update) }
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should have_db_column(:priority).of_type(:integer) }
  end


end

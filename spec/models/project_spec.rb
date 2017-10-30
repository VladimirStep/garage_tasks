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
    let(:current_user) { create(:user) }
    it '.tasks_count_desc get the count fo all tasks in each project, order by tasks count desc' do
      project1 = create(:project, user: current_user)
      project2 = create(:project, user: current_user)
      project3 = create(:project, user: current_user)

      2.times { create(:task, project: project1) }
      5.times { create(:task, project: project2) }
      9.times { create(:task, project: project3) }

      expect(Project.tasks_count_desc).to eq([9,5,2])
    end

    it '.tasks_count_order_by_project_name get the count fo all tasks in each project, order by project name' do
      project1 = create(:project, user: current_user, name: 'BBB')
      project2 = create(:project, user: current_user, name: 'AAA')
      project3 = create(:project, user: current_user, name: 'CCC')

      2.times { create(:task, project: project1) }
      5.times { create(:task, project: project2) }
      9.times { create(:task, project: project3) }

      expect(Project.tasks_count_order_by_project_name).to eq([5,2,9])
    end

    it '.containing_letter_shows_tasks_count get the list of all projects containing the letter "x" in the middle of the name, and show the tasks count near each project' do
      project1 = create(:project, user: current_user, name: 'ABCD')
      project2 = create(:project, user: current_user, name: 'EFGH')
      project3 = create(:project, user: current_user, name: 'ACFH')

      2.times { create(:task, project: project1) }
      5.times { create(:task, project: project2) }
      9.times { create(:task, project: project3) }

      expect(Project.containing_letter_shows_tasks_count('C')).to contain_exactly(['ABCD', 2], ['ACFH', 9])
    end

    it '.over_ten_completed_tasks get the list of project names having more then 10 tasks in status "completed", order by project_id' do
      project1 = create(:project, user: current_user, name: 'Project 1')
      project2 = create(:project, user: current_user, name: 'Project 2')
      project3 = create(:project, user: current_user, name: 'Project 3')

      25.times { create(:task, project: project1) }
      15.times { create(:task, project: project2) }
      30.times { create(:task, project: project3) }

      project1_task_ids = project1.tasks.pluck(:id).sample(16)
      project2_task_ids = project2.tasks.pluck(:id).sample(8)
      project3_task_ids = project3.tasks.pluck(:id).sample(11)

      sample_ids = project1_task_ids.concat(project2_task_ids).concat(project3_task_ids)

      Task.where(id: sample_ids).update_all(status: 'completed')

      expect(Project.over_ten_completed_tasks).to eq({ project1.name => 16, project3.name => 11 })
    end
  end
end

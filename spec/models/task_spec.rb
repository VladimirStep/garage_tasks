# frozen_string_literal: true

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
    it { should validate_presence_of(:priority).on(:update) }
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should have_db_column(:priority).of_type(:integer) }
  end

  describe 'scopes' do
    it '.statuses_ordered_asc get all statuses, not repeating,'\
        ' alphabetically ordered' do
      20.times { create(:task) }

      all_ids = Task.ids
      ids_for_completed = all_ids.sample(6)
      ids_for_inprogress = (all_ids - ids_for_completed).sample(7)

      Task.where(id: ids_for_completed).update_all(status: 'completed')
      Task.where(id: ids_for_inprogress).update_all(status: 'in-progress')

      expect(Task.statuses_ordered_asc)
        .to eq(['completed', 'in-progress', 'new task'])
    end

    it '.begins_with_letter get the tasks for all projects'\
        ' having the name beginning with "x" letter' do
      20.times { create(:task) }

      sample_task_ids = Task.ids.sample(5)
      Task.where(id: sample_task_ids).update_all(name: 'My task')

      expect(Task.begins_with_letter('M'))
        .to match_array(Task.find(sample_task_ids))
    end

    it '.with_duplicate_names get the list of tasks with duplicate names,'\
        ' order alphabetically' do
      20.times { create(:task) }

      all_ids = Task.ids
      ids_for_dup1 = all_ids.sample(3)
      ids_for_dup2 = (all_ids - ids_for_dup1).sample(4)
      ids_for_dup3 = (all_ids - ids_for_dup1 - ids_for_dup2).sample(2)

      Task.where(id: ids_for_dup1).update_all(name: 'Task name 3')
      Task.where(id: ids_for_dup2).update_all(name: 'Task name 1')
      Task.where(id: ids_for_dup3).update_all(name: 'Task name 2')

      expect(Task.with_duplicate_names)
        .to eq(['Task name 1', 'Task name 2', 'Task name 3'])
    end

    it '.exact_match_from_project get the list of tasks having several'\
        ' exact matches of both name and status from the project "x"'\
        ' order by matches count' do
      project1 = create(:project, name: 'Project 1')
      project2 = create(:project, name: 'Project 2')
      project3 = create(:project, name: 'Garage')

      25.times { create(:task, project: project1) }
      15.times { create(:task, project: project2) }
      30.times { create(:task, project: project3) }

      Project.find_each do |project|
        all_ids = project.tasks.ids
        ids_1 = all_ids.sample(4)
        ids_2 = (all_ids - ids_1).sample(2)

        Task.where(id: ids_1).update_all(name: 'Task name 1',
                                         status: 'in-progress')
        Task.where(id: ids_2).update_all(name: 'Task name 2',
                                         status: 'completed')
      end

      expect(Task.exact_match_from_project('Garage'))
        .to eq([
                 [['Task name 2', 'completed'], 2],
                 [['Task name 1', 'in-progress'], 4]
               ])
    end
  end
end

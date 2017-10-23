class TasksController < ApplicationController
  before_action :set_project

  def create
    @task = @project.tasks.create(task_params)
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:name)
  end
end

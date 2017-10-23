class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, except: [:create]

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
    @task.destroy
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name)
  end
end

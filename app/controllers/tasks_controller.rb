class TasksController < ApplicationController
  before_action :set_projects
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
    respond_to do |format|
      format.html { render 'projects/index' }
      format.js
    end
  end

  def update
    @task.update_attributes(task_params)
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end

  private

  def set_projects
    @projects = current_user.projects
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :status, :deadline)
  end
end

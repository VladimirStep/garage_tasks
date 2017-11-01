class TasksController < ApplicationController
  before_action :set_projects
  before_action :set_project
  before_action :set_task, except: [:create, :reorder]

  def create
    @task = @project.tasks.create(task_params)
    if @task.persisted?
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js
      end
    else
      respond_to do |format|
        format.html do
          redirect_to projects_path,
                      alert: @task.errors.full_messages.join("\n")
        end
        format.js { render_errors_for(@task) }
      end
    end
  end

  def show
    respond_to do |format|
      format.html { render 'projects/index' }
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
    if @task.update_attributes(task_params)
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js
      end
    else
      respond_to do |format|
        format.html do
          redirect_to projects_path,
                      alert: @task.errors.full_messages.join("\n")
        end
        format.js { render_errors_for(@task) }
      end
    end
  end

  def destroy
    if @task.destroy
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js
      end
    else
      respond_to do |format|
        format.html do
          redirect_to projects_path,
                      alert: @task.errors.full_messages.join("\n")
        end
        format.js { render_errors_for(@task) }
      end
    end
  end

  def up
    @replaced_task = @task.higher_item
    if @task.move_higher && @replaced_task
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js { render 'move' }
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js { render body: nil }
      end
    end
  end

  def down
    @replaced_task = @task.lower_item
    if @task.move_lower && @replaced_task
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js { render 'move' }
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js { render body: nil }
      end
    end
  end

  def reorder
    @project.reorder_tasks(params[:order])
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js { render body: nil }
    end
  end

  private

  def set_projects
    @projects = current_user.projects
  end

  def set_project
    @project = @projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :status, :deadline)
  end
end

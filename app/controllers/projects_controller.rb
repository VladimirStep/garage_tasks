class ProjectsController < ApplicationController
  before_action :set_projects
  before_action :set_project, except: [:index, :create]

  def index
  end

  def create
    @project = @projects.create(name: 'New Project')
    if @project.persisted?
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_path, alert: @project.errors.full_messages.join("\n") }
        format.js { render_errors_for(@project) }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'index' }
      format.js
    end
  end

  def update
    if @project.update_attributes(project_params)
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_path, alert: @project.errors.full_messages.join("\n") }
        format.js { render_errors_for(@project) }
      end
    end
  end

  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_path, alert: @project.errors.full_messages.join("\n") }
        format.js { render_errors_for(@project) }
      end
    end
  end

  private

  def set_projects
    @projects = current_user.projects
  end

  def set_project
    @project = @projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end
end

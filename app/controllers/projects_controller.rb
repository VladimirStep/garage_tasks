class ProjectsController < ApplicationController
  before_action :set_projects, only: [:index, :edit]
  before_action :set_project, except: [:index, :create]

  def index
  end

  def create
    if @project = current_user.projects.create(name: 'New Project')
      respond_to do |format|
        format.html { redirect_to projects_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_path, alert: @project.errors.full_messages.join("\n") }
        format.js { render 'shared/errors', locals: { item: @project } }
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
        format.js { render 'shared/errors', locals: { item: @project } }
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
        format.js { render 'shared/errors', locals: { item: @project } }
      end
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def set_projects
    @projects = current_user.projects
  end

  def project_params
    params.require(:project).permit(:name)
  end
end

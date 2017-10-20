class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def create
    @project = current_user.projects.create(name: 'New Project')
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end
end

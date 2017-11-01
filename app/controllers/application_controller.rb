class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def render_errors_for(current_instance)
    render 'shared/errors', locals: { item: current_instance }
  end
end

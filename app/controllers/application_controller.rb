class ApplicationController < ActionController::API
  include Graphiti::Rails::Responders

  # Mock authentication
  def authenticate_user!
    render json: { errors: ['Unauthorized'] }, status: 401 unless current_user
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end

  def respond_with_resource(resource_class, model)
    resource_class.new.with_context(current_user: current_user) do
      if model.respond_to?(:to_ary) || model.is_a?(ActiveRecord::Relation)
        respond_with resource_class.all(params)
      else
        respond_with resource_class.find(id: model.id)
      end
    end
  end
end

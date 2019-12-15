# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from Exception do |e|
    log.error "#{e.message}"
    render json: {error: e.message}, status: :internal_error
  end
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: e.message}, status: :not_found
  end
  rescue_from CanCan::AccessDenied do |e|
    render json: {error: e.message}, status: :unauthorized
  end


  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  private

  def validation_error(resource)
    error_response(:bad_request, resource.errors)
  end

  def role_access_denied
    error_response(:unauthorized, 'Access denied')
  end

  def record_not_found
    error_response(:not_found, 'Resource not found')
  end

  def error_response(status, details)
    render json: {
      errors: [
        {
          status: status,
          detail: details
        }
      ]
    }, status: status
  end
end
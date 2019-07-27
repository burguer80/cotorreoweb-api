# frozen_string_literal: true

class ApplicationController < ActionController::API
  # include ::ActionController::Serialization
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from CanCan::AccessDenied, with: :role_access_denied


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
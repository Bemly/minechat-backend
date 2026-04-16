require_relative "../views/errors/error_page"

class ErrorsController < ApplicationController
  def not_found
    render Errors::NotFound.new, status: :not_found
  end

  def unprocessable_entity
    render Errors::UnprocessableEntity.new, status: :unprocessable_entity
  end

  def internal_server_error
    render Errors::InternalServerError.new, status: :internal_server_error
  end
end

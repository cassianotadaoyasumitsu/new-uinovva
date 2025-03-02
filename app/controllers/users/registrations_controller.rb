class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new
    build_resource({})
    # Build an associated company if one doesn't exist
    resource.build_company unless resource.company
    respond_with resource
  end

  protected

  def configure_permitted_parameters
    # Permit company_attributes so that a new company can be created along with the user
    devise_parameter_sanitizer.permit(:sign_up, keys: [company_attributes: [:name]])
  end

  # Optional: Override build_resource if you want to ensure a new Company instance is built
  def build_resource(hash = {})
    if params[:user].present? && params[:user][:company_attributes].present?
      hash[:company_attributes] ||= {}
    end
    super
  end

end

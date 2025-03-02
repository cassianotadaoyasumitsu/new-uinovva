class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_owner

  def index
    @users = current_user.company.users
  end

  def new
    @user = current_user.company.users.new
  end

  def create
    # Build a new user under the current company, using permitted params
    @user = current_user.company.users.new(user_params)

    # Optionally, you may restrict role selection to manager or regular (if you don't want admin creation here)
    if @user.save
      redirect_to users_path, notice: "User created successfully."
    else
      render :new
    end
  end

  private

  def require_owner
    redirect_to root_path, alert: 'Access Denied' unless current_user.owner?
  end

  def user_params
    # Do not permit company_id so it’s automatically set from current_user.company
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end
end

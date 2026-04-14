class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /api/users
  def index
    @users = User.all
    marshal_render(@users)
  end

  # GET /api/users/:id
  def show
    marshal_render(@user)
  end

  # POST /api/users
  def create
    @user = User.new(user_params)
    if @user.save
      marshal_render(@user, status: :created)
    else
      marshal_render({ errors: @user.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/users/:id
  def update
    if @user.update(user_params)
      marshal_render(@user)
    else
      marshal_render({ errors: @user.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # DELETE /api/users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    marshal_render({ error: "User not found" }, status: :not_found)
  end

  def user_params
    params.require(:user).permit(:username, :nickname, :email, :passwd, :online_status)
  end
end

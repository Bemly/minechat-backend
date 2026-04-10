class UsersController < ApplicationController
  def index
    @users = fetch_users
  end

  def show
    @user = fetch_user(params[:id])
  end

  def new
    @user = {}
  end

  def create
    response = ApiClient.create_user(user_params)
    if response&.dig("data")
      redirect_to users_path, notice: "用户创建成功"
    else
      @user = user_params
      @errors = response&.dig("errors") || ["创建失败"]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = fetch_user(params[:id])
  end

  def update
    response = ApiClient.update_user(params[:id], user_params)
    if response&.dig("data")
      redirect_to users_path, notice: "用户更新成功"
    else
      @user = fetch_user(params[:id])
      @errors = response&.dig("errors") || ["更新失败"]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ApiClient.destroy_user(params[:id])
    redirect_to users_path, notice: "用户已删除"
  end

  private

  def fetch_users
    response = ApiClient.users
    response&.dig("data") || []
  rescue StandardError
    []
  end

  def fetch_user(id)
    response = ApiClient.user(id)
    response&.dig("data") || {}
  rescue StandardError
    {}
  end

  def user_params
    params.require(:user).permit(:username, :nickname, :email, :passwd, :online_status)
  end
end

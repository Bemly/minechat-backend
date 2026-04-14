class UsersController < ApplicationController
  def index
    render Users::Index.new(users: User.all)
  end

  def show
    @user = User.find(params[:id])
    render Users::Show.new(user: @user)
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "用户不存在"
  end

  def new
    render Users::New.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "用户创建成功"
    else
      render Users::New.new(user: @user, errors: @user.errors.full_messages), status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
    render Users::Edit.new(user: @user)
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "用户不存在"
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: "用户更新成功"
    else
      render Users::Edit.new(user: @user, errors: @user.errors.full_messages), status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "用户不存在"
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, notice: "用户已删除"
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "用户不存在"
  end

  private

  def user_params
    params.require(:user).permit(:username, :nickname, :email, :passwd, :online_status)
  end
end

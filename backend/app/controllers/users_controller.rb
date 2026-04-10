class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    # 使用 UserSerializer 序列化 @users 集合
    # include: [:created_rooms, :rooms] 是可选的，用于包含关联数据
    render json: UserSerializer.new(@users, include: [:created_rooms, :rooms]).serializable_hash
  end

  # GET /users/:id
  def show
    # 使用 UserSerializer 序列化单个 @user 对象
    render json: UserSerializer.new(@user, include: [:created_rooms, :rooms]).serializable_hash
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: UserSerializer.new(@user).serializable_hash, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    head :no_content # 返回 204 No Content，表示成功删除
  end

  private

  # 在 show, update, destroy 动作前设置用户
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  # 强参数 (Strong Parameters)
  def user_params
    # 允许的参数，注意这里包含 passwd。
    # 实际项目中，如果你有注册和登录流程，
    # 注册时可能需要 passwd，更新时则不需要或通过单独的密码更新端点处理。
    params.require(:user).permit(:username, :nickname, :email, :passwd, :online_status)
  end

end

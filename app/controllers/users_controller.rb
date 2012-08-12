class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :show]
  before_filter :is_admin, only: [:index, :destroy]

  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    if !signed_in?
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to EnableMe - why don't you get started by Rating some Games"
        redirect_to @user
      else
        render 'new'
      end
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def index
    @users = User.paginate(order: 'steam_name', page: params[:page])
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in to your account"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def is_admin
      redirect_to root_path unless current_user.admin?
    end

end

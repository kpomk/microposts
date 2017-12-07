class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show,:followings, :followers, :favorites]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user=User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success]= 'ユーザー登録に成功しました'
      redirect_to @user
    
    else
      flash.now[:danger]= 'ユーザー登録失敗'
      render :new
    end  
  end


  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def favorites
    @micropost = Micropost.find(params[:id])
    @favorites = @micropost.favorites.page(params[:page])
    counts(@micropost)
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_digest)
  end
end
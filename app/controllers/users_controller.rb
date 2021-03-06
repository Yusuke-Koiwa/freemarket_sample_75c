class UsersController < ApplicationController
  before_action :authenticate_user, only: :show
  before_action :set_profile, only: [:edit_profile, :update_profile]
  before_action :set_address, only: [:edit_address, :update_address]
  layout 'no_flash'

  def show
  end

  def sell_items
    @sell_items = current_user.items.order("created_at DESC").page(params[:page]).per(5)
  end

  def bought_items
    @bought_items = current_user.buyed_items.page(params[:page]).per(5)
  end

  def favorite_items
    @favorite_items = Item.joins(:favorites).where(favorites: {user_id: current_user}).page(params[:page]).per(5)
  end

  def edit_profile
  end

  def update_profile
    @profile.update(profile_params)
    if @profile.save
      flash[:notice] = "変更内容が保存されました"
      redirect_to edit_profile_users_path
    else
      render :edit_profile
    end
  end

  def edit_address
  end

  def update_address
    @address.update(address_params)
    if @address.save
      flash[:notice] = "変更内容が保存されました"
      redirect_to edit_address_users_path
    else
      render :edit_address
    end
  end

  private

  def authenticate_user
    unless user_signed_in? && current_user == User.find(params[:id])
      redirect_to root_path
    end
  end

  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :birthday)
  end

  def set_address
    @address = current_user.address
  end

  def address_params
    params.require(:address).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :post_number, :prefecture_id, :city, :house_number, :building_name, :phone_number)
  end

end
